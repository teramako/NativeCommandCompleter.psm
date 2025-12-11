using System.Collections;
using System.Management.Automation;

namespace MT.Comp.Commands;

[Cmdlet(VerbsCommon.New, "CommandCompleter", DefaultParameterSetName = DefaultParameeterSet)]
[OutputType(typeof(CommandCompleter))]
public class NewCommandCompleterCommand : CommandCompleterBase
{
    private const string DefaultParameeterSet = "Default";
    private const string CustomStyleParameterSet = "CustomStyle";

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

    [Parameter(ParameterSetName = DefaultParameeterSet,
               HelpMessageBaseName = MessageBaseName, HelpMessageResourceId = "CommandParameterStyle")]
    [Alias("t")]
    public CommandParameterStyle Style { get; set; }

    [Parameter(ParameterSetName = CustomStyleParameterSet, Mandatory = true,
               HelpMessageBaseName = MessageBaseName, HelpMessageResourceId = "CustomStyle")]
    public ParameterStyle? CustomStyle { get; set; }

    [Parameter(HelpMessageBaseName = MessageBaseName, HelpMessageResourceId = "DelegateArgumentIndex")]
    [ValidateRange(0, int.MaxValue)]
    public int DelegateArgumentIndex { get; set; } = -1;

    [Parameter(HelpMessageBaseName = MessageBaseName, HelpMessageResourceId = "Metadata")]
    public Hashtable? Metadata { get; set; }

    protected override void EndProcessing()
    {
        var defaultParameterStyle = ParameterSetName switch
        {
            DefaultParameeterSet => GetStyle(Style),
            CustomStyleParameterSet or _ => CustomStyle ?? ParameterStyle.GNU
        };
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
