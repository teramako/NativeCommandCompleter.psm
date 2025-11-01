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
        var maxLength = this.Max(c => c.ListItemLength);
        foreach (var d in this)
        {
            yield return d.Build(maxLength);

        }
    }
}
