using System.Collections;
using System.Collections.ObjectModel;
using System.Management.Automation;

namespace MT.Comp;

public class CommandCompleter
{
    public CommandCompleter(string name,
                            string description = "",
                            ParameterStyle? defaultParameterStyle = null)
        : this(name, description, defaultParameterStyle ?? ParameterStyle.GNU, [], [])
    {
    }
    public CommandCompleter(string name,
                            string description,
                            ParameterStyle defaultParameterStyle,
                            IEnumerable<ParamCompleter> parameters,
                            IEnumerable<CommandCompleter> subCommands)
    {
        Name = name;
        Description = description;

        DefaultParameterStyle = defaultParameterStyle;

        foreach (var param in parameters)
        {
            AddParameter(param);
        }
        Params = _params.AsReadOnly();

        foreach (var subCmd in subCommands)
        {
            AddSubCommand(subCmd);
        }
        SubCommands = _subCommands.AsReadOnly();
    }

    public string Name { get; }
    public string[] Aliases { get; set; } =  [];
    public string Description { get; set; }

    public ParameterStyle DefaultParameterStyle { get; }
    private readonly Collection<ParamCompleter> _params = [];
    public ReadOnlyCollection<ParamCompleter> Params { get; }
    private readonly Collection<CommandCompleter> _subCommands = [];
    public ReadOnlyCollection<CommandCompleter> SubCommands { get; }
    public ScriptBlock? ArgumentCompleter { get; set; }
    public bool NoFileCompletions { get; set; }
    /// <summary>
    /// Argument index of a command to delegate completions.
    /// </summary>
    /// <remarks>
    /// To delegate the arguments of `command` to the completer for `command`.
    /// <para>In cases like:</para>
    /// <code>
    /// sudo ... command [args...]
    /// time ... command [args...]
    /// </code>
    /// </remarks>
    public int DelegateArgumentIndex { get; internal set; } = -1;

    public Hashtable? Metadata { get; set; }

    public override string ToString()
    {
        return string.IsNullOrEmpty(Description)
            ? Name
            : $"{Name} - {Description}";
    }

    public void AddSubCommand(CommandCompleter subCommand)
    {
        _subCommands.Add(subCommand);
    }

    public void AddParameter(ParamCompleter param)
    {
        param.Style = DefaultParameterStyle;
        _params.Add(param);
    }

    protected bool Hidden { get; set; }

    /// <summary>
    /// Determine whether the token value matches this command completer
    /// </summary>
    /// <param name="tokenValue"></param>
    /// <param name="cmdName">Command name</param>
    /// <returns></returns>
    protected virtual bool IsMatch(ReadOnlySpan<char> tokenValue, out ReadOnlySpan<char> cmdName)
    {
        cmdName = default;
        if (tokenValue.Equals(Name, StringComparison.Ordinal))
        {
            cmdName = Name;
            return true;
        }
        if (Aliases.Length > 0)
        {
            foreach (var alias in Aliases)
            {
                if (tokenValue.Equals(alias, StringComparison.Ordinal))
                {
                    cmdName = alias;
                    return true;
                }
            }
        }
        return false;
    }

    private bool ParseParameter(ReadOnlySpan<char> tokenValue,
                                CompletionContext context,
                                int argumentIndex,
                                out int advancedCount)
    {
        advancedCount = 0;

        foreach (var param in Params)
        {
            if (param.ParseParam(tokenValue, out var paramName, out var paramValue, out var optionPrefix))
            {
                if (param.Type == ArgumentType.Flag
                    || (param.Type.HasFlag(ArgumentType.FlagOrValue) && paramValue.IsEmpty))
                {
                    context.AddBoundParameter(param.Name, true);
                }
                else if (paramValue.IsEmpty)
                {
                    if (argumentIndex < context.Arguments.Count - 1)
                    {
                        // `-param value ...|`
                        //                  ^ cursor
                        advancedCount = 1;
                        context.AddBoundParameter(param.Name, context.Arguments[argumentIndex + advancedCount].Value);
                    }
                    else
                    {
                        // `-param |`
                        //         ^ cursor
                        context.SetPendingParameter(param, $"{paramName}", optionPrefix);
                    }
                }
                else
                {
                    context.AddBoundParameter(param.Name, $"{paramValue}");
                }
                return true;
            }
        }
        return false;
    }

