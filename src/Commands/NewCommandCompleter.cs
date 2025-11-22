using System.Management.Automation;

namespace MT.Comp.Commands;

[Cmdlet(VerbsCommon.New, "CommandCompleter")]
[OutputType(typeof(CommandCompleter))]
public class NewCommandCompleterCommand : CommandCompleterBase
{
    [Parameter(Mandatory = true, Position = 0,
               HelpMessageBaseName = MessageBaseName, HelpMessageResourceId = "Register.Name")]
    [Alias("n")]
    public string Name { get; set; } = string.Empty;

    [Parameter(Position = 1,
               HelpMessageBaseName = MessageBaseName, HelpMessageResourceId = "Description")]
    [Alias("d")]
    public string Description { get; set; } = string.Empty;

    [Parameter(HelpMessageBaseName = MessageBaseName, HelpMessageResourceId = "Parameters")]
    [Alias("p")]
    public ParamCompleter[] Parameters { get; set; } = [];

    [Parameter(HelpMessageBaseName = MessageBaseName, HelpMessageResourceId = "SubCommands")]
    [Alias("s")]
    public CommandCompleter[] SubCommands { get; set; } = [];

    [Parameter(HelpMessageBaseName = MessageBaseName, HelpMessageResourceId = "ArgumentCompleter")]
    [Alias("a")]
    public ScriptBlock? ArgumentCompleter { get; set; }

    [Parameter(HelpMessageBaseName = MessageBaseName, HelpMessageResourceId = "NoFileCompletions")]
    public SwitchParameter NoFileCompletions { get; set; }

    [Parameter(HelpMessageBaseName = MessageBaseName, HelpMessageResourceId = "CommandParameterStyle")]
    [Alias("t")]
    public CommandParameterStyle Style { get; set; }

    [Parameter(HelpMessageBaseName = MessageBaseName, HelpMessageResourceId = "DelegateArgumentIndex")]
    [ValidateRange(0, int.MaxValue)]
    public int DelegateArgumentIndex { get; set; } = -1;

    protected override void EndProcessing()
    {
        WriteObject(CreateCommandCompleter(Name,
                                           Description,
                                           Parameters,
                                           SubCommands,
                                           ArgumentCompleter,
                                           Style,
                                           NoFileCompletions,
                                           DelegateArgumentIndex),
                    false);
    }
}
