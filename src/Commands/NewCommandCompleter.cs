using System.Management.Automation;

namespace MT.Comp.Commands;

[Cmdlet(VerbsCommon.New, "CommandCompleter")]
[OutputType(typeof(CommandCompleter))]
public class NewCommandCompleterCommand : Cmdlet
{
    [Parameter(Mandatory = true, Position = 0)]
    [Alias("n")]
    public string Name { get; set; } = string.Empty;

    [Parameter(Position = 1)]
    [Alias("d")]
    public string Description { get; set; } = string.Empty;

    [Parameter()]
    [Alias("p")]
    public PSObject[] Parameters { get; set; } = [];

    [Parameter()]
    [Alias("s")]
    public CommandCompleter[] SubCommands { get; set; } = [];

    [Parameter()]
    [Alias("a")]
    public ScriptBlock? ArgumentCompleter { get; set; }

    protected override void EndProcessing()
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
        WriteObject(completer, false);
    }
}