    private bool ParseShortParam(ReadOnlySpan<char> tokenValue,
                                 CompletionContext context,
                                 int argumentIndex,
                                 out int advancedCount)
    {
        advancedCount = 0;
        if (tokenValue.IsEmpty)
            return false;

        char prefixChar = tokenValue[0];
        var inputValue = tokenValue[1..];
        var shortParams = Params.Where(p => p.ShortNames.Length > 0
                                            && p.Style.HasShortOptionPrefix
                                            && p.Style.ShortOptionPrefix[0] == prefixChar);
        for (var i = 0; i < inputValue.Length; i++)
        {
            var c = inputValue[i];
            var p = shortParams.FirstOrDefault(p => p.ShortNames.Contains(c));
            if (p is null)
                continue;

            if (p.Type == ArgumentType.Flag)
            {
                context.AddBoundParameter(p.Name, true);
            }
            else if (i == inputValue.Length - 1)
            {
                if (argumentIndex < context.Arguments.Count - 1)
                {
                    // `-abc Value ... |`
                    //      \          ^ cursor
                    //       i
                    // the argument of `c` param is supplied
                    advancedCount = 1;
                    context.AddBoundParameter(p.Name, context.Arguments[argumentIndex + advancedCount].Value);
                }
                else
                {
                    // `-abc  |`
                    //      \ ^ cursor
                    //       i
                    // the argument of `c` param is NOT supplied
                    context.SetPendingParameter(p, $"{c}", p.Style.ShortOptionPrefix);
                }
            }
            else
            {
                context.AddBoundParameter(p.Name, $"{inputValue[(i + 1)..]}");
            }
            return true;
        }
        return false;
    }

    /// <summary>
    /// Parse arguments in the completion context.
    /// </summary>
    /// <param name="context"></param>
    /// <returns></returns>
    public CompletionContext ParseArguments(CompletionContext context)
    {
        NativeCompleter.Debug($"[{context.Name}] Build CompletionContext");

        // Early return if no parameters to analyze
        if (SubCommands.Count == 0
            && Params.Count == 0
            && DelegateArgumentIndex < 0)
        {
            foreach (var token in context.Arguments)
            {
                context.AddUnboundArgument(token);
            }
            return context;
        }

        int argumentsCount = context.Arguments.Count;
        for (int argumentIndex = 0; argumentIndex < argumentsCount; argumentIndex++)
        {
            Token token = context.Arguments[argumentIndex];
            ReadOnlySpan<char> tokenValue = token.Value;

            if (SubCommands.Count > 0)
            {
                foreach (var subCmd in SubCommands)
                {
                    if (subCmd.IsMatch(tokenValue, out var cmdName))
                    {
                        return context.CreateNestedContext(subCmd, cmdName, argumentIndex);
                    }
                }
            }

            // Attempt to parse as long parameter or old-style parameter
            if (ParseParameter(tokenValue, context, argumentIndex, out var advancedCount))
            {
                argumentIndex += advancedCount;
                continue;
            }
            if (ParseShortParam(tokenValue, context, argumentIndex, out advancedCount))
            {
                argumentIndex += advancedCount;
                continue;
            }
            if (context.UnboundArguments.Count == DelegateArgumentIndex)
            {
                var cmdName = Path.GetFileName(tokenValue).ToString();
                return NativeCompleter.TryGetCommandCompleter(cmdName, null, out var delegatedCompleter, out _)
                    ? context.CreateNestedContext(delegatedCompleter, argumentIndex)
                    : context.CreateNestedContext(new(cmdName, "Unknown"), argumentIndex);
            }
            else
            {
                context.AddUnboundArgument(token);
            }
        }
        return context;
    }

