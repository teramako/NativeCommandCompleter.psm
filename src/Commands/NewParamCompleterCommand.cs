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
    public string[] OldName { get; set; } = [];

    [Parameter()]
    [Alias("d")]
    [AllowEmptyString]
    public string Description { get; set; } = string.Empty;

    [Parameter(ParameterSetName = "WithArguments", Mandatory = true)]
    [Alias("a")]
    public string[] Arguments { get; set; } = [];

    [Parameter(ParameterSetName = "WithArgumentCompleter", Mandatory = true)]
    public ScriptBlock? ArgumentCompleter { get; set; }

    protected override void EndProcessing()
    {
        ParamCompleter completer = new()
        {
            LongNames = LongName,
            ShortNames = ShortName,
            OldShortNames = OldName,
            Description = Description,
            Arguments = Arguments,
            ArgumentCompleter = ArgumentCompleter
        };
        WriteObject(completer);
    }
}
