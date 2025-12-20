using System.Management.Automation;

namespace MT.Comp;

/// <summary>
/// A command completer which matches command name with wildcard pattern
/// </summary>
public class WildcardNameCommandCompleter : CommandCompleter
{
    public WildcardNameCommandCompleter(string name, string description = "")
        : base(name, description)
    {
        _wildcard = new WildcardPattern(name, WildcardOptions.IgnoreCase);
        Hidden = true;
    }
    public WildcardNameCommandCompleter(string name,
                                        string description,
                                        ParameterStyle defaultParameterStyle,
                                        IEnumerable<ParamCompleter> parameters,
                                        IEnumerable<CommandCompleter> subCommands)
        : base(name, description, defaultParameterStyle, parameters, subCommands)
    {
        _wildcard = new WildcardPattern(name, WildcardOptions.IgnoreCase);
        Hidden = true;
    }

    private readonly WildcardPattern _wildcard;

    protected override bool IsMatch(ReadOnlySpan<char> tokenValue, out ReadOnlySpan<char> cmdName)
    {
        cmdName = tokenValue;
        if (tokenValue.IsEmpty)
            return false;
        return _wildcard.IsMatch($"{tokenValue}");
    }
}
