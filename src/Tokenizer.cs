using System.Collections.Immutable;
using System.Diagnostics;
using System.Management.Automation.Language;

namespace Sabamiso;

public static class Tokenizer
{
    [Conditional("DEBUG")]
    public static void Debug(string msg)
    {
        Console.Error.WriteLine($"=> {msg}");
    }
    public static IReadOnlyList<ArgumentElement> ReconstructArgv(CommandAst commandAst)
    {
        var commandLine = commandAst.ToString();
        _ = Parser.ParseInput(commandLine, null, out var tokens, out _);
        return ReconstructArgv(commandLine, tokens);
    }
    public static IReadOnlyList<ArgumentElement> ReconstuctArgv(string commandLine)
    {
        _ = Parser.ParseInput(commandLine, null, out var tokens, out _);
        return ReconstructArgv(commandLine, tokens);
    }
    private static IReadOnlyList<ArgumentElement> ReconstructArgv(string commandLine, Token[] tokens)
    {
        ArgumentOutOfRangeException.ThrowIfLessThanOrEqual(tokens.Length, 1, nameof(tokens));

        int index = 1;
        int startIndex = 1;

        var builder= ImmutableArray.CreateBuilder<ArgumentElement>();

        for (; index < tokens.Length; index++)
        {
            var t = tokens[index];

            switch (t.Kind)
            {
                case TokenKind.EndOfInput:
                case TokenKind.NewLine:
                    goto endLoop;
                case TokenKind.LParen:  // ( expression )
                    if (!char.IsWhiteSpace(commandLine[t.Extent.StartOffset - 1])
                        && tokens[startIndex].Kind is TokenKind.Variable)
                    {
                        index = ScanBalancedExpression(tokens, index, TokenKind.RParen, [TokenKind.LParen, TokenKind.AtParen, TokenKind.DollarParen]);
                    }
                    else
                    {
                        AddCurrentArgv();
                        (startIndex, index) = (index, ScanBalancedExpression(tokens, index, TokenKind.RParen, [TokenKind.LParen, TokenKind.AtParen, TokenKind.DollarParen]));
                        builder.Add(new(commandLine, tokens[startIndex..(index+1)].ToImmutableArray()));
                        startIndex = index + 1;
                    }
                    continue;
                case TokenKind.AtParen: // @( Array )
                case TokenKind.DollarParen: // $( expression )
                    AddCurrentArgv();
                    (startIndex, index) = (index, ScanBalancedExpression(tokens, index, TokenKind.RParen, [TokenKind.LParen, TokenKind.AtParen, TokenKind.DollarParen]));
                    AddArgv(new(commandLine, tokens[startIndex..(index+1)].ToImmutableArray()));
                    startIndex = index + 1;
                    continue;
                case TokenKind.LCurly:  // { ScriptBlock } 
                case TokenKind.AtCurly: // @{ Hashtable }
                    AddCurrentArgv();
                    (startIndex, index) = (index, ScanBalancedExpression(tokens, index, TokenKind.RCurly, [TokenKind.LCurly, TokenKind.AtCurly]));
                    continue;
                case TokenKind.StringLiteral:
                case TokenKind.StringExpandable:
                    AddCurrentArgv();
                    AddArgv(new(tokens[index]));
                    startIndex = index + 1;
                    continue;
                case TokenKind.LBracket:
                    if (!char.IsWhiteSpace(commandLine[t.Extent.StartOffset - 1])
                        && tokens[startIndex].Kind is TokenKind.Variable)
                    {
                        index = ScanBalancedExpression(tokens, index, TokenKind.RBracket, TokenKind.LBracket);
                    }
                    else
                    {
                        break;
                    }
                    continue;
                case TokenKind.Comma:
                    break;
                default:
                    break;
            }

            if (char.IsWhiteSpace(commandLine[t.Extent.StartOffset - 1]))
            {
                AddCurrentArgv();
                startIndex = index;
            }
        }
        endLoop:

        AddCurrentArgv();

        return builder.ToImmutableArray();

        void AddCurrentArgv()
        {
            if (startIndex < index)
            {
                ArgumentElement arg = new(commandLine, tokens[startIndex..index].ToImmutableArray());
                // AddEmptyArgv(arg);
                builder.Add(arg);
            }
        }
        void AddArgv(ArgumentElement arg)
        {
            // AddEmptyArgv(arg);
            builder.Add(arg);
        }
    }

    private static int ScanBalancedExpression(Token[] tokens, int index, TokenKind endKind, params scoped ReadOnlySpan<TokenKind> startKinds)
    {
        int level = 0;
        for (index += 1; index < tokens.Length; index++)
        {
            var t = tokens[index];
            if (startKinds.Contains(t.Kind))
            {
                level++;
            }
            else if (t.Kind == endKind)
            {
                if (level > 0)
                    level--;
                else
                    return index;
            }
        }
        return index;
    }
}
