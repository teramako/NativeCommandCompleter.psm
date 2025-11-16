using System.Management.Automation;

namespace MT.Comp.Commands;

[Cmdlet(VerbsCommon.New, "CommandCompleter")]
[OutputType(typeof(CommandCompleter))]
public class NewCommandCompleterCommand : CommandCompleterBase
{
    [Parameter(Mandatory = true, Position = 0)]
    [Alias("n")]
    public override string Name { get; set; } = string.Empty;

    [Parameter(Position = 1)]
    [Alias("d")]
    public override string Description { get; set; } = string.Empty;

    [Parameter()]
    [Alias("p")]
    public override PSObject[] Parameters { get; set; } = [];

    [Parameter()]
    [Alias("s")]
    public override CommandCompleter[] SubCommands { get; set; } = [];

    [Parameter()]
    [Alias("a")]
    public override ScriptBlock? ArgumentCompleter { get; set; }

    protected override void EndProcessing()
    {
        WriteObject(CreateCommandCompleter(), false);
    }
}
