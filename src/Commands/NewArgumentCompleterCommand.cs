using System.Management.Automation;

namespace MT.Comp.Commands;

[Cmdlet(VerbsCommon.New, "ArgumentCompleter", DefaultParameterSetName = "Default")]
[OutputType(typeof(ArgumentCompleterWithType),
            typeof(ArgumentCompleterWithCandidates),
            typeof(ArgumentCompleterWithScript))]
public class NewNativeArgumentCompleterCommand : PSCmdlet
{
    private const string MessageBaseName = "MT.Comp.resources.ArgumentCompleter";

    private const string PARAMETER_SET_WITH_TYPE = "WithType";
    private const string PARAMETER_SET_WITH_SCRIPT = "WithScript";
    private const string PARAMETER_SET_WITH_CANDIDATES = "WithCandidates";

    [Parameter(Mandatory = true, Position = 0,
               HelpMessageBaseName = MessageBaseName, HelpMessageResourceId = "Name")]
    [Alias("VariableName")]
    public string Name { get; set; } = string.Empty;

    [Parameter(HelpMessageBaseName = MessageBaseName, HelpMessageResourceId = "Description")]
    public string Description { get; set; } = string.Empty;

    [Parameter(HelpMessageBaseName = MessageBaseName, HelpMessageResourceId = "Nargs")]
    public Nargs Nargs { get; set; } = Nargs.One;

    [Parameter(HelpMessageBaseName = MessageBaseName, HelpMessageResourceId = "List")]
    public SwitchParameter List { get; set; }

    [Parameter(ParameterSetName = PARAMETER_SET_WITH_TYPE, Mandatory = true,
               HelpMessageBaseName = MessageBaseName, HelpMessageResourceId = "Type")]
    public ArgumentType Type { get; set; }

    [Parameter(ParameterSetName = PARAMETER_SET_WITH_SCRIPT, Mandatory = true,
               HelpMessageBaseName = MessageBaseName, HelpMessageResourceId = "Script")]
    public required ScriptBlock Script { get; set; }

    [Parameter(ParameterSetName = PARAMETER_SET_WITH_CANDIDATES, Mandatory = true,
               HelpMessageBaseName = MessageBaseName, HelpMessageResourceId = "Candidates")]
    public required CompletionValue[] Candidates { get; set; }

    protected override void EndProcessing()
    {
        IArgumentCompleter ac = ParameterSetName switch
        {
            PARAMETER_SET_WITH_SCRIPT => new ArgumentCompleterWithScript()
            {
                Name = Name,
                Script = Script,
                Description = Description,
                Nargs = Nargs,
            },
            PARAMETER_SET_WITH_CANDIDATES => new ArgumentCompleterWithCandidates()
            {
                Name = Name,
                Candidates = Candidates,
                Description = Description,
                Nargs = Nargs,
            },
            PARAMETER_SET_WITH_TYPE or _ => new ArgumentCompleterWithType()
            {
                Name = Name,
                Type = Type,
                Description = Description,
                Nargs = Nargs,
            }
        };
        WriteObject(ac);
    }
}
