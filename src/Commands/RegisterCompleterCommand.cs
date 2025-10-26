using System.Collections.ObjectModel;
using System.Management.Automation;

namespace MT.Comp.Commands;

[Cmdlet(VerbsLifecycle.Register, "NativeCompleter", DefaultParameterSetName = "Command")]
public class RegisterCompleterCommand : Cmdlet
{
    [Parameter(Mandatory = true, Position = 0)]
    public string Name { get; set; } = string.Empty;

    [Parameter(Position = 1)]
    public string Description { get; set; } = string.Empty;

    [Parameter(ValueFromRemainingArguments = true)]
    public PSObject[] Parameters { get; set; } = [];

    [Parameter()]
    public ScriptBlock? ArgumentCompleter { get; set; }

    [Parameter(ParameterSetName = "SubCommand", Mandatory = true)]
    public string ParentCommand { get; set; } = string.Empty;

    [Parameter()]
    public SwitchParameter Force { get; set; }

    private bool _subCommand;

    protected override void BeginProcessing()
    {
        if (!string.IsNullOrEmpty(ParentCommand))
        {
            if (!NativeCompleter._completers.ContainsKey(ParentCommand))
            {
                throw new ArgumentException($"Parent command is not found: {ParentCommand}");
            }
            _subCommand = true;
        }
    }

    protected override void EndProcessing()
    {
        CommandCompleter completer = new(Name, Description)
        {
            ArgumentCompleter = ArgumentCompleter
        };
        Collection<ParamCompleter> paramCompleters = new();
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

        if (_subCommand)
        {
            if (!NativeCompleter._completers.TryGetValue(ParentCommand, out var parent))
            {
                throw new ArgumentException($"Parent command is not found: {ParentCommand}");
            }
            if (Force)
            {
                parent._subCmds[Name] = completer;
            }
            else if (!parent._subCmds.TryAdd(Name, completer))
            {
                throw new InvalidOperationException($"Failed to register completer: {Name}. Maybe it's already registered.");
            }
        }
        else
        {
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
}
