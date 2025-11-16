using System.Management.Automation;

namespace MT.Comp.Commands;

public abstract class CommandCompleterBase : PSCmdlet
{
    public abstract string Name { get; set; }

    public abstract string Description { get; set; }

    public abstract PSObject[] Parameters { get; set; }

    public abstract CommandCompleter[] SubCommands { get; set; }

    public abstract ScriptBlock? ArgumentCompleter { get; set; }

    protected CommandCompleter CreateCommandCompleter()
    {
        CommandCompleter completer = new(Name, Description)
        {
            ArgumentCompleter = ArgumentCompleter
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
        return completer;
    }

    protected void RegisterCompleter(CommandCompleter completer, bool force = false)
    {
        if (force)
        {
            NativeCompleter._completers[Name] = completer;
        }
        else if (!NativeCompleter._completers.TryAdd(Name, completer))
        {
            throw new InvalidOperationException($"Failed to register completer: {Name}. Maybe it's already registered.");
        }
    }
}