    /// <summary>
    /// Complete sub command names
    /// </summary>
    /// <param name="results">Completion result data to be stored</param>
    /// <param name="context">Completion context</param>
    /// <param name="tokenValue">a token of command line argument</param>
    /// <returns>
    /// <see langword="true"/> if completion is end (prevent fallback to filename completion); otherwise, <see langword="false"/>.
    /// </returns>
    public bool CompleteSubCommands(ICollection<CompletionData> results,
                                    CompletionContext context,
                                    string tokenValue)
    {
        bool completed = false;
        if (SubCommands.Count == 0)
            return completed;

        foreach (var subCommand in SubCommands.Where(subCmd => !subCmd.Hidden))
        {
            if (string.IsNullOrEmpty(tokenValue)
                || subCommand.Name.StartsWith(tokenValue, StringComparison.OrdinalIgnoreCase))
            {
                var text = subCommand.Name;
                results.Add(new CompletionValue(text, subCommand.Description).SetTooltipPrefix($"[{context.Name}] "));
                completed = true;
            }
            else if (subCommand.Aliases.Length > 0)
            {
                foreach (var alias in subCommand.Aliases)
                {
                    if (alias.StartsWith(tokenValue, StringComparison.OrdinalIgnoreCase))
                    {
                        var text = alias;
                        results.Add(new CompletionValue(text, subCommand.Description).SetTooltipPrefix($"[{context.Name}] "));
                        completed = true;
                    }
                }
            }
        }
        return completed;
    }

    /// <summary>
    /// Complete parameters, or it's argument
    /// </summary>
    /// <param name="results">Completion result data to be stored</param>
    /// <param name="context">Completion context</param>.
    /// <param name="tokenValue">a token of command line argument</param>
    /// <param name="cursorPosition">Position of cursor in token</param>.
    /// <returns>
    /// <see langword="true"/> if completion is end (prevent fallback to filename completion); otherwise, <see langword="false"/>.
    /// </returns>
    public bool CompleteParams(ICollection<CompletionData> results,
                               CompletionContext context,
                               ReadOnlySpan<char> tokenValue,
                               int cursorPosition)
    {
        bool completed = false;
        if (Params.Count == 0)
            return completed;

        if (tokenValue.IsEmpty)
        {
            if (Params.Any(p => !p.Style.HasShortOptionPrefix || !p.Style.HasLongOptionPrefix))
            {
                completed = CompleteAllParams(results, context, tokenValue);
            }
            return completed;
        }

        char c = tokenValue[0];
        if (tokenValue.Length == 1
            && Params.Any(p => p.Style.ShortOptionPrefix.StartsWith(c) || p.Style.LongOptionPrefix.StartsWith(c)))
        {
            return CompleteAllParams(results, context, tokenValue);
        }

        completed = CompleteLongParams(results, context, tokenValue, cursorPosition)
                    || CompleteOldStyleParams(results, context, tokenValue, cursorPosition)
                    || CompleteShortParams(results, context, tokenValue, cursorPosition);

        return completed;
    }

