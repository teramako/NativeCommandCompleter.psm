using System.Diagnostics.CodeAnalysis;
using System.Management.Automation;
using System.Management.Automation.Host;

namespace Sabamiso;

public abstract class CompletionData
{
    protected string prefix = string.Empty;
    protected string text = string.Empty;
    protected string description = string.Empty;
    protected string itemText = string.Empty;
    protected string tooltip = string.Empty;
    protected string tooltipPrefix = string.Empty;
    protected CompletionResultType resultType;
    protected ArgumentElementType elementType = ArgumentElementType.String;
    protected bool isValueAdjacentToParameter = false;

    public string Text => text;
    // public string ListItemText => string.IsNullOrEmpty(description) ? itemText : $"{itemText}  ({description})";
    public string ListItemText => itemText;
    public CompletionResultType ResultType => resultType;
    public string Tooltip => $"{tooltipPrefix}{tooltip}";

    /// <summary>
    /// Get formated string for <see cref="CompletionResult.ListItemText"/>.
    /// </summary>
    protected string GetListItemTextRightAligned(PSHost host, int cellWidth)
    {
        if (string.IsNullOrEmpty(description))
        {
            return itemText;
        }
        var descWidth = host.UI.RawUI.LengthInBufferCells(description);
        var spaceWidth = cellWidth - GetListItemLength(host);
        if (spaceWidth >= 0)
        {
            return $"{itemText} {new string(' ', spaceWidth)}{Config.ListItemDescriptionStart}{description}{Config.ListItemDescriptionEnd}";
        }
        else if (descWidth + spaceWidth - 1 > 0)
        {
            var descCellLength = descWidth + spaceWidth - 1;
            var desc = CropToCellLength(description, host, 0, descCellLength, out var actualLength);
            var spaces = new string(' ', 1 + descCellLength - actualLength);
            return $"{itemText}{spaces}{Config.ListItemDescriptionStart}{desc}…{Config.ListItemDescriptionEnd}";
        }
        else
        {
            return itemText;
        }
    }

    private static string CropToCellLength(string value, PSHost host, int start, int cellLength, out int actualCellLength)
    {
        Span<char> newStr = new char[value.Length];
        actualCellLength = 0;
        int charIndex = 0;
        for (var i = start; i < value.Length - start; i++)
        {
            var c = value[i];
            var cLength = host.UI.RawUI.LengthInBufferCells(c);
            if (actualCellLength + cLength > cellLength)
                break;

            if (char.IsSurrogate(c))
            {
                i++;
                cLength += host.UI.RawUI.LengthInBufferCells(value[i]);
                if (actualCellLength + cLength > cellLength)
                    break;
                newStr[charIndex++] = c;
                newStr[charIndex++] = value[i];
            }
            else
            {
                newStr[charIndex++] = c;
            }
            actualCellLength += cLength;
        }

        return newStr[..charIndex].ToString();
    }

    internal int GetListItemLength(PSHost host)
    {
        return host.UI.RawUI.LengthInBufferCells(itemText)
               + host.UI.RawUI.LengthInBufferCells(description)
               + /* space & paren */ 3
               + /* mergin */ 2;
    }
    internal int GetListItemRawLength(PSHost host)
    {
        return host.UI.RawUI.LengthInBufferCells(itemText)
               + /* margin */ 2;
    }

    /// <summary>
    /// Configures settings related to whether quotation marks should be added.
    /// </summary>
    /// <param name="elementType">
    /// Indicates whether the original input value (before completion) was enclosed in quotes.
    /// <para>
    /// This setting only takes effect when the value was originally one of:
    /// <list type="bullet">
    ///     <item><see cref="ArgumentElementType.StringSingleQuoted"/></item>
    ///     <item><see cref="ArgumentElementType.StringDoubleQuoted"/></item>
    /// </list>
    /// </para>
    /// </param>
    /// <param name="isValueAdjacentToParameter">
    /// Indicates whether the value is directly adjacent to a PowerShell-style parameter
    /// (for example <c>-i.bak</c>), where PowerShell may incorrectly treat part of the
    /// value as part of the parameter name.
    /// <para>
    /// This flag does <b>not</b> refer to Sabamiso's own parameter model (e.g. <c>--opt</c>).
    /// It refers specifically to PowerShell's native parameter syntax that begins with a
    /// single dash (<c>-</c>).
    /// </para>
    /// <para>
    /// When this flag is true, quoting rules become stricter to avoid PowerShell's
    /// tokenization issue described in:
    /// https://github.com/PowerShell/PowerShell/issues/6291
    /// </para>
    /// </param>
    public CompletionData SetType(ArgumentElementType elementType, bool isValueAdjacentToParameter = false)
    {
        this.elementType = elementType;
        this.isValueAdjacentToParameter = isValueAdjacentToParameter;
        return this;
    }
    public void SetOptions(string prefix = "",
                           string tooltipPrefix = "",
                           ArgumentElementType elementType = ArgumentElementType.String,
                           bool isValueAdjacentToParameter = false)
    {
        this.prefix = prefix;
        this.tooltipPrefix = tooltipPrefix;
        this.elementType = elementType;
        this.isValueAdjacentToParameter = isValueAdjacentToParameter;
    }

