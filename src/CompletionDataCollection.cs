using System.Collections.ObjectModel;
using System.Management.Automation;

namespace MT.Comp;

/// <summary>
/// Collection to store completion data
/// </summary>
internal class CompletionDataCollection : Collection<CompletionData>
{
    /// <summary>
    /// Build completion data to <see cref="CompletionResult"/> and enumerate.
    /// </summary>
    public IEnumerable<CompletionResult> Build()
    {
        var maxHeight = Console.BufferHeight - 3;
        int divison = 1;
        if (Count > maxHeight)
        {
            divison = Math.Max((int)Math.Ceiling(1.0 * Count / maxHeight),
                               Config.MinimumCompletionMenuDivisons);
        }
        var maxLength = Math.Max(this.Max(c => c.ListItemRawLength),
                                 Math.Min(this.Max(c => c.ListItemLength),
                                          Console.BufferWidth / divison));
        foreach (var d in this)
        {
            yield return d.Build(maxLength);

        }
    }
}
