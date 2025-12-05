using System.Collections.ObjectModel;
using System.Diagnostics;
using System.Management.Automation;

namespace MT.Comp;

public class CommandCompleter(string name,
                              string description = "",
                              string longOptionPrefix = "--",
                              string shortOptionPrefix = "-",
                              char valueSeparator = '=')
{
    [Conditional("DEBUG")]
    private void Debug(string msg)
    {
        NativeCompleter.Messages.Add($"[{Name}]: {msg}");
    }

    internal readonly string LongOptionPrefix = longOptionPrefix;
    internal readonly string ShortOptionPrefix = shortOptionPrefix;
    internal readonly char ValueSeparator = valueSeparator;

    public string Name { get; } = name;
    public string[] Aliases { get; set; } =  [];
    public string Description { get; set; } = description;
    public Collection<ParamCompleter> Params { get; } = [];
    public Collection<CommandCompleter> SubCommands { get; } = [];
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

    /// <summary>
    /// Parse arguments in the completion context.
    /// </summary>
    /// <param name="context"></param>
    /// <returns></returns>
    public CompletionContext ParseArguments(CompletionContext context)
    {
        NativeCompleter.Messages.Add($"[{Name}] Build CompletionContext");

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
        bool hasLongOptionPrefix = !string.IsNullOrEmpty(LongOptionPrefix);
        bool hasShortOptionPrefix = !string.IsNullOrEmpty(ShortOptionPrefix);

        for (int argumentIndex = 0; argumentIndex < argumentsCount; argumentIndex++)
        {
            Token token = context.Arguments[argumentIndex];
            ReadOnlySpan<char> tokenValue = token.Value;
            string optionPrefix;

            if (SubCommands.Count > 0)
            {
                string tokenStr = tokenValue.ToString();
                foreach (var subCmd in SubCommands)
                {
                    if (subCmd.Name.Equals(tokenStr, StringComparison.Ordinal)
                        || subCmd.Aliases.Any(a => a.Equals(tokenStr, StringComparison.Ordinal)))
                    {
                        return context.CreateNestedContext(subCmd, argumentIndex);
                    }
                }
            }

            if (hasLongOptionPrefix
                && tokenValue.StartsWith(LongOptionPrefix, StringComparison.Ordinal))
            {
                optionPrefix = LongOptionPrefix;
                var paramName = tokenValue[optionPrefix.Length..];
                var separatorIndex = tokenValue.IndexOf(ValueSeparator);
                if (separatorIndex > 0)
                {
                    // In case the token contains both parameter name and value,
                    // like `--longParam=Value`.
                    var paramValue = tokenValue[(separatorIndex + 1)..];
                    paramName = tokenValue[optionPrefix.Length..separatorIndex];
                    foreach (var param in Params)
                    {
                        if (param.IsMatchLongParam(paramName, out var outParamName))
                        {
                            context.AddBoundParameter(param.Name, $"{paramValue}");
                            break;
                        }
                    }
                }
                else
                {
                    foreach (var param in Params)
                    {
                        if (param.IsMatchLongParam(paramName, out var outParamName))
                        {
                            if (param.Type == ArgumentType.Flag
                                || param.Type.HasFlag(ArgumentType.FlagOrValue))
                            {
                                context.AddBoundParameter(param.Name, true);
                                break;
                            }
                            else if (argumentIndex < argumentsCount - 1)
                            {
                                // `--longParam value ...|`
                                //                       ^ cursor
                                argumentIndex++;
                                context.AddBoundParameter(param.Name, context.Arguments[argumentIndex].Value);
                                break;
                            }
                            else
                            {
                                // `--longParam |`
                                //              ^ cursor
                                context.SetPendingParameter(param, $"{outParamName}", optionPrefix);
                            }
                            break;
                        }
                    }
                }
            }
            else if (hasShortOptionPrefix
                     && tokenValue.StartsWith(ShortOptionPrefix, StringComparison.Ordinal))
            {
                optionPrefix = ShortOptionPrefix;
                var paramName = tokenValue[optionPrefix.Length..];
                bool found = false;
                foreach (var param in Params)
                {
                    found = param.IsMatchOldStyleParam(paramName, out var outParamName);
                    if (found)
                    {
                        if (param.Type == ArgumentType.Flag)
                        {
                            context.AddBoundParameter(param.Name, true);
                        }
                        else if (argumentIndex < argumentsCount - 1)
                        {
                            // `-oldStyleParam value ...|`
                            //                          ^ cursor
                            argumentIndex++;
                            context.AddBoundParameter(param.Name, context.Arguments[argumentIndex].Value);
                        }
                        else
                        {
                            // `-oldStyleParam |`
                            //                 ^ cursor
                            context.SetPendingParameter(param, $"{outParamName}", optionPrefix);
                        }
                        break;
                    }
                }

                if (found)
                    continue;

                var shortParams = Params.Where(p => p.ShortNames.Length > 0);
                for (var i = 0; i < paramName.Length; i++)
                {
                    var c = paramName[i];
                    var p = shortParams.FirstOrDefault(p => p.ShortNames.Contains(c));
                    if (p is null)
                        continue;

                    if (!p.ShortNames.Contains(c))
                        continue;

                    if (p.Type.HasFlag(ArgumentType.FlagOrValue))
                    {
                        // e.g. `sed -i[.bk]`
                        context.AddBoundParameter(p.Name, $"{paramName[(i + 1)..]}");
                        break;
                    }
                    else if (p.Type == ArgumentType.Flag)
                    {
                        context.AddBoundParameter(p.Name, true);
                    }
                    else if (i == paramName.Length - 1)
                    {
                        if (argumentIndex < argumentsCount - 1)
                        {
                            // `-abc Value ... |`
                            //      \          ^ cursor
                            //       i
                            // the argument of `c` param is supplied
                            argumentIndex++;
                            context.AddBoundParameter(p.Name, context.Arguments[argumentIndex].Value);
                        }
                        else
                        {
                            // `-abc  |`
                            //      \ ^ cursor
                            //       i
                            // the argument of `c` param is NOT supplied
                            context.SetPendingParameter(p, $"{c}", optionPrefix);
                        }
                        break;
                    }
                    else
                    {
                        context.AddBoundParameter(p.Name, $"{paramName[(i + 1)..]}");
                        break;
                    }
                }
            }
            else
            {
                if (context.UnboundArguments.Count == DelegateArgumentIndex)
                {
                    var cmdName = Path.GetFileName(tokenValue).ToString();
                    return NativeCompleter.TryGetCommandCompleter(cmdName, null, out var delegatedCompleter, out _)
                        ? context.CreateNestedContext(delegatedCompleter, argumentIndex)
                        : context.CreateNestedContext(new(cmdName, "Unknown"), argumentIndex);
                }
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

        foreach (var subCommand in SubCommands)
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
        if (tokenValue.IsEmpty)
            return completed;

        if (Params.Count == 0)
            return completed;

        if (tokenValue.Equals(ShortOptionPrefix, StringComparison.Ordinal))
        {
            completed = CompleteAllParams(results, context);
        }
        else if (!string.IsNullOrEmpty(LongOptionPrefix)
            && tokenValue.StartsWith(LongOptionPrefix, StringComparison.Ordinal))
        {
            completed = CompleteLongParams(results, context, tokenValue, cursorPosition);
        }
        else if (!string.IsNullOrEmpty(ShortOptionPrefix)
                 && tokenValue.StartsWith(ShortOptionPrefix, StringComparison.Ordinal))
        {
            completed = CompleteOldStyleParams(results, context, tokenValue, cursorPosition)
                        || CompleteShortParams(results, context, tokenValue, cursorPosition);
        }

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
    /// <see langword="true"/> if completion is end (prevent fallback to filename completion); otherwise, <see langword="false"/>.
    /// </returns>
    private bool CompleteLongParams(ICollection<CompletionData> results,
                                    CompletionContext context,
                                    ReadOnlySpan<char> tokenValue,
                                    int cursorPosition)
    {
        Debug($"Start CompleteLongParams('{tokenValue}', {cursorPosition})");
        const StringComparison comparison = StringComparison.OrdinalIgnoreCase;
        string optionPrefix = LongOptionPrefix;
        string paramName;
        int position;
        int separatorPosition = tokenValue.IndexOf(ValueSeparator);

        //
        // attempt to complete parameter's value if value separator (like '=') exists
        //
        if (separatorPosition > 0 && separatorPosition < cursorPosition)
        {
            paramName = $"{tokenValue[optionPrefix.Length..separatorPosition]}";
            var param = Params.FirstOrDefault(p => p.LongNames.Any(n => n.Equals(paramName, comparison)));
            if (param is not null)
            {
                var paramValue = $"{tokenValue[(separatorPosition + 1)..]}";
                position = cursorPosition - separatorPosition - 1;
                param.CompleteValue(results,
                                    context,
                                    paramName,
                                    paramValue,
                                    position,
                                    optionPrefix,
                                    $"{tokenValue[..(separatorPosition + 1)]}");
            }
            return true;
        }

        //
        // complete parameter names
        //
        paramName = $"{tokenValue[optionPrefix.Length..cursorPosition]}";
        position = cursorPosition - optionPrefix.Length;

        foreach (var param in Params.Where(p => p.LongNames.Length > 0))
        {
            var names = string.IsNullOrEmpty(paramName)
                ? param.LongNames
                : param.LongNames.Where(n => n.StartsWith(paramName, StringComparison.OrdinalIgnoreCase)).ToArray();
            if (names.Length == 0)
                continue;

            var tooltip = $"""
                [{param.Type}] {param.GetSyntaxes(LongOptionPrefix, ShortOptionPrefix, ValueSeparator, expandArguments: true)}
                {param.Description}
                """;
            var suffix = param.Type is ArgumentType.Flag ? " " : string.Empty;
            foreach (var name in names)
            {
                var listItemText = param.GetSyntax($"{optionPrefix}{name}", ValueSeparator, true, false);
                results.Add(new CompletionParam($"{optionPrefix}{name}{suffix}",
                                                param.Description,
                                                listItemText,
                                                tooltip));
            }
        }

        return true;
    }

    /// <summary>
    /// Complete old-style parameters
    /// </summary>
    /// <param name="results">Completion result data to be stored</param>
    /// <param name="context">Completion context</param>
    /// <param name="tokenValue">Parameter name to be completed</param>
    /// <param name="offsetPosition">Position of cursor in <paramref name="paramName"/></param>.
    /// <returns>
    /// <see langword="true"/> if completion is end (prevent fallback to filename completion); otherwise, <see langword="false"/>.
    /// </returns>
    private bool CompleteOldStyleParams(ICollection<CompletionData> results,
                                        CompletionContext context,
                                        ReadOnlySpan<char> tokenValue,
                                        int offsetPosition)
    {
        bool completed = false;
        Debug($"OldStyleParam {{ tokenValue='{tokenValue}', position={offsetPosition} }}");
        var paramName = tokenValue[ShortOptionPrefix.Length..];
        foreach (var param in Params.Where(p => p.OldStyleNames.Length > 0))
        {
            foreach (ReadOnlySpan<char> name in param.OldStyleNames)
            {
                if (paramName.IsEmpty || name.StartsWith(paramName, StringComparison.OrdinalIgnoreCase))
                {
                    var text = $"{ShortOptionPrefix}{name} ";
                    var listItemText = param.GetSyntax($"{ShortOptionPrefix}{name}", default, false, true);
                    var tooltip = $"""
                        [{param.Type}] {param.GetSyntaxes(LongOptionPrefix, ShortOptionPrefix, ValueSeparator, expandArguments: true)}
                        {param.Description}
                        """;
                    results.Add(new CompletionParam(text, param.Description, listItemText, tooltip));
                    completed = true;
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
    /// <see langword="true"/> if completion is end (prevent fallback to filename completion); otherwise, <see langword="false"/>.
    /// </returns>
    private bool CompleteShortParams(ICollection<CompletionData> results,
                                     CompletionContext context,
                                     ReadOnlySpan<char> tokenValue,
                                     int offsetPosition)
    {
        Collection<ParamCompleter> remainingParams = [];
        var paramNameAndValue = tokenValue[ShortOptionPrefix.Length..];
        offsetPosition -= ShortOptionPrefix.Length;
        (ParamCompleter? Completer, char ParamChar, int Position) pending = (null, default, 0);
        //
        // attempt to complete parameter's value, and store parameter as candidates when not matched
        //
        Debug($"ShortParam {{ tokenValue='{tokenValue}', position={offsetPosition} }}");
        foreach (var param in Params.Where(p => p.ShortNames.Length > 0))
        {
            if (param.IsMatchShortParam(paramNameAndValue, out char paramChar, out int position))
            {
                Debug($"ShortParam Matched {{ '{paramChar}', {position} }}");
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
            else if (offsetPosition == paramNameAndValue.Length)
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
                                                   paramNameAndValue[pending.Position..],
                                                   offsetPosition - pending.Position,
                                                   ShortOptionPrefix,
                                                   $"{ShortOptionPrefix}{paramNameAndValue[..pending.Position]}");
        }

        //
        // complete parameter names
        //
        var paramPrefix = paramNameAndValue[..offsetPosition];
        var paramSuffix = paramNameAndValue[offsetPosition..];
        foreach (var param in remainingParams)
        {
            if (!paramSuffix.IsEmpty && param.Type is not ArgumentType.Flag)
                continue;

            var tooltip = $"""
                [{param.Type}] {param.GetSyntaxes(LongOptionPrefix, ShortOptionPrefix, ValueSeparator, expandArguments: true)}
                {param.Description}
                """;
            foreach (var c in param.ShortNames)
            {
                var text = $"{ShortOptionPrefix}{paramPrefix}{c}{paramSuffix}";
                var listItemText = param.GetSyntax($"{ShortOptionPrefix}{c}", default, true, false);
                results.Add(new CompletionParam(text, param.Description, listItemText, tooltip));
            }
        }

        return true;
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

        Debug($"CompleterArgument {{ '{tokenValue}', {cursorPosition}, {argumentIndex} }}");
        Collection<PSObject?>? invokeResults = null;
        try
        {
            Debug($"Start Argument complete {{ '{tokenValue}', {cursorPosition}, {argumentIndex} }}");
            invokeResults = ArgumentCompleter.GetNewClosure()
                                             .InvokeWithContext(null,
                                                                [new("_", tokenValue), new("this", context)],
                                                                cursorPosition,
                                                                argumentIndex);
            Debug($"ArgumentCompleter results {{ count = {invokeResults.Count} }}");
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
    /// <returns>
    /// <see langword="true"/> if completion is end (prevent fallback to filename completion); otherwise, <see langword="false"/>.
    /// </returns>
    private bool CompleteAllParams(ICollection<CompletionData> results,
                                   CompletionContext context)
    {
        if (Params.Count == 0)
            return false;

        foreach (var param in Params)
        {
            var text = param.ShortNames.Select(n => $"{ShortOptionPrefix}{n}")
                                       .Union(param.OldStyleNames.Select(n => $"{ShortOptionPrefix}{n}"))
                                       .Union(param.LongNames.Select(n => $"{LongOptionPrefix}{n}"))
                                       .First();
            var listItemText = param.GetSyntaxes(LongOptionPrefix, ShortOptionPrefix, ValueSeparator, " ", false);
            var tooltip = $"""
                [{param.Type}] {param.GetSyntaxes(LongOptionPrefix, ShortOptionPrefix, ValueSeparator, ", ", true)}
                {param.Description}
                """;
            results.Add(new CompletionParam(text, param.Description, listItemText, tooltip));
            Debug($"CompleteAllParams {{ '{text}', '{listItemText}', '{tooltip}' }}");
        }
        return true;
    }
}
