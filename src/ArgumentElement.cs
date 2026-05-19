using System.Collections.Immutable;
using System.Management.Automation.Language;

namespace Sabamiso;

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
