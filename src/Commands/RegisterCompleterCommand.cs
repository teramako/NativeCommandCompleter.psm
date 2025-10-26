using System.Collections.ObjectModel;
using System.Management.Automation;

namespace MT.Comp.Commands;

[Cmdlet(VerbsLifecycle.Register, "NativeCompleter")]
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

    [Parameter()]
    public SwitchParameter Force { get; set; }

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
