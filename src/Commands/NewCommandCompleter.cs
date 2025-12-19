using System.Collections;
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

    [Parameter(HelpMessageBaseName = MessageBaseName, HelpMessageResourceId = "Aliases")]
    public string[] Aliases { get; set; } = [];

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

    [Parameter(HelpMessageBaseName = MessageBaseName, HelpMessageResourceId = "CustomStyle")]
    public ParameterStyle? CustomStyle { get; set; }

    [Parameter(HelpMessageBaseName = MessageBaseName, HelpMessageResourceId = "DelegateArgumentIndex")]
    [ValidateRange(0, int.MaxValue)]
    public int DelegateArgumentIndex { get; set; } = -1;

    [Parameter(HelpMessageBaseName = MessageBaseName, HelpMessageResourceId = "Metadata")]
    public Hashtable? Metadata { get; set; }

    protected override void EndProcessing()
    {
        var defaultParameterStyle = CustomStyle is not null
            ? CustomStyle
            : GetStyle(Style);

        WriteObject(CreateCommandCompleter(Name,
                                           Description,
                                           Aliases,
                                           Parameters,
                                           SubCommands,
                                           defaultParameterStyle,
                                           ArgumentCompleter,
                                           NoFileCompletions,
                                           DelegateArgumentIndex,
                                           Metadata),
                    false);
    }
}