    /// <summary>
    /// Complete long parameters, or it's argument
    /// </summary>
    /// <param name="results">Completion result data to be stored</param>
    /// <param name="context">Completion context</param>.
    /// <param name="tokenValue">a token of command line argument which starts with <see cref="LongOptionPrefix"/></param>
    /// <param name="cursorPosition">Position of cursor in token</param>.
    /// <returns>
    /// <see langword="true"/> if completion is end; otherwise, <see langword="false"/>.
    /// </returns>
    private bool CompleteLongParams(ICollection<CompletionData> results,
                                    CompletionContext context,
                                    ReadOnlySpan<char> tokenValue,
                                    int cursorPosition)
    {
        NativeCompleter.Debug($"[{context.Name}] Start CompleteLongParams('{tokenValue}', {cursorPosition})");
        var longParams = Params.Where(p => p.LongNames.Length > 0);
        foreach (var param in longParams.Where(p => p.Type != ArgumentType.Flag
                                                    && p.Style.ValueStyle.HasFlag(ParameterValueStyle.Adjacent)))
        {
            var optionPrefix = param.Style.LongOptionPrefix;
            if (!tokenValue.StartsWith(optionPrefix, StringComparison.Ordinal))
                continue;
            if (param.ParseLongParam(tokenValue[optionPrefix.Length..], out var name, out var value))
            {
                var separatorPosition = name.Length + optionPrefix.Length;
                if (separatorPosition >= cursorPosition)
                    break;
                NativeCompleter.Debug($"  Matched Param {{ Name='{param.Name}', name='{name}', value='{value}' }}");
                param.CompleteValue(results,
                                    context,
                                    $"{name}",
                                    $"{value}",
                                    cursorPosition - separatorPosition - 1,
                                    param.Style.LongOptionPrefix,
                                    $"{tokenValue[..(separatorPosition + 1)]}");
                return true;
            }
        }
        bool completed = false;
        var prefixValue = tokenValue[..cursorPosition];
        //
        // complete parameter names
        //
        foreach (var param in longParams)
        {
            var optionPrefix = param.Style.LongOptionPrefix;
            if (!prefixValue.StartsWith(optionPrefix, StringComparison.Ordinal))
                continue;
            foreach (ReadOnlySpan<char> name in param.LongNames)
            {
                if (prefixValue.Length - optionPrefix.Length > name.Length)
                    continue;

                if (name.StartsWith(prefixValue[optionPrefix.Length..], StringComparison.OrdinalIgnoreCase))
                {
                    var text = $"{optionPrefix}{name}";
                    var listItemText = param.GetSyntax($"{optionPrefix}{name}");
                    var tooltip = $"""
                        [{param.Type}] {param.GetSyntaxes(expandArguments: true)}
                        {param.Description}
                        """;
                    var suffix = param.GetParamNameSuffix();
                    results.Add(new CompletionParam($"{text}{suffix}",
                                                    param.Description,
                                                    listItemText,
                                                    tooltip));
                    completed = true;
                    NativeCompleter.Debug($"    Added CompletionParam {{ '{text}{suffix}' }}");
                }
            }
        }
        return completed;
    }

    /// <summary>
    /// Complete old-style parameters
    /// </summary>
    /// <param name="results">Completion result data to be stored</param>
    /// <param name="context">Completion context</param>
    /// <param name="tokenValue">Parameter name to be completed</param>
    /// <param name="offsetPosition">Position of cursor in <paramref name="paramName"/></param>.
    /// <returns>
    /// <see langword="true"/> if completion is end; otherwise, <see langword="false"/>.
    /// </returns>
    private bool CompleteOldStyleParams(ICollection<CompletionData> results,
                                        CompletionContext context,
                                        ReadOnlySpan<char> tokenValue,
                                        int cursorPosition)
    {
        NativeCompleter.Debug($"[{context.Name}] Start CompleteOldStyleParams('{tokenValue}', {cursorPosition})");
        var oldStyleParams = Params.Where(p => p.OldStyleNames.Length > 0);
        foreach (var param in oldStyleParams.Where(p => p.Type != ArgumentType.Flag
                                                        && p.Style.ValueStyle.HasFlag(ParameterValueStyle.Adjacent)))
        {
            var optionPrefix = param.Style.ShortOptionPrefix;
            if (!tokenValue.StartsWith(optionPrefix, StringComparison.Ordinal))
                continue;
            if (param.ParseOldStyleParam(tokenValue[optionPrefix.Length..], out var name, out var value))
            {
                var separatorPosition = name.Length + optionPrefix.Length;
                if (separatorPosition >= cursorPosition)
                    break;
                NativeCompleter.Debug($"  Matched Param {{ Name='{param.Name}', name='{name}', value='{value}' }}");
                param.CompleteValue(results,
                                    context,
                                    $"{name}",
                                    $"{value}",
                                    cursorPosition - separatorPosition - 1,
                                    param.Style.ShortOptionPrefix,
                                    $"{tokenValue[..(separatorPosition + 1)]}");
                return true;
            }
        }
        //
        // complete parameter names
        //
        bool completed = false;
        var prefixValue = tokenValue[..cursorPosition];
        foreach (var param in oldStyleParams)
        {
            var shortOptionPrefix = param.Style.ShortOptionPrefix;
            if (!prefixValue.StartsWith(shortOptionPrefix, StringComparison.Ordinal))
                continue;
            foreach (ReadOnlySpan<char> name in param.OldStyleNames)
            {
                if (prefixValue.Length - shortOptionPrefix.Length > name.Length)
                    continue;

                if (name.StartsWith(prefixValue[shortOptionPrefix.Length..], StringComparison.OrdinalIgnoreCase))
                {
                    var text = $"{shortOptionPrefix}{name}";
                    var listItemText = param.GetSyntax($"{shortOptionPrefix}{name}");
                    var tooltip = $"""
                        [{param.Type}] {param.GetSyntaxes(expandArguments: true)}
                        {param.Description}
                        """;
                    var suffix = param.GetParamNameSuffix();
                    results.Add(new CompletionParam($"{text}{suffix}",
                                                    param.Description,
                                                    listItemText,
                                                    tooltip));
                    completed = true;
                    NativeCompleter.Debug($"    Added CompletionParam {{ '{text}{suffix}' }}");
                }
            }
        }
        return completed;
    }

