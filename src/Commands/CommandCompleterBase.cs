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
    ///     <item><term>LongOptionPrefix</term><description><c>/</c></description></item>
    ///     <item><term>ShortOptionPrefix</term><description><c>/</c></description></item>
    ///     <item><term>ValueSparator</term><description><c>:</c></description></item>
    /// </list>
    /// </summary>
    Windows,

    /// <summary>
    /// Traditional Unix style.
    /// <list type="bullet">
    ///     <item><term>LongOptionPrefix</term><description><c>--</c></description></item>
    ///     <item><term>ShortOptionPrefix</term><description><c>-</c></description></item>
    ///     <item><term>ValueSparator</term><description>(Space)<c>" "</c></description></item>
    /// </list>
    /// </summary>
    Unix,
}

public abstract class CommandCompleterBase : PSCmdlet
{
    protected const string MessageBaseName = "MT.Comp.resources.CommandCompleter";

    protected CommandCompleter CreateCommandCompleter(string name,
                                                      string description,
                                                      string[] aliases,
                                                      ParamCompleter[] paramCompleters,
                                                      CommandCompleter[] subCommands,
                                                      ParameterStyle style,
                                                      ScriptBlock? argumentCompleter = null,
                                                      bool noFileCompletions = false,
                                                      int delegateArgumentIndex = -1,
                                                      Hashtable? metadata = null)
    {
        CommandCompleter completer = WildcardPattern.ContainsWildcardCharacters(name)
            ? new WildcardNameCommandCompleter(name, description, style, paramCompleters, subCommands)
            {
                Aliases = aliases,
                ArgumentCompleter = argumentCompleter,
                NoFileCompletions = noFileCompletions,
                DelegateArgumentIndex = delegateArgumentIndex,
                Metadata = metadata
            }
            : new CommandCompleter(name, description, style, paramCompleters, subCommands)
            {
                Aliases = aliases,
                ArgumentCompleter = argumentCompleter,
                NoFileCompletions = noFileCompletions,
                DelegateArgumentIndex = delegateArgumentIndex,
                Metadata = metadata
            };
        return completer;
    }

    protected ParameterStyle GetStyle(CommandParameterStyle style)
    {
        return style switch
        {
            CommandParameterStyle.Windows => ParameterStyle.Windows,
            CommandParameterStyle.Unix => ParameterStyle.Unix,
            CommandParameterStyle.GNU or _ => ParameterStyle.GNU,
        };
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
