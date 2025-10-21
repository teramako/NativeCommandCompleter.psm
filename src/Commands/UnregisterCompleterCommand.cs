using System.Management.Automation;

namespace MT.Comp.Commands;

[Cmdlet(VerbsLifecycle.Unregister, "NativeCompleter")]
public class UnregisterCompleterCommand : Cmdlet
{
    [Parameter(Mandatory = true, Position = 0)]
    [SupportsWildcards]
    public string Name { get; set; } = string.Empty;

    protected override void EndProcessing()
    {
        var pattern = new WildcardPattern(Name);
        foreach (var key in NativeCompleter._completers.Keys)
        {
            if (pattern.IsMatch(key))
            {
                NativeCompleter._completers.Remove(key);
                WriteVerbose($"Removed: {key}");
            }
        }
    }
}
