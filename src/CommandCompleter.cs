using System.Collections.ObjectModel;
using System.Diagnostics;
using System.Management.Automation;

namespace MT.Comp;

public class CommandCompleter(string name,
                              string description = "",
                              string longParamIndicator = "--",
                              string paramIndicator = "-",
                              char valueSeparator = '=')
{
    [Conditional("DEBUG")]
    private void Debug(string msg)
    {
        NativeCompleter.Messages.Add($"[{Name}]: {msg}");
    }

    internal readonly string LongParamIndicator = longParamIndicator;
    internal readonly string ParamIndicator = paramIndicator;
    internal readonly char ValueSeparator = valueSeparator;

    public string Name { get; } = name;
    public string Description { get; set; } = description;
    public Collection<ParamCompleter> Params { get; } = [];
    public Dictionary<string, CommandCompleter> SubCommands { get; } = [];
    public ScriptBlock? ArgumentCompleter { get; set; }
}
