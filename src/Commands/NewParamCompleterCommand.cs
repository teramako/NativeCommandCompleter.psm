using System.Management.Automation;

namespace MT.Comp.Commands;

[Cmdlet(VerbsCommon.New, "ParamCompleter", DefaultParameterSetName = "Default")]
[OutputType(typeof(ParamCompleter))]
public class NewParamCompleterCommand : Cmdlet
{
    [Parameter()]
    [Alias("l")]
    public string[] LongName { get; set; } = [];

    [Parameter()]
    [Alias("s")]
    public char[] ShortName { get; set; } = [];

    [Parameter()]
    [Alias("o")]
    public string[] OldStyleName { get; set; } = [];

    [Parameter()]
    [Alias("d")]
    [AllowEmptyString]
    public string Description { get; set; } = string.Empty;

    [Parameter()]
    [Alias("t")]
    public ArgumentType Type { get; set; } = ArgumentType.Flag;

    [Parameter(ParameterSetName = "WithArguments", Mandatory = true)]
    [Alias("a")]
    public string[] Arguments { get; set; } = [];

    [Parameter(ParameterSetName = "WithArgumentCompleter", Mandatory = true)]
    public ScriptBlock? ArgumentCompleter { get; set; }

    private string _name = string.Empty;

    protected override void BeginProcessing()
    {
        _name = LongName.Union(OldStyleName).Union(ShortName.Select(c => $"{c}")).First()
            ?? throw new ArgumentException("At least one of 'ShortName', 'OldStyleName' or 'LongName' must be specified");

        if (Type == ArgumentType.Flag
            && (Arguments.Length != 0 || ArgumentCompleter is not null))
        {
            Type = ArgumentType.Required;
        }
    }

    protected override void EndProcessing()
    {
        ParamCompleter completer = new(Type, LongName, OldStyleName, ShortName)
        {
            Description = Description,
            Arguments = Arguments,
            ArgumentCompleter = ArgumentCompleter
        };
        WriteObject(completer);
    }
}
