using System.Management.Automation;

namespace MT.Comp.Commands;

[Cmdlet(VerbsCommon.New, "CommandCompleter")]
[OutputType(typeof(CommandCompleter))]
public class NewCommandCompleterCommand : CommandCompleterBase
{
    [Parameter(Mandatory = true, Position = 0,
               HelpMessageBaseName = MessageBaseName, HelpMessageResourceId = "Register.Name")]
    [Alias("n")]
    public override string Name { get; set; } = string.Empty;

    [Parameter(Position = 1,
               HelpMessageBaseName = MessageBaseName, HelpMessageResourceId = "Description")]
    [Alias("d")]
    public override string Description { get; set; } = string.Empty;

    [Parameter(HelpMessageBaseName = MessageBaseName, HelpMessageResourceId = "Parameters")]
    [Alias("p")]
    public override ParamCompleter[] Parameters { get; set; } = [];

    [Parameter(HelpMessageBaseName = MessageBaseName, HelpMessageResourceId = "SubCommands")]
    [Alias("s")]
    public override CommandCompleter[] SubCommands { get; set; } = [];

    [Parameter(HelpMessageBaseName = MessageBaseName, HelpMessageResourceId = "ArgumentCompleter")]
    [Alias("a")]
    public override ScriptBlock? ArgumentCompleter { get; set; }

    protected override void EndProcessing()
    {
        WriteObject(CreateCommandCompleter(), false);
    }
}
