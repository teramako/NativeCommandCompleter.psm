using System.Management.Automation;

namespace MT.Comp;

public static class Config
{
    /// <summary>
    /// Minimum number of divisions in the completion menu
    /// </summary>
    /// <seealso cref="CompletionDataCollection.Build"/>
    public static int MinimumCompletionMenuDivisons
    {
        get => _minimumCompletionMenuDivisions;
        set
        {
            ArgumentOutOfRangeException.ThrowIfLessThan(value, 1);
            _minimumCompletionMenuDivisions = value;
        }
    }
    /// <inheritdoc cref="MinimumCompletionMenuDivisons"/>
    private static int _minimumCompletionMenuDivisions = 1;

    /// <summary>
    /// Decoration start of the description part in the complementary menu item
    /// </summary>
    /// <seealso cref="CompletionData.GetListItemTextRightAligned(int)"/>
    public static string ListItemDescriptionStart { get; set; } =
        $"{PSStyle.Instance.Foreground.White}({PSStyle.Instance.Foreground.Yellow}{PSStyle.Instance.Italic}";

    /// <summary>
    /// Decoration end of the description part in the complementary menu item
    /// </summary>
    /// <seealso cref="CompletionData.GetListItemTextRightAligned(int)"/>
    public static string ListItemDescriptionEnd { get; set; } =
        $"{PSStyle.Instance.ItalicOff}{PSStyle.Instance.Foreground.White})";

    /// <summary>
    /// Whether to show description in the completion menu item
    /// </summary>
    public static bool ShowDescriptionInListItem { get; set; } = true;
}
