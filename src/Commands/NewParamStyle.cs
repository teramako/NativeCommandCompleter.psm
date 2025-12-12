using System.Management.Automation;

namespace MT.Comp.Commands;

[Cmdlet(VerbsCommon.New, "ParamStyle", DefaultParameterSetName = "Named")]
[OutputType(typeof(ParameterStyle))]
public class NewParamStyleCommand : PSCmdlet
{
    [Parameter(ParameterSetName = "Named", Mandatory = true, Position = 0)]
    public CommandParameterStyle Name { get; set; } = CommandParameterStyle.GNU;

    [Parameter(ParameterSetName = "Custom")]
    [AllowEmptyString]
    public string LongOptionPrefix { get; set; } = string.Empty;

    [Parameter(ParameterSetName = "Custom")]
    [AllowEmptyString]
    public string ShortOptionPrefix { get; set; } = string.Empty;

    [Parameter(ParameterSetName = "Custom")]
    public char ValueSeparator { get; set; } = '=';

    [Parameter(ParameterSetName = "Custom")]
    public ParameterValueStyle ValueStyle { get; set; } = ParameterValueStyle.Adjacent;

    private ParameterStyle? _style;

    protected override void BeginProcessing()
    {
        if (ParameterSetName == "Named")
        {
            _style = Name switch
            {
                CommandParameterStyle.Windows => ParameterStyle.Windows,
                CommandParameterStyle.Unix => ParameterStyle.Unix,
                CommandParameterStyle.GNU or _ => ParameterStyle.GNU,
            };
        }
        else
        {
            _style = new(LongOptionPrefix,
                         ShortOptionPrefix,
                         ValueSeparator,
                         ValueStyle);
            if (_style == ParameterStyle.GNU)
            {
                _style = ParameterStyle.GNU;
            }
            else if (_style == ParameterStyle.Windows)
            {
                _style = ParameterStyle.Windows;
            }
            else if (_style == ParameterStyle.Unix)
            {
                _style = ParameterStyle.Unix;
            }
        }
    }
    protected override void EndProcessing()
    {
        WriteObject(_style);
    }
}
