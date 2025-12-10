using System.Collections;
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
    TraditionalWindows,

    /// <summary>
    /// Traditional Unix style.
    /// <list type="bullet">
    ///     <item><term>LongOptionPrefix</term><description><c>--</c></description></item>
    ///     <item><term>ShortOptionPrefix</term><description><c>-</c></description></item>
    ///     <item><term>ValueSparator</term><description>(Space)<c>" "</c></description></item>
    /// </list>
    /// </summary>
    TraditionalUnix,
}

public abstract class CommandCompleterBase : PSCmdlet
{
    protected const string MessageBaseName = "MT.Comp.resources.CommandCompleter";

    protected CommandCompleter CreateCommandCompleter(string name,
                                                      string description,
                                                      string[] aliases,
                                                      ParamCompleter[] paramCompleters,
                                                      CommandCompleter[] subCommands,
                                                      ScriptBlock? argumentCompleter = null,
                                                      CommandParameterStyle style = CommandParameterStyle.GNU,
                                                      bool noFileCompletions = false,
                                                      int delegateArgumentIndex = -1,
                                                      Hashtable? metadata = null)
    {
        ParameterStyle paramStyle = style switch
        {
            CommandParameterStyle.TraditionalWindows => ParameterStyle.Windows,
            CommandParameterStyle.TraditionalUnix => ParameterStyle.UnixTraditional,
            CommandParameterStyle.GNU or _ => ParameterStyle.GNU,
        };
        CommandCompleter completer = new(name, description, paramStyle, paramCompleters, subCommands)
        {
            Aliases = aliases,
            ArgumentCompleter = argumentCompleter,
            NoFileCompletions = noFileCompletions,
            DelegateArgumentIndex = delegateArgumentIndex,
            Metadata = metadata
        };
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
