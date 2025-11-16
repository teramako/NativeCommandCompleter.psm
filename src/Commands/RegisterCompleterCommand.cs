using System.Management.Automation;

namespace MT.Comp.Commands;

[Cmdlet(VerbsLifecycle.Register, "NativeCompleter")]
[OutputType(typeof(void))]
public class RegisterCompleterCommand : PSCmdlet
{
    private const string ParameterSetNew = "New";
    private const string ParameterSetInput = "Input";

    [Parameter(ParameterSetName = ParameterSetNew, Mandatory = true, Position = 0)]
    [Alias("n")]
    public string Name { get; set; } = string.Empty;

    [Parameter(ParameterSetName = ParameterSetNew, Position = 1)]
    [Alias("d")]
    public string Description { get; set; } = string.Empty;

    [Parameter(ParameterSetName = ParameterSetNew)]
    [Alias("p")]
    public PSObject[] Parameters { get; set; } = [];

    [Parameter(ParameterSetName = ParameterSetNew)]
    [Alias("s")]
    public CommandCompleter[] SubCommands { get; set; } = [];

    [Parameter(ParameterSetName = ParameterSetNew)]
    [Alias("a")]
    public ScriptBlock? ArgumentCompleter { get; set; }

    [Parameter(ParameterSetName = ParameterSetInput, Mandatory = true, ValueFromPipeline = true, Position = 0)]
    public CommandCompleter? Completer { get; set; } = null;

    [Parameter()]
    [Alias("f")]
    public SwitchParameter Force { get; set; }

    protected override void ProcessRecord()
    {
        if (ParameterSetName == ParameterSetInput && Completer is not null)
        {
            if (Force)
            {
                NativeCompleter._completers[Completer.Name] = Completer;
            }
            else if (!NativeCompleter._completers.TryAdd(Completer.Name, Completer))
            {
                throw new InvalidOperationException($"Failed to register completer: {Completer.Name}. Maybe it's already registered.");
            }
        }
    }
    protected override void EndProcessing()
    {
        if (ParameterSetName != ParameterSetNew)
            return;

        CommandCompleter completer = new(Name, Description)
        {
            ArgumentCompleter = ArgumentCompleter,
        };
        foreach (var pso in Parameters)
        {
            if (pso.BaseObject is ParamCompleter paramCompleter1)
            {
                completer.Params.Add(paramCompleter1);
            }
            else if (LanguagePrimitives.TryConvertTo<ParamCompleter>(pso, out var paramCompleter2))
            {
                completer.Params.Add(paramCompleter2);
            }
        }
        foreach (var subCmd in SubCommands)
        {
            completer.SubCommands.Add(subCmd.Name, subCmd);
        }

        if (Force)
        {
            NativeCompleter._completers[Name] = completer;
        }
        else if (!NativeCompleter._completers.TryAdd(Name, completer))
        {
            throw new InvalidOperationException($"Failed to register completer: {Name}. Maybe it's already registered.");
        }
    }
}
