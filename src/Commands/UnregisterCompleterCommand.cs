using System.Management.Automation;

namespace MT.Comp.Commands;

[Cmdlet(VerbsLifecycle.Unregister, "NativeCompleter")]
[OutputType(typeof(void))]
public class UnregisterCompleterCommand : CommandCompleterBase
{
    [Parameter(Mandatory = true, Position = 0,
               HelpMessageBaseName = MessageBaseName, HelpMessageResourceId = "Unregister.Name")]
    [SupportsWildcards]
    public string Name { get; set; } = string.Empty;

    protected override void EndProcessing()
    {
        UnregisterCompleter(Name);
    }
}
