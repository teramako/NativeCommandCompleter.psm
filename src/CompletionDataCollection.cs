using System.Collections.ObjectModel;
using System.Management.Automation;
using System.Management.Automation.Host;

namespace MT.Comp;

/// <summary>
/// Collection to store completion data
/// </summary>
internal class CompletionDataCollection : Collection<CompletionData>
{
    /// <summary>
    /// Build completion data to <see cref="CompletionResult"/> and enumerate.
    /// </summary>
    /// <param name="host">Host interface</param>
    public IEnumerable<CompletionResult> Build(PSHost host)
    {
        if (Config.ShowDescriptionInListItem
            && host.Name.Equals("ConsoleHost", StringComparison.OrdinalIgnoreCase)
            && host.UI.RawUI.BufferSize.Height > 0)
        {
            var maxHeight = host.UI.RawUI.BufferSize.Height - 3;
            int divison = 1;
            if (Count > maxHeight)
            {
                divison = Math.Max((int)Math.Ceiling(1.0 * Count / maxHeight),
                                   Config.MinimumCompletionMenuDivisons);
            }
            var maxLength = Math.Max(this.Max(c => c.GetListItemRawLength(host)),
                                     Math.Min(this.Max(c => c.GetListItemLength(host)),
                                              host.UI.RawUI.BufferSize.Width / divison));
            foreach (var d in this)
            {
                yield return d.Build(host, maxLength);

            }
        }
        else
        {
            foreach (var d in this)
            {
                yield return d.Build();
            }
        }
    }
}
