using System.Management.Automation;
using System.Collections.ObjectModel;

namespace MT.Comp;

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
                                                         ReadOnlySpan<char> tokenValue,
                                                         int offsetPosition,
                                                         int argumentIndex)
    {
        Collection<PSObject?>? invokeResults = null;
        try
        {
            invokeResults = Script.GetNewClosure()
                                  .InvokeWithContext(null,
                                                     [new("_", $"{tokenValue}"), new("this", context)],
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