    public CompletionData SetPrefix(string prefix)
    {
        this.prefix = prefix;
        return this;
    }
    public CompletionData SetTooltipPrefix(string prefix)
    {
        this.tooltipPrefix = prefix;
        return this;
    }

    /// <summary>
    /// Build <see cref="CompletionResult"/>
    /// </summary>
    /// <returns></returns>
    public CompletionResult Build()
    {
        return new(BuildText(), ListItemText, ResultType, Tooltip);
    }

    /// <summary>
    /// Build <see cref="CompletionResult"/> with specified max length for list item text.
    /// </summary>
    /// <param name="host"></param>
    /// <param name="maxLength"></param>
    /// <returns></returns>
    public CompletionResult Build(PSHost host, int maxLength)
    {
        return new(BuildText(),
                   GetListItemTextRightAligned(host, maxLength),
                   resultType,
                   Tooltip);
    }

    public bool IsMatch(ReadOnlySpan<char> value, bool ignoreCase = false)
    {
        if (value.IsEmpty)
            return true;

        return text.AsSpan().StartsWith(value, ignoreCase ? StringComparison.OrdinalIgnoreCase : StringComparison.Ordinal);
    }

    public void QuoteText(char q = '\'')
    {
        var value = text.AsSpan();
        if (!value.IsEmpty && value[0] is '\'' or '"')
        {
            return;
        }
        var trimedValue = value.TrimEnd();
        text = $"{q}{trimedValue}{q}{value[trimedValue.Length..]}";
    }

    /// <summary>
    /// token-breaking characters of PowerShell
    /// </summary>
    private const string MetaChars = "\"'{}()<>;|& ";
    /// <summary>
    /// token-breaking characters of PowerShell
    /// <para>
    /// This is a workaround for PowerShell's parsing behavior described in:
    /// https://github.com/PowerShell/PowerShell/issues/6291
    /// When a parameter and its value are adjacent (e.g. <c>-i.bak</c>),
    /// PowerShell may incorrectly treat the value as part of the parameter name.
    /// To avoid this, values containing <c>.</c> must be quoted.
    /// </para>
    /// </summary>
    private const string MetaChars2 = ".\"'{}()<>;|& ";

    private static bool NeedsQuoting(ReadOnlySpan<char> rawText, bool isValueAdjacentToParameter = false)
    {
        if (rawText.IsEmpty)
            return false;

        if (IsFullyQuoted(rawText))
            return false;

        if (isValueAdjacentToParameter && rawText.ContainsAny(MetaChars2))
            return true;

        if (rawText.ContainsAny(MetaChars))
            return true;

        return false;
    }
    private static bool IsFullyQuoted(ReadOnlySpan<char> text)
    {
        if (text.Length < 2)
            return false;

        char first = text[0];
        char last = text[^1];

        if (first != last)
            return false;

        if (first != '\'' && first != '"')
            return false;

        return true;
    }

    private string BuildText()
    {
        ReadOnlySpan<char> textAll = this.text;
        ReadOnlySpan<char> text = textAll.TrimEnd();
        ReadOnlySpan<char> tailingSpaces = textAll[text.Length..];

        if (elementType is ArgumentElementType.StringSingleQuoted)
            return $"{Helper.Quote('\'', prefix, text)}{tailingSpaces}";

        if (elementType is ArgumentElementType.StringDoubleQuoted)
            return $"{Helper.Quote('"', prefix, text)}{tailingSpaces}";

        if (NeedsQuoting(text, isValueAdjacentToParameter))
            return $"{prefix}{Helper.Quote('\'', text)}{tailingSpaces}";

        return $"{prefix}{text}{tailingSpaces}";
    }
}

