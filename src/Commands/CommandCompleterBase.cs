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
                                                      object[]? argumentCompleters = null,
                                                      bool noFileCompletions = false,
                                                      int delegateArgumentIndex = -1,
                                                      Hashtable? metadata = null)
    {
        CommandCompleter completer = WildcardPattern.ContainsWildcardCharacters(name)
            ? new WildcardNameCommandCompleter(name, description, style, paramCompleters, subCommands)
            {
                Aliases = aliases,
                Arguments = GetArgumentCompleters(argumentCompleters),
                NoFileCompletions = noFileCompletions,
                DelegateArgumentIndex = delegateArgumentIndex,
                Metadata = metadata
            }
            : new CommandCompleter(name, description, style, paramCompleters, subCommands)
            {
                Aliases = aliases,
                Arguments = GetArgumentCompleters(argumentCompleters),
                NoFileCompletions = noFileCompletions,
                DelegateArgumentIndex = delegateArgumentIndex,
                Metadata = metadata
            };
        return completer;
    }

    protected IArgumentCompleter[]? GetArgumentCompleters(object[]? arguments)
    {
        if (arguments is null)
            return null;

        List<IArgumentCompleter> results = [];
        int lastIndex = arguments.Length - 1;
        for (int i = 0; i < arguments.Length; i++)
        {
            var obj = arguments[i];
            var ac = GetArgumentCompleter(obj is PSObject pso ? pso.BaseObject : obj,
                                          i,
                                          i == lastIndex);
            results.Add(ac);
        }
        return results.ToArray();
    }

    private IArgumentCompleter GetArgumentCompleter(object obj, int index, bool isLast)
    {
        switch (obj)
        {
            case ScriptBlock sb:
                return new ArgumentCompleterScript()
                {
                    Name = $"ARG{index + 1}",
                    Required = true,
                    Remainings = isLast,
                    Script = sb,
                };
            case IList list:
                List<string> candidates = [];
                foreach (var item in list)
                {
                    candidates.Add($"{item}");
                }
                return new ArgumentCompleterList()
                {
                    Name = $"ARG{index + 1}",
                    Required = true,
                    Remainings = isLast,
                    Candidates = candidates.ToArray()
                };
            case IDictionary dict:
                if (LanguagePrimitives.TryConvertTo<ArgumentCompleterList>(dict, out var acList))
                {
                    return acList;
                }
                else if (LanguagePrimitives.TryConvertTo<ArgumentCompleterScript>(dict, out var acScript))
                {
                    return acScript;
                }
                break;
        }
        throw new PSInvalidCastException($"Could not convert to IArgumentCompleter: [{index}] {obj}");
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
                NativeCompleter._scripts.Remove(key);
                WriteVerbose(string.Format(GetResourceString(MessageBaseName, "Message.Removed"), key));
            }
        }
    }
}
