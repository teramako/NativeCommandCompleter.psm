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

    public abstract string Name { get; set; }

    public abstract string Description { get; set; }

    public abstract ParamCompleter[] Parameters { get; set; }

    public abstract CommandCompleter[] SubCommands { get; set; }

    public abstract ScriptBlock? ArgumentCompleter { get; set; }

    public abstract CommandParameterStyle Style { get; set; }

    protected CommandCompleter CreateCommandCompleter()
    {
        CommandCompleter completer = Style switch
        {
            CommandParameterStyle.TraditionalWindows => new(Name,
                                                            Description,
                                                            longOptionPrefix: string.Empty,
                                                            shortOptionPrefix: "/",
                                                            valueSeparator: ':'),
            _ => new(Name, Description)
        };
        foreach (var paramCompleter in Parameters)
        {
            completer.Params.Add(paramCompleter);
        }
        foreach (var subCmd in SubCommands)
        {
            completer.SubCommands.Add(subCmd.Name, subCmd);
        }
        completer.ArgumentCompleter = ArgumentCompleter;
        return completer;
    }

    protected void RegisterCompleter(CommandCompleter completer, bool force = false)
    {
        if (force)
        {
            NativeCompleter._completers[Name] = completer;
        }
        else if (!NativeCompleter._completers.TryAdd(Name, completer))
        {
            throw new InvalidOperationException(
                    string.Format(GetResourceString(MessageBaseName, "Error.AlreadyRegistered"), Name));
        }
    }
}
