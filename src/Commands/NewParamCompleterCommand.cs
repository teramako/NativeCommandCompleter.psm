using System.Management.Automation;

namespace MT.Comp.Commands;

[Cmdlet(VerbsCommon.New, "ParamCompleter", DefaultParameterSetName = "Default")]
[OutputType(typeof(ParamCompleter))]
public class NewParamCompleterCommand : Cmdlet
{
    private const string MessageBaseName = "MT.Comp.resources.ParamCompleter";

    [Parameter(HelpMessageBaseName = MessageBaseName, HelpMessageResourceId = "StandardName")]
    [Alias("Name", "n")]
    public string[] StandardName { get; set; } = [];

    [Parameter(HelpMessageBaseName = MessageBaseName, HelpMessageResourceId = "LongName")]
    [Alias("l")]
    public string[] LongName { get; set; } = [];

    [Parameter(HelpMessageBaseName = MessageBaseName, HelpMessageResourceId = "ShortName")]
    [Alias("s")]
    public char[] ShortName { get; set; } = [];

    [Parameter(HelpMessageBaseName = MessageBaseName, HelpMessageResourceId = "Description")]
    [Alias("d")]
    [AllowEmptyString]
    public string Description { get; set; } = string.Empty;

    [Parameter(HelpMessageBaseName = MessageBaseName, HelpMessageResourceId = "Arguments")]
    [Alias("a", "ArgumentCompleter")]
    [ArgumentsTransformation]
    public ArgumentCompleterCollection Arguments { get; set; } = [];

    [Parameter(HelpMessageBaseName = MessageBaseName, HelpMessageResourceId = "Style")]
    public ParameterStyle? Style { get; set; }

    protected override void BeginProcessing()
    {
        if (StandardName.Length == 0 && LongName.Length == 0 && ShortName.Length == 0)
        {
            ThrowTerminatingError(new ErrorRecord(
                new ArgumentException(GetResourceString(MessageBaseName, "Error.NotSpecifiedAnyParameterNames")),
                "NotSpecifiedAnyParameterNames",
                ErrorCategory.InvalidArgument,
                this));
        }
    }

    protected override void EndProcessing()
    {
        ParamCompleter completer = new(StandardName, LongName, ShortName, Arguments, Style)
        {
            Description = Description ?? string.Empty,
        };
        WriteObject(completer);
    }
}
