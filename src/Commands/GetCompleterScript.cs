using System.Management.Automation;

namespace MT.Comp.Commands;

[Cmdlet(VerbsCommon.Get, "NativeCompleterScript")]
[OutputType(typeof(CompleterScript))]
public class GetNativeCompleterScript: Cmdlet
{
    private const string MessageBaseName = "MT.Comp.resources.CompleterScript";

    [Parameter(Position = 0,
               HelpMessageBaseName = MessageBaseName, HelpMessageResourceId = "Name")]
    [SupportsWildcards]
    public string? Name { get; set; }

    [Parameter(HelpMessageBaseName = MessageBaseName, HelpMessageResourceId = "All")]
    [Alias("a")]
    public SwitchParameter All { get; set; }

    protected override void EndProcessing()
    {
        var query = WildcardPattern.Get(string.IsNullOrEmpty(Name) ? "*" : Name,
                                        WildcardOptions.Compiled | WildcardOptions.IgnoreCase);

        WriteObject(NativeCompleter.GetCompleterScripts(All)
                                   .Where(s => query.IsMatch(s.Name)),
                    true);
    }   
}
