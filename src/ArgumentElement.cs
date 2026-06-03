using System.Collections.Immutable;
using System.Management.Automation.Language;

namespace Sabamiso;

/// <summary>
/// A argument element generated from tokens
/// </summary>
/// <param name="Tokens">Tokens that make up the argument element</param>
/// <param name="Value">String value of the argument. This is not the input value itself, but the value escaped characters have been expanded.</param>
/// <param name="RawRange">The range of this argument within the command line.</param>
/// <param name="Type">This argument type.</param>
/// <param name="ArrayElements"></param>
/// <seealso cref="Tokenizer"/>
public readonly record struct ArgumentElement(string Value,
                                              ArgumentElementType Type,
                                              Range TokenRange,
                                              Range RawRange,
                                              ImmutableArray<Range>? ArrayElements = null)
{
    public readonly string Value { get => field ?? string.Empty; } = Value;

    /// <summary>
    /// Starting offset in the original command-line, based on RawRange.
    /// </summary>
    public readonly int StartOffset => RawRange.Start.Value;

    /// <summary>
    /// Ending offset in the original command-line, based on RawRange.
    /// </summary>
    public readonly int EndOffset => RawRange.End.Value;

    /// <summary>
    /// Value's length
    /// </summary>
    public readonly int Length => Value.Length;

    /// <summary>
    /// RawValue's length
    /// </summary>
    public readonly int RawLength => EndOffset - StartOffset;

    /// <summary>
    /// Indicates whether the <see cref="Value"/ is empty
    /// </summary>
    public readonly bool IsEmpty => Value.Length == 0;

    public readonly char this[int i] => Value[i];
    public readonly ReadOnlySpan<char> this[Range range] => Value.AsSpan(range);

    /// <inheritdoc cref="String.StartsWith(string, StringComparison)"/>
    public readonly bool StartsWith(ReadOnlySpan<char> value, StringComparison comparisonType) => Value.StartsWith(value, comparisonType);

    /// <inheritdoc cref="String.EndsWith(string, StringComparison)"/>
    public readonly bool EndsWith(ReadOnlySpan<char> value, StringComparison comparisonType) => Value.EndsWith(value, comparisonType);

    /// <summary>
    /// Reconstructs a PowerShell-valid string representation of this argument.
    /// </summary>
    /// <remarks>
    /// If <see cref="Type"/> is one of the following, the <see cref="Value"/> is
    /// enclosed in the corresponding quotation marks, and any quotation marks
    /// inside the content are escaped according to PowerShell rules:
    /// <list type="bullet">
    ///     <item><term><see cref="ArgumentElementType.StringSingleQuoted"/></term><description>enclosed in single quotes, internal <c>'</c> becomes <c>''</c></description></item>
    ///     <item><term><see cref="ArgumentElementType.StringDoubleQuoted"/></term><description>enclosed in double quotes, internal <c>"</c> becomes <c>""</c></description></item>
    /// </list>
    /// For all other types (e.g., bare words), <see cref="Value"/> is returned as-is.
    /// </remarks>
    public override string ToString() => RawLength == 0
            ? string.Empty
            : Type switch
            {
                ArgumentElementType.StringSingleQuoted => Helper.Quote('\'', Value),
                ArgumentElementType.StringDoubleQuoted => Helper.Quote('"', Value),
                _ => Value
            };

    /// <summary>
    /// Create an argument from a single token.
    /// </summary>
    /// <param name="token"></param>
    /// <param name="index"></param>
    public static ArgumentElement Create(Token token, int index)
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
        return new(value, type, index..(index + 1), token.Extent.StartOffset..token.Extent.EndOffset);
    }

    /// <summary>
    /// Create an argument from tokens.
    /// </summary>
    /// <param name="cmdline"></param>
    /// <param name="tokens"></param>
    /// <param name="arrayRnages"></param>
    public static ArgumentElement Create(string cmdline, int tokenStart, int tokenEnd, in ImmutableArray<Token> tokens, ImmutableArray<Range>? arrayRnages = null)
    {
        ArgumentOutOfRangeException.ThrowIfGreaterThan(tokenStart, tokenEnd);
        if (tokenStart == tokenEnd)
        {
            return Create(tokens[tokenStart], tokenStart);
        }

        var range = tokens[tokenStart].Extent.StartOffset..tokens[tokenEnd].Extent.EndOffset;
        var value = cmdline[range];
        var type = arrayRnages is not null and { Length: > 0 }
                   ? ArgumentElementType.ArrayLiteral
                   : tokens[tokenStart].Kind switch
                   {
                       TokenKind.LParen => ArgumentElementType.NestedExpression,
                       TokenKind.DollarParen => ArgumentElementType.NestedExpression,
                       TokenKind.AtParen => ArgumentElementType.ArrayExpression,
                       TokenKind.AtCurly => ArgumentElementType.HashtableExpression,
                       TokenKind.Variable => ArgumentElementType.VariableExpression,
                       _ => ArgumentElementType.String,
                   };
        return new(value, type, tokenStart..(tokenEnd + 1), range, arrayRnages);
    }
    public static ArgumentElement Create(string cmdline, Range tokenRange, in ImmutableArray<Token> tokens, ImmutableArray<Range>? arrayRnages = null)
        => Create(cmdline, tokenRange.Start.Value, tokenRange.End.Value - 1, tokens, arrayRnages);

    /// <summary>
    /// Create a virtual argument (empty value) positioned <paramref name="cursorPosition"/>.
    /// </summary>
    /// <param name="cursorPosition"></param>
    public static ArgumentElement CreateEmptyArgument(int cursorPosition) =>
        new(string.Empty, ArgumentElementType.String, default, cursorPosition..cursorPosition);

}