    /// <summary>
    /// Complete short parameters, their argument
    /// </summary>
    /// <param name="results">Completion result data to be stored</param>
    /// <param name="context">Completion context</param>
    /// <param name="tokenValue">Parameter name to be completed</param>
    /// <param name="offsetPosition">Position of cursor in <paramref name="tokenValue"/></param>.
    /// <returns>
    /// <see langword="true"/> if completion is end; otherwise, <see langword="false"/>.
    /// </returns>
    private bool CompleteShortParams(ICollection<CompletionData> results,
                                     CompletionContext context,
                                     ReadOnlySpan<char> tokenValue,
                                     int offsetPosition)
    {
        Collection<ParamCompleter> remainingParams = [];
        (ParamCompleter? Completer, char ParamChar, int Position) pending = (null, default, 0);
        //
        // attempt to complete parameter's value, and store parameter as candidates when not matched
        //
        NativeCompleter.Debug($"[{context.Name}] ShortParam {{ tokenValue='{tokenValue}', position={offsetPosition} }}");
        foreach (var param in Params.Where(p => p.Style.HasShortOptionPrefix && p.ShortNames.Length > 0))
        {
            var optionPrefix = param.Style.ShortOptionPrefix;
            if (!tokenValue.StartsWith(optionPrefix, StringComparison.Ordinal))
                continue;
            if (param.IsMatchShortParam(tokenValue[optionPrefix.Length..], out char paramChar, out int position))
            {
                position += optionPrefix.Length;
                NativeCompleter.Debug($"  ShortParam Matched {{ '{paramChar}', {position} }}");
                if (position < offsetPosition
                    && param.Type != ArgumentType.Flag)
                {
                    // -ab|Value
                    //   ^ found parameter
                    // If the cursor position is after the parameter found and the parameter can take arguments,
                    if (pending.Completer is null)
                    {
                        pending = (param, paramChar, position + 1);
                        continue;
                    }

                    if (pending.Position > position + 1)
                    {
                        pending = (param, paramChar, position + 1);
                    }
                }
            }
            else if (offsetPosition == tokenValue.Length)
            {
                // -ab|
                //    ^ cursor
                // If the cursor position is at the end, add the parameter even if it is not a Flag type
                remainingParams.Add(param);
            }
            else if (param.Type == ArgumentType.Flag)
            {
                // -a|b
                //   ^ cursor
                // If the cursor position is not at the end, add only the parameter type is Flag
                remainingParams.Add(param);
            }
        }
        if (pending.Completer is not null)
        {
            return pending.Completer.CompleteValue(results,
                                                   context,
                                                   $"{pending.ParamChar}",
                                                   tokenValue[pending.Position..],
                                                   offsetPosition - pending.Position,
                                                   pending.Completer.Style.ShortOptionPrefix,
                                                   $"{tokenValue[..pending.Position]}");
        }

        //
        // complete parameter names
        //
        bool completed = false;
        var paramPrefix = tokenValue[..offsetPosition];
        var paramSuffix = tokenValue[offsetPosition..];
        foreach (var param in remainingParams)
        {
            if (!paramSuffix.IsEmpty && param.Type is not ArgumentType.Flag)
                continue;

            var tooltip = $"""
                [{param.Type}] {param.GetSyntaxes(expandArguments: true)}
                {param.Description}
                """;
            foreach (var c in param.ShortNames)
            {
                var text = $"{paramPrefix}{c}{paramSuffix}";
                var listItemText = param.GetSyntax($"{param.Style.ShortOptionPrefix}{c}", true);
                results.Add(new CompletionParam(text, param.Description, listItemText, tooltip));
                completed = true;
            }
        }

        return completed;
    }

