using System.Management.Automation;

namespace MT.Comp.Commands;

[Cmdlet(VerbsLifecycle.Unregister, "NativeCompleter")]
[OutputType(typeof(void))]
public class UnregisterCompleterCommand : Cmdlet
{
    private const string MessageBaseName = "MT.Comp.resources.CommandCompleter";

    [Parameter(Mandatory = true, Position = 0,
               HelpMessageBaseName = MessageBaseName, HelpMessageResourceId = "Unregister.Name")]
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
                WriteVerbose(string.Format(GetResourceString(MessageBaseName, "Message.Removed"), key));
            }
        }
    }
}
