using System.Collections;
using System.Collections.ObjectModel;
using System.Text;

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
    public ArgumentCompleterCollection Arguments { get; internal set; } = [];
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
                if (param.Type is ParameterType.Flag
                    || (param.Type is ParameterType.FlagOrValue && paramValue.IsEmpty))
                {
                    context.AddBoundParameter(param.Id, true);
                }
                else if (paramValue.IsEmpty)
                {
                    advancedCount = SetParameterArguments(context, argumentIndex, param, $"{paramName}", optionPrefix);
                }
                else
                {
                    context.AddBoundParameter(param.Id, $"{paramValue}");
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
        bool result = false;
        advancedCount = 0;
        if (tokenValue.IsEmpty)
            return result;

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

            if (p.Type is ParameterType.Flag)
            {
                context.AddBoundParameter(p.Id, true);
            }
            else if (i == inputValue.Length - 1)
            {
                if (argumentIndex < context.Arguments.Count - 1)
                {
                    // `-abc Value ... |`
                    //      \          ^ cursor
                    //       i
                    // the argument of `c` param is supplied
                    advancedCount = SetParameterArguments(context, argumentIndex, p, $"{c}", p.Style.ShortOptionPrefix);
                }
                else
                {
                    // `-abc  |`
                    //      \ ^ cursor
                    //       i
                    // the argument of `c` param is NOT supplied
                    context.SetPendingParameter(p, $"{c}", [], p.Style.ShortOptionPrefix);
                }
            }
            else
            {
                context.AddBoundParameter(p.Id, $"{inputValue[(i + 1)..]}");
            }
            result = true;
        }
        return result;
    }

    private int SetParameterArguments(CompletionContext context,
                                      int argumentIndex,
                                      ParamCompleter param,
                                      string paramName,
                                      string optionPrefix)
    {
        var argCount = 1;
        for (; argCount < context.Arguments.Count - argumentIndex; argCount++)
        {
            if (argCount <= param.Nargs.MinCount)
            {
                continue;
            }
            else if (param.Nargs.ConsumeRest || argCount <= param.Nargs.MaxCount)
            {
                var token = context.Arguments[argumentIndex + argCount].Value;
                // Short options are not taken into account. This is a specification.
                if (Params.Any(p => p.ParseParam(token, out _, out _, out _)))
                    break;
                continue;
            }
            else
            {
                break;
            }
        }
        var paramArgs = context.Arguments.Take((argumentIndex + 1)..(argumentIndex + argCount))
                                         .Select(token => token.Value)
                                         .ToArray();
        NativeCompleter.Debug($"SetParameterArguments {{ Id={param.Id} Nargs={param.Nargs} ArgsCount={paramArgs.Length} }}");
        if (paramArgs.Length >= param.Nargs.MinCount)
        {
            // `-param ..value(minCount) ...|`
            //                              ^ cursor
            context.AddBoundParameter(param.Id, paramArgs);
            if (param.Nargs.ConsumeRest || paramArgs.Length < param.Nargs.MaxCount)
            {
                // `-param ..value(minCount) .. | .. valueN(maxCount)
                //                              ^ cursor
                context.SetPendingParameter(param, $"{paramName}", paramArgs.ToArray(), $"{optionPrefix}", false);
            }
        }
        else
        {
            // `-param |`      or `-param value1 .. | ..valueN(minCount)
            //         ^ cursor                     ^ cursor
            context.SetPendingParameter(param, $"{paramName}", paramArgs.ToArray(), $"{optionPrefix}", true);
        }

        return paramArgs.Length;
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

            // Attempt to parse as long parameter or standard parameter
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
    /// <param name="offsetPosition">Position of cursor in token</param>.
    /// <returns>
    /// <see langword="true"/> if completion is end (prevent fallback to filename completion); otherwise, <see langword="false"/>.
    /// </returns>
    public bool CompleteParams(ICollection<CompletionData> results,
                               CompletionContext context,
                               ReadOnlySpan<char> tokenValue,
                               int offsetPosition)
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

        completed = CompleteLongParams(results, context, tokenValue, offsetPosition)
                    || CompleteStandardParams(results, context, tokenValue, offsetPosition)
                    || CompleteShortParams(results, context, tokenValue, offsetPosition);

        return completed;
    }

    /// <summary>
    /// Complete long parameters, or it's argument
    /// </summary>
    /// <param name="results">Completion result data to be stored</param>
    /// <param name="context">Completion context</param>.
    /// <param name="tokenValue">a token of command line argument which starts with <see cref="LongOptionPrefix"/></param>
    /// <param name="offsetPosition">Position of cursor in token</param>.
    /// <returns>
    /// <see langword="true"/> if completion is end; otherwise, <see langword="false"/>.
    /// </returns>
    private bool CompleteLongParams(ICollection<CompletionData> results,
                                    CompletionContext context,
                                    ReadOnlySpan<char> tokenValue,
                                    int offsetPosition)
    {
        NativeCompleter.Debug($"[{context.Name}] Start CompleteLongParams {{ '{tokenValue}', {offsetPosition} }}");
        var longParams = Params.Where(p => p.LongNames.Length > 0);
        foreach (var param in longParams.Where(p => p.Type is not ParameterType.Flag
                                                    && p.Style.ValueStyle.HasFlag(ParameterValueStyle.Adjacent)))
        {
            var optionPrefix = param.Style.LongOptionPrefix;
            if (!tokenValue.StartsWith(optionPrefix, StringComparison.Ordinal))
                continue;
            if (param.ParseLongParam(tokenValue[optionPrefix.Length..], out var name, out var value))
            {
                var separatorPosition = name.Length + optionPrefix.Length;
                if (separatorPosition >= offsetPosition)
                    break;
                NativeCompleter.Debug($"  Matched Param {{ Id='{param.Id}', name='{name}', value='{value}' }}");
                param.CompleteValue(results,
                                    context,
                                    $"{name}",
                                    $"{value}",
                                    [],
                                    offsetPosition - separatorPosition - 1,
                                    param.Style.LongOptionPrefix,
                                    $"{tokenValue[..(separatorPosition + 1)]}");
                return true;
            }
        }
        bool completed = false;
        var prefixValue = tokenValue[..offsetPosition];
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
    /// Complete standard parameters
    /// </summary>
    /// <param name="results">Completion result data to be stored</param>
    /// <param name="context">Completion context</param>
    /// <param name="tokenValue">Parameter name to be completed</param>
    /// <param name="offsetPosition">Position of cursor in <paramref name="paramName"/></param>.
    /// <returns>
    /// <see langword="true"/> if completion is end; otherwise, <see langword="false"/>.
    /// </returns>
    private bool CompleteStandardParams(ICollection<CompletionData> results,
                                        CompletionContext context,
                                        ReadOnlySpan<char> tokenValue,
                                        int offsetPosition)
    {
        NativeCompleter.Debug($"[{context.Name}] Start CompleteStandardParams {{ '{tokenValue}', {offsetPosition} }}");
        var standardParams = Params.Where(p => p.StandardNames.Length > 0);
        foreach (var param in standardParams.Where(p => p.Type is not ParameterType.Flag
                                                        && p.Style.ValueStyle.HasFlag(ParameterValueStyle.Adjacent)))
        {
            var optionPrefix = param.Style.ShortOptionPrefix;
            if (!tokenValue.StartsWith(optionPrefix, StringComparison.Ordinal))
                continue;
            if (param.ParseStandardParam(tokenValue[optionPrefix.Length..], out var name, out var value))
            {
                var separatorPosition = name.Length + optionPrefix.Length;
                if (separatorPosition >= offsetPosition)
                    break;
                NativeCompleter.Debug($"  Matched Param {{ Id='{param.Id}', name='{name}', value='{value}' }}");
                param.CompleteValue(results,
                                    context,
                                    $"{name}",
                                    $"{value}",
                                    [],
                                    offsetPosition - separatorPosition - 1,
                                    param.Style.ShortOptionPrefix,
                                    $"{tokenValue[..(separatorPosition + 1)]}");
                return true;
            }
        }
        //
        // complete parameter names
        //
        bool completed = false;
        var prefixValue = tokenValue[..offsetPosition];
        foreach (var param in standardParams)
        {
            var shortOptionPrefix = param.Style.ShortOptionPrefix;
            if (!prefixValue.StartsWith(shortOptionPrefix, StringComparison.Ordinal))
                continue;
            foreach (ReadOnlySpan<char> name in param.StandardNames)
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
        NativeCompleter.Debug($"[{context.Name}] Start CompleteShortParams {{ '{tokenValue}', {offsetPosition} }}");
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
                    && param.Type is not ParameterType.Flag)
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
            else if (param.Type is ParameterType.Flag)
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
                                                   [],
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
            if (!paramSuffix.IsEmpty && param.Type is not ParameterType.Flag)
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
    /// Get the command syntax contains arguments
    /// </summary>
    /// <param name="cmdName">Command name. If omitted, <see cref="Name"/> is used</param>
    public string GetSyntax(string? cmdName = null)
    {
        StringBuilder sb = new();
        PrintSyntax(sb, cmdName);
        return sb.ToString();
    }

    /// <summary>
    /// Append the command syntax contains arguments to <paramref name="sb"/>
    /// </summary>
    /// <param name="sb"></param>
    /// <param name="cmdName">Command name. If omitted, <see cref="Name"/> is used</param>
    private void PrintSyntax(StringBuilder sb, string? cmdName = null)
    {
        if (sb.Length > 0)
            sb.Append(' ');
        sb.Append(string.IsNullOrEmpty(cmdName) ? Name : cmdName);
        if (Aliases.Length > 0)
        {
            sb.Append(" (Alias:")
              .AppendJoin('|', Aliases)
              .Append(')');
        }
        sb.Append(' ');
        Arguments.PrintSyntax(sb);
    }

    /// <summary>
    /// Complete remaining argumet's value (non parameter, non parameter value and non subcommand)
    /// </summary>
    /// <param name="results">Completion result data to be stored</param>
    /// <param name="context">Completion context</param>
    /// <param name="tokenValue">a token of command line argument</param>
    /// <param name="offsetPosition">Position of cursor in token</param>.
    /// <param name="argumentIndex">argument's index which starts 0 without command name</param>
    /// <returns>
    /// <see langword="true"/> if completion is end (prevent fallback to filename completion); otherwise, <see langword="false"/>.
    /// </returns>
    public bool CompleteArgument(ICollection<CompletionData> results,
                                 CompletionContext context,
                                 string tokenValue,
                                 int offsetPosition,
                                 int argumentIndex)
    {
        var ac = Arguments.GetByArgumentIndex(argumentIndex);
        if (ac is null)
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
        else
        {
            var tooltipPrefix = $"""
                {GetSyntax(context.Name)}{(string.IsNullOrEmpty(ac.Description) ? string.Empty : $" : {ac.Description}")}
                [{argumentIndex + 1}]: 
                """;

            NativeCompleter.Debug($"[{context.Name}] ArgumentCompleter {{ name: '{ac.Name}', value: '{tokenValue}', index: {argumentIndex} }}");
            IEnumerable<CompletionData> candidates;
            if (ac.List)
            {
                var result = Helper.ResolveListElement(tokenValue, offsetPosition);
                candidates = ac.Complete(context, result.Slice(tokenValue), result.OffsetPosition, argumentIndex);
            }
            else
            {
                candidates = ac.Complete(context, tokenValue, offsetPosition, argumentIndex);
            }
            int count = 0;
            foreach (var data in candidates)
            {
                results.Add(data.SetTooltipPrefix(tooltipPrefix));
                count++;
            }
            NativeCompleter.Debug($"  ArgumentCompleter results {{ count = {count} }}");
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
                                       .Union(param.StandardNames.Select(n => $"{style.ShortOptionPrefix}{n}{suffix}"))
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