    /// <summary>
    /// Complete remaining argumet's value (non parameter, non parameter value and non subcommand)
    /// </summary>
    /// <param name="results">Completion result data to be stored</param>
    /// <param name="context">Completion context</param>
    /// <param name="tokenValue">a token of command line argument</param>
    /// <param name="cursorPosition">Position of cursor in token</param>.
    /// <param name="argumentIndex">argument's index which starts 0 without command name</param>
    /// <returns>
    /// <see langword="true"/> if completion is end (prevent fallback to filename completion); otherwise, <see langword="false"/>.
    /// </returns>
    public bool CompleteArgument(ICollection<CompletionData> results,
                                 CompletionContext context,
                                 string tokenValue,
                                 int cursorPosition,
                                 int argumentIndex)
    {
        if (ArgumentCompleter is null)
        {
            if (argumentIndex == DelegateArgumentIndex)
            {
                foreach (var compData in Helper.CompleteCommandOrFilename(context))
                {
                    results.Add(compData);
                }
                return true;
            }
            return NoFileCompletions;
        }

        NativeCompleter.Debug($"[{context.Name}] CompleterArgument {{ '{tokenValue}', {cursorPosition}, {argumentIndex} }}");
        Collection<PSObject?>? invokeResults = null;
        try
        {
            NativeCompleter.Debug($"  Start Argument complete {{ '{tokenValue}', {cursorPosition}, {argumentIndex} }}");
            invokeResults = ArgumentCompleter.GetNewClosure()
                                             .InvokeWithContext(null,
                                                                [new("_", tokenValue), new("this", context)],
                                                                cursorPosition,
                                                                argumentIndex);
            NativeCompleter.Debug($"  ArgumentCompleter results {{ count = {invokeResults.Count} }}");
        }
        catch
        {
        }
        if (invokeResults is not null && invokeResults.Count > 0)
        {
            foreach (var item in NativeCompleter.PSObjectsToCompletionData(invokeResults))
            {
                results.Add(item);
            }
            return true;
        }
        return NoFileCompletions;
    }

    /// <summary>
    /// Complete all parameters
    /// </summary>
    /// <param name="results">Completion result data to be stored</param>
    /// <param name="context">Completion context</param>
    /// <param name="tokenValue"></param>
    /// <returns>
    /// <see langword="true"/> if completion is end (prevent fallback to filename completion); otherwise, <see langword="false"/>.
    /// </returns>
    private bool CompleteAllParams(ICollection<CompletionData> results,
                                   CompletionContext context,
                                   ReadOnlySpan<char> tokenValue)
    {
        if (Params.Count == 0)
            return false;

        NativeCompleter.Debug($"[{context.Name}] CompleteAllParams {{ '{tokenValue}' }}");
        bool isEmpty = tokenValue.IsEmpty;
        char c = isEmpty ? default : tokenValue[0];
        foreach (var param in Params)
        {
            var style = param.Style;
            var suffix = param.GetParamNameSuffix();
            var texts = param.ShortNames.Select(n => $"{style.ShortOptionPrefix}{n}")
                                       .Union(param.OldStyleNames.Select(n => $"{style.ShortOptionPrefix}{n}{suffix}"))
                                       .Union(param.LongNames.Select(n => $"{style.LongOptionPrefix}{n}{suffix}"))
                                       .Where(p => isEmpty || p.StartsWith(c));
            var text = texts.FirstOrDefault();
            if (text is null)
                continue;
            var listItemText = param.GetSyntaxes(" ", false);
            var tooltip = $"""
                [{param.Type}] {param.GetSyntaxes(expandArguments: true)}
                {param.Description}
                """;
            results.Add(new CompletionParam(text, param.Description, listItemText, tooltip));
        }
        return true;
    }
}
