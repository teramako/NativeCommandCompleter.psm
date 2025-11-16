using System.Management.Automation;

namespace MT.Comp.Commands;

[Cmdlet(VerbsLifecycle.Register, "NativeCompleter")]
[OutputType(typeof(void))]
public class RegisterCompleterCommand : CommandCompleterBase
{
    private const string ParameterSetNew = "New";
    private const string ParameterSetInput = "Input";

    [Parameter(ParameterSetName = ParameterSetNew, Mandatory = true, Position = 0,
               HelpMessageBaseName = MessageBaseName, HelpMessageResourceId = "Register.Name")]
    [Alias("n")]
    public override string Name { get; set; } = string.Empty;

    [Parameter(ParameterSetName = ParameterSetNew, Position = 1,
               HelpMessageBaseName = MessageBaseName, HelpMessageResourceId = "Description")]
    [Alias("d")]
    public override string Description { get; set; } = string.Empty;

    [Parameter(ParameterSetName = ParameterSetNew,
               HelpMessageBaseName = MessageBaseName, HelpMessageResourceId = "Parameters")]
    [Alias("p")]
    public override ParamCompleter[] Parameters { get; set; } = [];

    [Parameter(ParameterSetName = ParameterSetNew,
               HelpMessageBaseName = MessageBaseName, HelpMessageResourceId = "SubCommands")]
    [Alias("s")]
    public override CommandCompleter[] SubCommands { get; set; } = [];

    [Parameter(ParameterSetName = ParameterSetNew,
               HelpMessageBaseName = MessageBaseName, HelpMessageResourceId = "ArgumentCompleter")]
    [Alias("a")]
    public override ScriptBlock? ArgumentCompleter { get; set; }

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

        RegisterCompleter(CreateCommandCompleter(), Force);
    }
}
