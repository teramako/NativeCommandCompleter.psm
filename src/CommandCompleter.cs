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
        var subCommands = string.IsNullOrEmpty(tokenValue)
            ? SubCommands
            : SubCommands.Where(kv => kv.Key.StartsWith(tokenValue, StringComparison.OrdinalIgnoreCase));

        foreach (var kv in subCommands)
        {
            var text = kv.Value.Name;
            results.Add(new CompletionValue(text, kv.Value.Description).SetTooltipPrefix($"[{Name}] "));
        }

        return true;
    }

    /// <summary>
    /// Complete long parameters, or it's argument
    /// </summary>
    /// <param name="results">Completion result data to be stored</param>
    /// <param name="context">Completion context</param>.
    /// <param name="tokenValue">a token of command line argument which starts with <see cref="LongParamIndicator"/></param>
    /// <param name="cursorPosition">Position of cursor in token</param>.
    /// <returns>
    /// <see langword="true"/> if completion is end (prevent fallback to filename completion); otherwise, <see langword="false"/>.
    /// </returns>
    public bool CompleteLongParams(ICollection<CompletionData> results,
                                   CompletionContext context,
                                   ReadOnlySpan<char> tokenValue,
                                   int cursorPosition)
    {
        Debug($"Start CompleteLongParams('{tokenValue}', {cursorPosition})");
        const StringComparison comparison = StringComparison.OrdinalIgnoreCase;
        string indicator = LongParamIndicator;
        ReadOnlySpan<char> paramName = tokenValue[indicator.Length..];
        string sParamName;
        int position;
        int separatorPosition = tokenValue.IndexOf(ValueSeparator);

        //
        // attempt to complete parameter's value if value separator (like '=') exists
        //
        if (separatorPosition > 0 && separatorPosition < cursorPosition)
        {
            sParamName = $"{tokenValue[indicator.Length..separatorPosition]}";
            var param = Params.FirstOrDefault(p => p.LongNames.Any(n => n.Equals(sParamName, comparison)));
            if (param is not null)
            {
                var sParamValue = $"{tokenValue[(separatorPosition + 1)..]}";
                position = cursorPosition - separatorPosition - 1;
                param.CompleteValue(results,
                                    context,
                                    sParamName,
                                    sParamValue,
                                    position,
                                    indicator,
                                    $"{tokenValue[..(separatorPosition + 1)]}");
            }
            return true;
        }

        //
        // complete parameter names
        //
        sParamName = $"{tokenValue[indicator.Length..cursorPosition]}";
        position = cursorPosition - indicator.Length;

        foreach (var param in Params.Where(p => p.LongNames.Length > 0))
        {
            var names = string.IsNullOrEmpty(sParamName)
                ? param.LongNames
                : param.LongNames.Where(n => n.StartsWith(sParamName, StringComparison.OrdinalIgnoreCase)).ToArray();
            if (names.Length == 0)
                continue;

            var flagOrValue = param.Type.HasFlag(ArgumentType.FlagOrValue);
            foreach (var name in names)
            {
                results.Add(new CompletionParam($"{indicator}{name} ",
                                                param.Description,
                                                $"{indicator}{name}",
                                                $"[{param.Type}] {name}"));
                if (flagOrValue)
                {
                    results.Add(new CompletionParam($"{indicator}{name}{ValueSeparator}",
                                                    param.Description,
                                                    $"{indicator}{name}{ValueSeparator}",
                                                    $"[{param.Type}] {name}"));
                }
            }
        }

        return true;
    }

    /// <summary>
    /// Complete old-style parameters, short parameters, or their argument.
    /// </summary>
    /// <param name="results">Completion result data to be stored</param>
    /// <param name="context">Completion context</param>
    /// <param name="tokenValue">a token of command line argument which starts with <see cref="ParamIndicator"/></param>
    /// <param name="cursorPosition">Position of cursor in token</param>.
    /// <returns>
    /// <see langword="true"/> if completion is end (prevent fallback to filename completion); otherwise, <see langword="false"/>.
    /// </returns>
    public bool CompleteOldStyleOrShortParams(ICollection<CompletionData> results,
                                              CompletionContext context,
                                              ReadOnlySpan<char> tokenValue,
                                              int cursorPosition)
    {
        Debug($"Start CompleteOldStyleOrShortParams('{tokenValue}', {cursorPosition})");
        var paramName = tokenValue[ParamIndicator.Length..];
        cursorPosition -= ParamIndicator.Length;

        // Old style parameter completion
        CompleteOldStyleParams(results, context, paramName.ToString(), cursorPosition);

        if (results.Count > 0)
            return true;

        return CompleteShortParams(results, context, paramName, cursorPosition);
    }

    /// <summary>
    /// Complete old-style parameters
    /// </summary>
    /// <param name="results">Completion result data to be stored</param>
    /// <param name="context">Completion context</param>
    /// <param name="paramName">Parameter name to be completed</param>
    /// <param name="offsetPosition">Position of cursor in <paramref name="paramName"/></param>.
    /// <returns>
    /// <see langword="true"/> if completion is end (prevent fallback to filename completion); otherwise, <see langword="false"/>.
    /// </returns>
    private bool CompleteOldStyleParams(ICollection<CompletionData> results,
                                        CompletionContext context,
                                        string paramName,
                                        int offsetPosition)
    {
        foreach (var param in Params.Where(p => p.OldStyleNames.Length > 0))
        {
            var names = string.IsNullOrEmpty(paramName)
                ? param.OldStyleNames
                : param.OldStyleNames.Where(n => n.StartsWith(paramName, StringComparison.OrdinalIgnoreCase)).ToArray();
            if (names.Length == 0)
                continue;

            foreach (var name in names)
            {
                var text = $"{ParamIndicator}{name} ";
                var listItemText = $"{ParamIndicator}{name}";
                var tooltip = $"[{param.Type}] {name}";
                results.Add(new CompletionParam(text, param.Description, listItemText, tooltip));
            }
        }
        return true;
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
        //
        // attempt to complete parameter's value, and store parameter as candidates when not matched
        //
        foreach (var param in Params.Where(p => p.ShortNames.Length > 0))
        {
            if (param.IsMatchShortParam(tokenValue, out char paramChar, out int position))
            {
                if (position < offsetPosition
                    && (param.Type.HasFlag(ArgumentType.Required)
                        || param.Type.HasFlag(ArgumentType.FlagOrValue)))
                {
                    var paramValue = tokenValue[(position + 1)..];
                    var paramName = tokenValue[..(position + 1)];
                    offsetPosition -= position + 1;
                    return param.CompleteValue(results,
                                               context,
                                               $"{paramChar} ",
                                               paramValue,
                                               offsetPosition,
                                               ParamIndicator,
                                               $"{ParamIndicator}{paramName}");
                }
            }
            else if (offsetPosition == tokenValue.Length)
            {
                // -aPc|
                //   ^ target
                // If the cursor position is at the end, add the parameter even if it is not a Flag type
                remainingParams.Add(param);
            }
            else if (param.Type.HasFlag(ArgumentType.Flag))
            {
                // -aP|c
                //   ^ target
                // Add only the parameter type is Flag
                remainingParams.Add(param);
            }
        }

        //
        // complete parameter names
        //
        var paramName1 = tokenValue[..offsetPosition];
        var paramName2 = tokenValue[offsetPosition..];
        foreach (var param in remainingParams)
        {
            foreach (var c in param.ShortNames)
            {
                var text = $"{ParamIndicator}{paramName1}{c}{paramName2}";
                var tooltip = $"[{param.Type}] {c}";
                results.Add(new CompletionParam(text, param.Description, text, tooltip));
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
            return false;

        Debug($"CompleterArgument {{ '{tokenValue}', {cursorPosition}, {argumentIndex} }}");
        Collection<PSObject?>? invokeResults = null;
        try
        {
            Debug($"Start Argument complete {{ '{tokenValue}', {cursorPosition}, {argumentIndex} }}");
            invokeResults = ArgumentCompleter.Invoke(tokenValue, cursorPosition, argumentIndex, context);
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
        return false;
    }

    /// <summary>
    /// Complete all parameters
    /// </summary>
    /// <param name="results">Completion result data to be stored</param>
    /// <param name="context">Completion context</param>
    /// <returns>
    /// <see langword="true"/> if completion is end (prevent fallback to filename completion); otherwise, <see langword="false"/>.
    /// </returns>
    public bool CompleteAllParams(ICollection<CompletionData> results,
                                  CompletionContext context)
    {
        foreach (var param in Params)
        {
            var names = param.ShortNames.Select(n => $"{ParamIndicator}{n}")
                                        .Union(param.OldStyleNames.Select(n => $"{ParamIndicator}{n}"))
                                        .Union(param.LongNames.Select(n => $"{LongParamIndicator}{n}"));
            var text = names.First();
            var listItemText = string.Join(' ', names);
            var tooltip = $"[{param.Type}] {listItemText}";
            results.Add(new CompletionParam(text, param.Description, listItemText, tooltip));
            Debug($"CompleteAllParams {{ '{text}', '{listItemText}', '{tooltip}' }}");
        }
        return true;
    }
}
