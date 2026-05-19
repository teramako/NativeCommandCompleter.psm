using System.Collections.Immutable;
using System.Diagnostics;
using System.Management.Automation.Language;

namespace Sabamiso;

[Flags]
public enum ArgumentElementType
{
    String = 1 << 0,
    Number = 1 << 2,
    Expression = 1 << 3,

    DoubleQuoted = 1 << 4,
    SingleQuoted = 1 << 5,

    Variable = 1 << 6,
    Array = 1 << 7,
    Hashtable = 1 << 8,
    Nested = 1 << 9,

    StringDoubleQuoted = String | DoubleQuoted,
    StringSingleQuoted = String | SingleQuoted,

    VariableExpression = Expression | Variable,
    ArrayExpression = Expression | Array,
    HashtableExpression = Expression | Hashtable,
    NestedExpression = Expression | Nested,
}

public class ArgumentElement
{
    public ImmutableArray<Token> Tokens { get; }
    public string Value { get; }
    public int StartOffset { get; }
    public int EndOffset { get; }
    public ArgumentElementType Type { get; }
    public Range Range => StartOffset..EndOffset;
    public ReadOnlySpan<char> GetRawValue(string commandLine) => commandLine.AsSpan(Range);

    private ArgumentElement(int cursorPosition)
    {
        Tokens = ImmutableArray<Token>.Empty;
        StartOffset = cursorPosition;
        EndOffset = cursorPosition;
        Value = string.Empty;
        Type = ArgumentElementType.String;
    }
    public ArgumentElement(Token token)
    {
        Tokens = ImmutableArray.Create(token);
        StartOffset = token.Extent.StartOffset;
        EndOffset = token.Extent.EndOffset;

        var rawValue = token.Text;

        (Value, Type) = token switch
        {
            StringExpandableToken stringExpandableToken =>
                (stringExpandableToken.Value,
                 rawValue.StartsWith('"') ? ArgumentElementType.StringDoubleQuoted : ArgumentElementType.String),
            StringLiteralToken stringLiteralToken => 
                (stringLiteralToken.Value,
                 rawValue.StartsWith('\'') ? ArgumentElementType.StringSingleQuoted: ArgumentElementType.String),
            NumberToken numberToken => (rawValue, ArgumentElementType.Number),
            VariableToken variableToken => (rawValue, ArgumentElementType.VariableExpression),
            _ => (token.Text, ArgumentElementType.String)
        };
    }
    public ArgumentElement(string cmdline, ImmutableArray<Token> tokens)
    {
        ArgumentOutOfRangeException.ThrowIfZero(tokens.Length, nameof(tokens));
        Tokens = tokens;
        StartOffset = tokens[0].Extent.StartOffset;
        EndOffset = tokens[^1].Extent.EndOffset;

        if (tokens.Length == 1)
        {
            var token = tokens[0];
            var rawValue = token.Text;

            (Value, Type) = token switch
            {
                StringExpandableToken stringExpandableToken =>
                    (stringExpandableToken.Value,
                     rawValue.StartsWith('"') ? ArgumentElementType.StringDoubleQuoted : ArgumentElementType.String),
                StringLiteralToken stringLiteralToken => 
                    (stringLiteralToken.Value,
                     rawValue.StartsWith('\'') ? ArgumentElementType.StringSingleQuoted: ArgumentElementType.String),
                NumberToken numberToken => (rawValue, ArgumentElementType.Number),
                VariableToken variableToken => (rawValue, ArgumentElementType.VariableExpression),
                _ => (rawValue, ArgumentElementType.String)
            };
        }
        else
        {
            Value = cmdline[StartOffset..EndOffset];
            Type = tokens[0].Kind switch
            {
                TokenKind.LParen => ArgumentElementType.NestedExpression,
                TokenKind.DollarParen => ArgumentElementType.NestedExpression,
                TokenKind.AtParen => ArgumentElementType.ArrayExpression,
                TokenKind.AtCurly => ArgumentElementType.HashtableExpression,
                TokenKind.Variable => ArgumentElementType.VariableExpression,
                _ => ArgumentElementType.String,
            };
        }
    }

    public static ArgumentElement CreateEmptyArgument(int cursorPosition) => new(cursorPosition);
}

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
