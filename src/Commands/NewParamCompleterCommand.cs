using System.Management.Automation;

namespace MT.Comp.Commands;

[Cmdlet(VerbsCommon.New, "ParamCompleter", DefaultParameterSetName = "Default")]
[OutputType(typeof(ParamCompleter))]
public class NewParamCompleterCommand : Cmdlet
{
    private const string MessageBaseName = "MT.Comp.resources.ParamCompleter";

    [Parameter(HelpMessageBaseName = MessageBaseName, HelpMessageResourceId = "LongName")]
    [Alias("l")]
    public string[] LongName { get; set; } = [];

    [Parameter(HelpMessageBaseName = MessageBaseName, HelpMessageResourceId = "ShortName")]
    [Alias("s")]
    public char[] ShortName { get; set; } = [];

    [Parameter(HelpMessageBaseName = MessageBaseName, HelpMessageResourceId = "OldStyleName")]
    [Alias("o")]
    public string[] OldStyleName { get; set; } = [];

    [Parameter(HelpMessageBaseName = MessageBaseName, HelpMessageResourceId = "Description")]
    [Alias("d")]
    [AllowEmptyString]
    public string Description { get; set; } = string.Empty;

    [Parameter(HelpMessageBaseName = MessageBaseName, HelpMessageResourceId = "ArgumentType")]
    [Alias("t")]
    public ArgumentType Type { get; set; } = ArgumentType.Flag;

    [Parameter(ParameterSetName = "WithArguments", Mandatory = true,
               HelpMessageBaseName = MessageBaseName, HelpMessageResourceId = "Arguments")]
    [Alias("a")]
    public string[] Arguments { get; set; } = [];

    [Parameter(ParameterSetName = "WithArgumentCompleter", Mandatory = true,
               HelpMessageBaseName = MessageBaseName, HelpMessageResourceId = "ArgumentCompleter")]
    public ScriptBlock? ArgumentCompleter { get; set; }

    [Parameter(HelpMessageBaseName = MessageBaseName, HelpMessageResourceId = "VariableName")]
    public string VariableName { get; set; } = "Val";

    [Parameter(HelpMessageBaseName = MessageBaseName, HelpMessageResourceId = "Style")]
    public ParameterStyle? Style { get; set; }

    protected override void BeginProcessing()
    {
        if (LongName.Length == 0 && OldStyleName.Length == 0 && ShortName.Length == 0)
        {
            ThrowTerminatingError(new ErrorRecord(
                new ArgumentException(GetResourceString(MessageBaseName, "Error.NotSpecifiedAnyParameterNames")),
                "NotSpecifiedAnyParameterNames",
                ErrorCategory.InvalidArgument,
                this));
        }

        if (Type == ArgumentType.Flag
            && (Arguments.Length != 0 || ArgumentCompleter is not null))
        {
            Type = ArgumentType.Required;
        }
    }

    protected override void EndProcessing()
    {
        ParamCompleter completer = new(Type, LongName, OldStyleName, ShortName, VariableName, Style)
        {
            Description = Description ?? string.Empty,
            Arguments = Arguments,
            ArgumentCompleter = ArgumentCompleter
        };
        WriteObject(completer);
    }
}
