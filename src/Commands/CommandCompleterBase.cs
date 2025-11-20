using System.Management.Automation;

namespace MT.Comp.Commands;

public enum CommandParameterStyle
{
    /// <summary>
    /// GNU style.
    /// <list type="bullet">
    ///     <item><term>LongOptionPrefix</term><description><c>--</c></description></item>
    ///     <item><term>ShortOptionPrefix</term><description><c>-</c></description></item>
    ///     <item><term>ValueSparator</term><description><c>=</c></description></item>
    /// </list>
    /// </summary>
    GNU,
    /// <summary>
    /// Traditional Windows OS style.
    /// <list type="bullet">
    ///     <item><term>LongOptionPrefix</term><description>disable</description></item>
    ///     <item><term>ShortOptionPrefix</term><description><c>/</c></description></item>
    ///     <item><term>ValueSparator</term><description><c>:</c></description></item>
    /// </list>
    /// </summary>
    TraditionalWindows
}

public abstract class CommandCompleterBase : PSCmdlet
{
    protected const string MessageBaseName = "MT.Comp.resources.CommandCompleter";

    protected CommandCompleter CreateCommandCompleter(string name,
                                                      string description,
                                                      ParamCompleter[] paramCompleters,
                                                      CommandCompleter[] subCommands,
                                                      ScriptBlock? argumentCompleter = null,
                                                      CommandParameterStyle style = CommandParameterStyle.GNU)
    {
        CommandCompleter completer = style switch
        {
            CommandParameterStyle.TraditionalWindows => new(name,
                                                            description,
                                                            longOptionPrefix: string.Empty,
                                                            shortOptionPrefix: "/",
                                                            valueSeparator: ':'),
            _ => new(name, description)
        };
        foreach (var paramCompleter in paramCompleters)
        {
            completer.Params.Add(paramCompleter);
        }
        foreach (var subCmd in subCommands)
        {
            completer.SubCommands.Add(subCmd.Name, subCmd);
        }
        completer.ArgumentCompleter = argumentCompleter;
        return completer;
    }

    protected void RegisterCompleter(CommandCompleter completer, bool force = false)
    {
        var cmdName = completer.Name;
        if (force)
        {
            NativeCompleter._completers[cmdName] = completer;
        }
        else if (!NativeCompleter._completers.TryAdd(cmdName, completer))
        {
            throw new InvalidOperationException(
                    string.Format(GetResourceString(MessageBaseName, "Error.AlreadyRegistered"), cmdName));
        }
    }

    protected void UnregisterCompleter(string name)
    {
        var pattern = new WildcardPattern(name);
        foreach (var key in NativeCompleter._completers.Keys)
        {
            if (pattern.IsMatch(key))
            {
                NativeCompleter._completers.Remove(key);
                WriteVerbose(string.Format(GetResourceString(MessageBaseName, "Message.Removed"), key));
            }
        }
    }
}