/// <summary>
/// An intermediate class to create a <see cref="CompletionResult"/> for Parameter name
/// </summary>
internal class CompletionParam : CompletionData
{
    public CompletionParam(string text, string description, string listItem, string tooltip)
    {
        this.text = text;
        this.description = description;
        this.itemText = listItem;
        this.tooltip = tooltip;
        this.resultType = CompletionResultType.ParameterName;
    }
}

/// <summary>
/// An intermediate class to create a <see cref="CompletionResult"/> for Parameter value
/// </summary>
public class CompletionValue : CompletionData, ISpanParsable<CompletionValue>
{
    public CompletionValue()
    {
        this.resultType = CompletionResultType.ParameterValue;
    }
    public CompletionValue(string text)
    {
        ArgumentException.ThrowIfNullOrEmpty(text, nameof(text));
        this.text = text;
        this.itemText = text;
        this.tooltip = text;
        this.resultType = CompletionResultType.ParameterValue;
    }
    public CompletionValue(string text, string description)
    {
        ArgumentException.ThrowIfNullOrEmpty(text, nameof(text));
        this.text = text;
        this.itemText = text;
        this.description = description;
        this.tooltip = description;
        this.resultType = CompletionResultType.ParameterValue;
    }
    public CompletionValue(object[] textAndDescription)
    {
        ArgumentOutOfRangeException.ThrowIfLessThan(textAndDescription.Length, 2, nameof(textAndDescription));
        var text = textAndDescription[0].ToString();
        ArgumentException.ThrowIfNullOrEmpty(text);
        var description = textAndDescription[1].ToString();
        ArgumentNullException.ThrowIfNull(description);
        this.text = text;
        this.itemText = text;
        this.description = description;
        this.tooltip = description;
        this.resultType = CompletionResultType.ParameterValue;
    }
    public CompletionValue(string text,
                           string description,
                           string listItem,
                           string tooltip,
                           CompletionResultType resultType = CompletionResultType.ParameterValue)
    {
        this.text = text;
        this.description = description;
        this.itemText = listItem;
        this.tooltip = tooltip;
        this.resultType = resultType;
    }

    public string Description { get => description; set => description = value; }

    private static readonly char[] Separators = ['\t', '\n', '\r'];

    public static CompletionValue Parse(ReadOnlySpan<char> s, IFormatProvider? provider = null)
    {
        if (s.IsEmpty)
            throw new ArgumentException("Empty is not allowed", nameof(s));
        var sepPosition = s.IndexOfAny(Separators);
        if (sepPosition > 0)
        {
            return new(s[..sepPosition].ToString(), s[(sepPosition + 1)..].TrimStart(Separators).ToString());
        }
        return new(s.ToString());
    }

    /// <inheritdoc cref="TryParse(ReadOnlySpan{char}, IFormatProvider?, out CompletionValue)"/>
    public static bool TryParse(ReadOnlySpan<char> s, [MaybeNullWhen(false)] out CompletionValue result)
    {
        return TryParse(s, null, out result);
    }
    public static bool TryParse(ReadOnlySpan<char> s, IFormatProvider? provider, [MaybeNullWhen(false)] out CompletionValue result)
    {
        result = default;
        if (s.IsEmpty)
            return false;
        var sepPosition = s.IndexOfAny(Separators);
        result = sepPosition > 0
            ? new(s[..sepPosition].ToString(), s[(sepPosition + 1)..].TrimStart(Separators).ToString())
            : new(s.ToString());
        return true;
    }

    public static CompletionValue Parse(string s, IFormatProvider? provider = null)
    {
        return Parse(s.AsSpan(), provider);
    }

    public static bool TryParse([NotNullWhen(true)] string? s, IFormatProvider? provider, [MaybeNullWhen(false)] out CompletionValue result)
    {
        return TryParse(s.AsSpan(), provider, out result);
    }

    public static CompletionValue FromCommpletionResult(CompletionResult result)
    {
        return FromCommpletionResult(result, ReadOnlySpan<char>.Empty);
    }

    public static CompletionValue FromCommpletionResult(CompletionResult result, ReadOnlySpan<char> prefix)
    {
        CompletionValue cv = new();
        cv.prefix = prefix.ToString();
        cv.text = result.CompletionText;
        cv.itemText = result.ListItemText;
        cv.resultType = result.ResultType;
        cv.tooltip = result.ToolTip;
        return cv;
    }
}
