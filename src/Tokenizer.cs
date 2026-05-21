using System.Collections.Immutable;
using System.Management.Automation.Language;

namespace Sabamiso;

public static class Tokenizer
{
    /// <summary>
    /// Reconstruct command arguments from <paramref name="commandAst"/>.
    /// <para>
    /// Generates an argument list for a native command based on the results of token analysis.
    /// </para>
    /// </summary>
    /// <param name="commandAst">AST built by PowerShell</param>
    public static IReadOnlyList<ArgumentElement> ReconstructArgv(CommandAst commandAst)
    {
        var commandLine = commandAst.ToString();
        _ = Parser.ParseInput(commandLine, null, out var tokens, out _);
        return ReconstructArgvImpl(commandLine, tokens);
    }

    /// <summary>
    /// Reconstruct command arguments from <paramref name="commandLine"/> string.
    /// <para>
    /// Generates an argument list for a native command based on the results of token analysis.
    /// </para>
    /// </summary>
    /// <param name="commandLine">Command-line string</param>
    public static IReadOnlyList<ArgumentElement> ReconstuctArgv(string commandLine)
    {
        _ = Parser.ParseInput(commandLine, null, out var tokens, out _);
        return ReconstructArgvImpl(commandLine, tokens);
    }

    private static IReadOnlyList<ArgumentElement> ReconstructArgvImpl(string commandLine, Token[] tokens)
    {
        ArgumentOutOfRangeException.ThrowIfLessThanOrEqual(tokens.Length, 1, nameof(tokens));

        int index = 1;
        int startIndex = 1;
        bool onArrayLiteral = false;

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
                        && (onArrayLiteral || tokens[startIndex].Kind is TokenKind.Variable))
                    {
                        index = ScanBalancedExpression(tokens, index, TokenKind.RParen, [TokenKind.LParen, TokenKind.AtParen, TokenKind.DollarParen]);
                    }
                    else
                    {
                        AddCurrentArgv();
                        (startIndex, index) = (index, ScanBalancedExpression(tokens, index, TokenKind.RParen, [TokenKind.LParen, TokenKind.AtParen, TokenKind.DollarParen]));
                        if (!IsOnArrayLiteral(index))
                        {
                            AddArgv(new(commandLine, tokens[startIndex..(index + 1)].ToImmutableArray()));
                            startIndex = index + 1;
                        }
                        // AddArgv(new(commandLine, tokens[startIndex..(index+1)].ToImmutableArray()));
                        // startIndex = index + 1;
                    }
                    continue;
                case TokenKind.AtParen: // @( Array )
                case TokenKind.DollarParen: // $( expression )
                    if (onArrayLiteral && !char.IsWhiteSpace(commandLine[t.Extent.StartOffset - 1]))
                    {
                        index = ScanBalancedExpression(tokens, index, TokenKind.RParen, [TokenKind.LParen, TokenKind.AtParen, TokenKind.DollarParen]);
                    }
                    else
                    {
                        AddCurrentArgv();
                        (startIndex, index) = (index, ScanBalancedExpression(tokens, index, TokenKind.RParen, [TokenKind.LParen, TokenKind.AtParen, TokenKind.DollarParen]));
                        if (!IsOnArrayLiteral(index))
                        {
                            AddArgv(new(commandLine, tokens[startIndex..(index + 1)].ToImmutableArray()));
                            startIndex = index + 1;
                        }
                        // AddArgv(new(commandLine, tokens[startIndex..(index+1)].ToImmutableArray()));
                        // startIndex = index + 1;
                    }
                    continue;
                case TokenKind.LCurly:  // { ScriptBlock } 
                case TokenKind.AtCurly: // @{ Hashtable }
                    if (char.IsWhiteSpace(commandLine[t.Extent.StartOffset - 1]))
                    {
                        AddCurrentArgv();
                        (startIndex, index) = (index, ScanBalancedExpression(tokens, index, TokenKind.RCurly, [TokenKind.LCurly, TokenKind.AtCurly]));
                    }
                    else
                    {
                        index = ScanBalancedExpression(tokens, index, TokenKind.RCurly, [TokenKind.LCurly, TokenKind.AtCurly]);
                    }
                    continue;
                case TokenKind.StringLiteral:
                case TokenKind.StringExpandable:
                    if (onArrayLiteral && !char.IsWhiteSpace(commandLine[t.Extent.StartOffset - 1]))
                    {
                        continue;
                    }
                    else
                    {
                        AddCurrentArgv();
                        if (IsOnArrayLiteral(index))
                        {
                            startIndex = index;
                        }
                        else
                        {
                            AddArgv(new(tokens[index]));
                            startIndex = index + 1;
                        }
                    }
                    // AddArgv(new(tokens[index]));
                    // startIndex = index + 1;
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
                    if (char.IsWhiteSpace(commandLine[t.Extent.StartOffset - 1]))
                    {
                        AddCurrentArgv();
                        startIndex = index;
                    }
                    else
                    {
                        onArrayLiteral = true;
                    }
                    continue;
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

        bool IsOnArrayLiteral(int index)
        {
            if (index + 1 < tokens.Length && tokens[index + 1].Kind is TokenKind.Comma)
            {
                var endOffset = tokens[index].Extent.EndOffset;
                if (endOffset < commandLine.Length)
                    return !char.IsWhiteSpace(commandLine[endOffset]);
            }
            return false;
        }

        void AddCurrentArgv()
        {
            if (startIndex < index)
            {
                ArgumentElement arg = new(commandLine, tokens[startIndex..index].ToImmutableArray(), onArrayLiteral);
                // AddEmptyArgv(arg);
                builder.Add(arg);
                onArrayLiteral = false;
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
