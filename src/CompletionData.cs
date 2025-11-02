using System.Diagnostics.CodeAnalysis;
using System.Management.Automation;

namespace MT.Comp;

public abstract class CompletionData
{
    protected string prefix = string.Empty;
    protected string text = string.Empty;
    protected string description = string.Empty;
    protected string itemText = string.Empty;
    protected string tooltip = string.Empty;
    protected string tooltipPrefix = string.Empty;
    protected CompletionResultType resultType;

    public string CompletionText => $"{prefix}{text}";
    public string ListItemText => string.IsNullOrEmpty(description) ? itemText : $"{itemText}  ({description})";
    public CompletionResultType ResultType => resultType;
    public string Tooltip => string.IsNullOrEmpty(description) ? $"{tooltipPrefix}{tooltip}" : $"{tooltipPrefix}{tooltip} - {description}";

    /// <summary>
    /// Get formated string for <see cref="CompletionResult.ListItemText"/>.
    /// </summary>
    protected string GetListItemTextRightAligned(int cellWidth)
    {
        if (string.IsNullOrEmpty(description))
        {
            return itemText;
        }
        var descWidth = description.Length;
        var spaceWidth = cellWidth - itemText.Length - descWidth - 5;
        return spaceWidth < 0
            ? $"{itemText} {PSStyle.Instance.Foreground.White}({PSStyle.Instance.Foreground.Yellow}{PSStyle.Instance.Italic}{
                description[0..(descWidth + spaceWidth - 1)]}…{PSStyle.Instance.ItalicOff}{PSStyle.Instance.Foreground.White})"
            : $"{itemText} {new string(' ', spaceWidth)}{PSStyle.Instance.Foreground.White}({PSStyle.Instance.Foreground.Yellow}{PSStyle.Instance.Italic}{
                description}{PSStyle.Instance.ItalicOff}{PSStyle.Instance.Foreground.White})";
    }

    internal int ListItemLength => itemText.Length + description.Length + 5;

    protected void SetText(string text)
    {
        this.text = text;
        this.itemText = text;
        this.tooltip = text;
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

    public CompletionResult Build()
    {
        return new(CompletionText, ListItemText, ResultType, Tooltip);
    }

    public CompletionResult Build(int maxLength)
    {
        return new(CompletionText,
                   GetListItemTextRightAligned(maxLength),
                   resultType,
                   Tooltip);
    }

    public bool IsMatch(ReadOnlySpan<char> value, bool ignoreCase = false)
    {
        if (value.IsEmpty)
            return true;

        return text.AsSpan().StartsWith(value, ignoreCase ? StringComparison.OrdinalIgnoreCase : StringComparison.Ordinal);
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
        SetText(text);
        this.resultType = CompletionResultType.ParameterValue;
    }
    public CompletionValue(string text, string description)
    {
        ArgumentException.ThrowIfNullOrEmpty(text, nameof(text));
        SetText(text);
        this.description = description;
        this.resultType = CompletionResultType.ParameterValue;
    }
    public CompletionValue(object[] textAndDescription)
    {
        ArgumentOutOfRangeException.ThrowIfLessThan(textAndDescription.Length, 2, nameof(textAndDescription));
        var text = textAndDescription[0].ToString();
        ArgumentException.ThrowIfNullOrEmpty(text);
        var description = textAndDescription[1].ToString();
        ArgumentNullException.ThrowIfNull(description);
        SetText(text);
        this.description = description;
        this.resultType = CompletionResultType.ParameterValue;
    }

    public string Text { get => text; set => SetText(value); }
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
        cv.tooltip = $"[{result.ResultType}] {result.ToolTip}";
        return cv;
    }
}
