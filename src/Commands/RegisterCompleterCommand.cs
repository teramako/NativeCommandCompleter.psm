using System.Collections;
using System.Management.Automation;

namespace MT.Comp.Commands;

[Cmdlet(VerbsLifecycle.Register, "NativeCompleter")]
[OutputType(typeof(void))]
public class RegisterCompleterCommand : CommandCompleterBase
{
    private const string ParameterSetNew = "New";
    private const string ParameterSetInput = "Input";
    private const string ParameterSetCustomStyle = "CustomStyle";

    [Parameter(ParameterSetName = ParameterSetNew, Mandatory = true, Position = 0,
               HelpMessageBaseName = MessageBaseName, HelpMessageResourceId = "Register.Name")]
    [Alias("n")]
    public string Name { get; set; } = string.Empty;

    [Parameter(ParameterSetName = ParameterSetNew, Position = 1,
               HelpMessageBaseName = MessageBaseName, HelpMessageResourceId = "Description")]
    [Alias("d")]
    public string Description { get; set; } = string.Empty;

    [Parameter(ParameterSetName = ParameterSetNew,
               HelpMessageBaseName = MessageBaseName, HelpMessageResourceId = "Aliases")]
    public string[] Aliases { get; set; } = [];

    [Parameter(ParameterSetName = ParameterSetNew,
               HelpMessageBaseName = MessageBaseName, HelpMessageResourceId = "Parameters")]
    [Alias("p")]
    public ParamCompleter[] Parameters { get; set; } = [];

    [Parameter(ParameterSetName = ParameterSetNew,
               HelpMessageBaseName = MessageBaseName, HelpMessageResourceId = "SubCommands")]
    [Alias("s")]
    public CommandCompleter[] SubCommands { get; set; } = [];

    [Parameter(ParameterSetName = ParameterSetNew,
               HelpMessageBaseName = MessageBaseName, HelpMessageResourceId = "ArgumentCompleter")]
    [Alias("a")]
    public ScriptBlock? ArgumentCompleter { get; set; }

    [Parameter(ParameterSetName = ParameterSetNew,
               HelpMessageBaseName = MessageBaseName, HelpMessageResourceId = "CommandParameterStyle")]
    [Alias("t")]
    public CommandParameterStyle Style { get; set; }

    [Parameter(ParameterSetName = ParameterSetNew,
               HelpMessageBaseName = MessageBaseName, HelpMessageResourceId = "CustomStyle")]
    public ParameterStyle? CustomStyle { get; set; }

    [Parameter(ParameterSetName = ParameterSetNew,
               HelpMessageBaseName = MessageBaseName, HelpMessageResourceId = "NoFileCompletions")]
    public SwitchParameter NoFileCompletions { get; set; }

    [Parameter(ParameterSetName = ParameterSetNew,
               HelpMessageBaseName = MessageBaseName, HelpMessageResourceId = "DelegateArgumentIndex")]
    [ValidateRange(0, int.MaxValue)]
    public int DelegateArgumentIndex { get; set; } = -1;

    [Parameter(ParameterSetName = ParameterSetNew,
               HelpMessageBaseName = MessageBaseName, HelpMessageResourceId = "Metadata")]
    public Hashtable? Metadata { get; set; }

    [Parameter(ParameterSetName = ParameterSetInput, Mandatory = true, ValueFromPipeline = true, Position = 0,
               HelpMessageBaseName = MessageBaseName, HelpMessageResourceId = "Completer")]
    public CommandCompleter? Completer { get; set; } = null;

    [Parameter(HelpMessageBaseName = MessageBaseName, HelpMessageResourceId = "Force")]
    [Alias("f")]
    public SwitchParameter Force { get; set; }

    protected override void ProcessRecord()
    {
        if (ParameterSetName == ParameterSetInput && Completer is not null)
        {
            RegisterCompleter(Completer, Force);
        }
    }
    protected override void EndProcessing()
    {
        if (ParameterSetName != ParameterSetNew)
            return;

        var defaultParameterStyle = CustomStyle is not null
            ? CustomStyle
            : GetStyle(Style);

        RegisterCompleter(CreateCommandCompleter(Name,
                                                 Description,
                                                 Aliases,
                                                 Parameters,
                                                 SubCommands,
                                                 defaultParameterStyle,
                                                 ArgumentCompleter,
                                                 NoFileCompletions,
                                                 DelegateArgumentIndex,
                                                 Metadata),
                          Force);
    }
}
