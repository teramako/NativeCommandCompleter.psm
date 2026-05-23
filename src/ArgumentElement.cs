using System.Collections.Immutable;
using System.Management.Automation.Language;

namespace Sabamiso;

/// <summary>
/// A argument element generated from tokens
/// </summary>
/// <param name="Tokens">Tokens that make up the argument element</param>
/// <param name="Value">String value of the argument. This is not the input value itself, but the value escaped characters have been expanded.</param>
/// <param name="Range">The range of this argument within the command line.</param>
/// <param name="Type">This argument type.</param>
/// <param name="ArrayElements"></param>
/// <seealso cref="Tokenizer"/>
public readonly record struct ArgumentElement(ImmutableArray<Token> Tokens,
                                              string Value,
                                              Range Range,
                                              ArgumentElementType Type,
                                              ImmutableArray<Range>? ArrayElements = null)
{
    /// <summary>
    /// Starting position from the command-line
    /// </summary>
    public int StartOffset => Range.Start.Value;

    /// <summary>
    /// End position from the command-line
    /// </summary>
    public int EndOffset => Range.End.Value;

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

    public ReadOnlySpan<char> GetRawValue(string commandLine) => commandLine.AsSpan(Range);

    /// <inheritdoc cref="String.StartsWith(string, StringComparison)"/>
    public bool StartsWith(ReadOnlySpan<char> value, StringComparison comparisonType) => Value.StartsWith(value, comparisonType);

    /// <inheritdoc cref="String.EndsWith(string, StringComparison)"/>
    public bool EndsWith(ReadOnlySpan<char> value, StringComparison comparisonType) => Value.EndsWith(value, comparisonType);

    /// <summary>
    /// Create an argument from a single token.
    /// </summary>
    /// <param name="token"></param>
    public static ArgumentElement Create(Token token)
    {
        var rawValue = token.Text;
        (string value, ArgumentElementType type) = token switch
        {
            StringExpandableToken stringExpandableToken =>
                (stringExpandableToken.Value,
                 rawValue.StartsWith('"') ? ArgumentElementType.StringDoubleQuoted : ArgumentElementType.String),
            StringLiteralToken stringLiteralToken => 
                (stringLiteralToken.Value,
                 rawValue.StartsWith('\'') ? ArgumentElementType.StringSingleQuoted : ArgumentElementType.String),
            NumberToken numberToken => (rawValue, ArgumentElementType.Number),
            VariableToken variableToken => (rawValue, ArgumentElementType.VariableExpression),
            _ => (token.Text, ArgumentElementType.String)
        };
        return new(ImmutableArray.Create(token), value, token.Extent.StartOffset..token.Extent.EndOffset, type);
    }

    /// <summary>
    /// Create an argument from tokens.
    /// </summary>
    /// <param name="cmdline"></param>
    /// <param name="tokens"></param>
    /// <param name="arrayRnages"></param>
    public static ArgumentElement Create(string cmdline, ImmutableArray<Token> tokens, ImmutableArray<Range>? arrayRnages = null)
    {
        ArgumentOutOfRangeException.ThrowIfZero(tokens.Length, nameof(tokens));
        if (tokens.Length == 1)
        {
            return Create(tokens[0]);
        }

        var range = tokens[0].Extent.StartOffset..tokens[^1].Extent.EndOffset;
        var value = cmdline[range];
        var type = arrayRnages is not null and { Length: > 0 }
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
        return new(tokens, value, range, type, arrayRnages);
    }

    /// <summary>
    /// Create a virtual argument (empty value) positioned <paramref name="cursorPosition"/>.
    /// </summary>
    /// <param name="cursorPosition"></param>
    public static ArgumentElement CreateEmptyArgument(int cursorPosition) =>
        new(ImmutableArray<Token>.Empty, string.Empty, cursorPosition..cursorPosition, ArgumentElementType.String);

}
