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
    /// Complete old stye parameter, short parameter, or it's argument
    /// </summary>
    /// <param name="tokenValue">a token of command line argument which starts with <see cref="ParamIndicator"/></param>
    /// <param name="cursorPosition">Position of cursor in token</param>.
    public Collection<CompletionResult?> CompleteOldStyleOrShortParams(ReadOnlySpan<char> tokenValue, int cursorPosition)
    {
        Debug($"Start CompleteOldStyleOrShortParams('{tokenValue}', {cursorPosition})");
        var paramName = tokenValue[ParamIndicator.Length..];
        cursorPosition -= ParamIndicator.Length;

        Collection<CompletionResult?> results;
        // Old style parameter completion
        results = CompleteOldStyleParams(paramName.ToString(), cursorPosition);

        if (results.Count > 0)
            return results;

        return CompleteShortParams(paramName, cursorPosition);
    }

    private Collection<CompletionResult?> CompleteOldStyleParams(string paramName, int offsetPosition)
    {
        Collection<CompletionResult?> results = [];
        foreach (var param in Params.Where(p => p.OldStyleNames.Length > 0))
        {
            var names = string.IsNullOrEmpty(paramName)
                ? param.OldStyleNames
                : param.OldStyleNames.Where(n => n.StartsWith(paramName, StringComparison.OrdinalIgnoreCase)).ToArray();
            if (names.Length == 0)
                continue;

            var text = $"{ParamIndicator}{names[0]} ";
            var desc = string.IsNullOrEmpty(param.Description) ? string.Empty : $" ({param.Description})";
            var listItemText = $"{string.Join(" ", names.Select(n => $"{ParamIndicator}{n}"))}{desc}";
            var allNames = names.Select(n => $"{ParamIndicator}{n}")
                                .Union(param.ShortNames.Select(c => $"{ParamIndicator}{c}"))
                                .Union(param.LongNames.Select(n => $"{LongParamIndicator}{n}"));
            var tooltip = $"{string.Join(" ", allNames)}{desc}";

            results.Add(new(text, listItemText, CompletionResultType.ParameterName, tooltip));
            Debug($"CompleteOldStyleParam {{ '{text}', '{listItemText}', '{tooltip}' }}");
        }
        return results;
    }

    private Collection<CompletionResult?> CompleteShortParams(ReadOnlySpan<char> tokenValue, int offsetPosition)
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
                    && !param.Type.HasFlag(ArgumentType.Flag))
                {
                    var paramValue = tokenValue[(position + 1)..];
                    var paramName = tokenValue[..(position + 1)];
                    offsetPosition -= position + 1;
                    return param.CompleteValue($"{paramChar}",
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
        Collection<CompletionResult?> results = [];
        var paramName1 = tokenValue[..offsetPosition];
        var paramName2 = tokenValue[offsetPosition..];
        foreach (var param in remainingParams)
        {
            var desc = $" ({param.Description})";
            var names = param.ShortNames.Select(n => $"{ParamIndicator}{n}")
                                        .Union(param.OldStyleNames.Select(n => $"{ParamIndicator}{n}"))
                                        .Union(param.LongNames.Select(n => $"{LongParamIndicator}{n}"));
            var tooltip = $"{string.Join(" ", names)}{desc}";
            foreach (var c in param.ShortNames)
            {
                var text = $"{ParamIndicator}{paramName1}{c}{paramName2} ";
                var listItemText = $"{ParamIndicator}{paramName1}{c}{paramName2}{desc}";
                results.Add(new(text, listItemText, CompletionResultType.ParameterName, tooltip));
                Debug($"CompleteShortParam {{ '{text}', '{listItemText}', '{tooltip}' }}");
            }
        }
        if (results.Count == 0)
        {
            // Prevent fallback to filename completion
            results.Add(null);
        }
        return results;
    }
}
