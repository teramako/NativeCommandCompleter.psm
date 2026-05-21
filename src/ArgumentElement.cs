using System.Collections.Immutable;
using System.Management.Automation.Language;

namespace Sabamiso;

/// <summary>
/// A argument element generated from tokens
/// </summary>
/// <seealso cref="Tokenizer"/>
public class ArgumentElement
{
    /// <summary>
    /// Tokens that make up the argument element
    /// </summary>
    public ImmutableArray<Token> Tokens { get; }

    /// <summary>
    /// String value of the argument.
    /// </summary>
    /// <remarks>
    /// This is not the input value itself, but the value escaped characters have been expanded.
    /// </remarks>
    public string Value { get; }

    /// <summary>
    /// Starting position from the command-line
    /// </summary>
    public int StartOffset { get; }

    /// <summary>
    /// End position from the command-line
    /// </summary>
    public int EndOffset { get; }

    /// <summary>
    /// Value's length
    /// </summary>
    public int Length => Value.Length;

    /// <summary>
    /// Indicates whether the input value is actually empty.
    /// </summary>
    /// <remarks>
    /// In cases where the input value is <c>""</c> or <c>''</c>, it will return <see langword="false"/>.
    /// </remarks>
    public bool IsEmpty => StartOffset == EndOffset;

    public char this[int i] => Value[i];
    public ReadOnlySpan<char> this[Range range] => Value.AsSpan(range);

    /// <summary>
    /// This argument type
    /// </summary>
    public ArgumentElementType Type { get; }

    public Range Range => StartOffset..EndOffset;

    public ReadOnlySpan<char> GetRawValue(string commandLine) => commandLine.AsSpan(Range);

    /// <inheritdoc cref="String.StartsWith(string, StringComparison)"/>
    public bool StartsWith(ReadOnlySpan<char> value, StringComparison comparisonType) => Value.StartsWith(value, comparisonType);

    /// <inheritdoc cref="String.EndsWith(string, StringComparison)"/>
    public bool EndsWith(ReadOnlySpan<char> value, StringComparison comparisonType) => Value.EndsWith(value, comparisonType);

    /// <summary>
    /// Create a virtual argument (empty value) positioned <paramref name="cursorPosition"/>.
    /// </summary>
    /// <seealso cref="ArgumentElement.CreateEmptyArgument(int)"/>
    private ArgumentElement(int cursorPosition)
    {
        Tokens = ImmutableArray<Token>.Empty;
        StartOffset = cursorPosition;
        EndOffset = cursorPosition;
        Value = string.Empty;
        Type = ArgumentElementType.String;
    }

    /// <summary>
    /// Create an argument from a single token.
    /// </summary>
    /// <param name="token"></param>
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

    /// <summary>
    /// Create an argument from tokens.
    /// </summary>
    /// <param name="cmdline"></param>
    /// <param name="tokens"></param>
    /// <param name="isArrayLiteral"></param>
    public ArgumentElement(string cmdline, ImmutableArray<Token> tokens, bool isArrayLiteral = false)
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
            Type = isArrayLiteral
                ? ArgumentElementType.ArrayLiteral
                : tokens[0].Kind switch
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

    /// <summary>
    /// Create a virtual argument (empty value) positioned <paramref name="cursorPosition"/>.
    /// </summary>
    /// <param name="cursorPosition"></param>
    public static ArgumentElement CreateEmptyArgument(int cursorPosition) => new(cursorPosition);
}
