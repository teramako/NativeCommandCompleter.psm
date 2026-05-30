using System.Management.Automation;
using System.Collections.ObjectModel;

namespace Sabamiso;

/// <summary>
/// A command and parameter argument completer.
/// Dynamically generates completion candidates by <see cref="Script"/>
/// </summary>
public class ArgumentCompleterWithScript : ArgumentCompleterBase
{
    /// <summary>
    /// Script for dynamically generating autocomplete candidates
    /// </summary>
    public required ScriptBlock Script { get; init; }

    public override IEnumerable<CompletionData> Complete(CompletionContext context,
                                                         ReadOnlySpan<char> wordToComplete,
                                                         int offsetPosition,
                                                         int argumentIndex)
    {
        Collection<PSObject?>? invokeResults = null;
        try
        {
            invokeResults = Script.InvokeWithContext(null,
                                                     [new("this", context)],
                                                     $"{wordToComplete}",
                                                     offsetPosition,
                                                     argumentIndex);
            return NativeCompleter.PSObjectsToCompletionData(invokeResults);
        }
        catch
        {
        }
        return [];
    }
}
