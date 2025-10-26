using System.Diagnostics;
using System.Management.Automation;

namespace MT.Comp;

[Flags]
public enum ArgumentType
{
    Flag = 1 << 0,
    File = 1 << 1,
    OnlyWithValueSperator = 1 << 2,
}

public class ParamCompleter(ArgumentType type)
{
    [Conditional("DEBUG")]
    private void Debug(string msg)
    {
        NativeCompleter.Messages.Add(msg);
    }

    public ArgumentType Type { get; } = type;

    /// <summary>
    /// One character parameter names.
    /// </summary>
    public char[] ShortNames { get; internal set; } = [];

    /// <summary>
    /// Long parameter names.
    /// </summary>
    public string[] LongNames { get; internal set; } = [];

    /// <summary>
    /// Old styles parameter names.
    /// </summary>
    public string[] OldShortNames { get; internal set; } = [];

    /// <summary>
    /// Parameter description.
    /// </summary>
    public string Description { get; set; } = string.Empty;

    /// <summary>
    /// Completer for the parameter's argument.
    /// </summary>
    public ScriptBlock? ArgumentCompleter { get; internal set; }

    public string[] Arguments { get; internal set; } = [];

    internal bool IsMatchLongParam(ReadOnlySpan<char> inputValue, out ReadOnlySpan<char> paramName)
    {
        foreach (ReadOnlySpan<char> name in LongNames)
        {
            if (name.Equals(inputValue, StringComparison.OrdinalIgnoreCase))
            {
                paramName = name;
                return true;
            }
        }
        paramName = default;
        return false;
    }
    internal bool IsMatchOldStyleParam(ReadOnlySpan<char> inputValue, out ReadOnlySpan<char> paramName)
    {
        foreach (ReadOnlySpan<char> name in OldShortNames)
        {
            if (name.Equals(inputValue, StringComparison.OrdinalIgnoreCase))
            {
                paramName = name;
                return true;
            }
        }
        paramName = default;
        return false;
    }
    internal bool IsMatchShortParam(ReadOnlySpan<char> inputValue, out char paramName, out int position)
    {
        foreach (char c in ShortNames)
        {
            position = inputValue.IndexOf(c);
            if (position < 0)
                continue;

            paramName = c;
            return true;
        }
        position = -1;
        paramName = default;
        return false;
    }

    /// <summary>
    /// Complete long parameters
    /// </summary>
    public IEnumerable<CompletionResult> CompleteLongParam(string paramName,
                                                           int position,
                                                           string indicator)
    {
        // Debug($"ParamCompleter.CompleteLongParam paramName: '{paramName}', position: {position}");
        if (LongNames.Length == 0)
        {
            return [];
        }
        var names = string.IsNullOrEmpty(paramName)
            ? LongNames
            : LongNames.Where(n => n.StartsWith(paramName, StringComparison.OrdinalIgnoreCase)).ToArray();

        if (names.Length == 0)
            return [];

        var desc = string.IsNullOrEmpty(Description) ? string.Empty : $" ({Description})";
        return names.Select(n => new CompletionResult($"{indicator}{n}",
                                                      $"{indicator}{n}{desc}",
                                                      CompletionResultType.ParameterValue,
                                                      $"[{indicator}{n}]{desc}"));
    }

    /// <summary>
    /// Complete old style parameters
    /// </summary>
    public IEnumerable<CompletionResult> CompleteOldParam(string paramName,
                                                          int position,
                                                          string indicator)
    {
        if (OldShortNames.Length == 0)
        {
            return [];
        }
        var desc = string.IsNullOrEmpty(Description) ? string.Empty : $" ({Description})";
        return OldShortNames.Where(name => string.IsNullOrEmpty(paramName)
                                           || name.StartsWith(paramName, StringComparison.OrdinalIgnoreCase))
                            .Select(name => new CompletionResult($"{indicator}{name}",
                                                                 $"{indicator}{name}({desc})",
                                                                 CompletionResultType.ParameterValue,
                                                                 $"[{indicator}{name}]{desc}"));
    }

    /// <summary>
    /// Complete short parameters
    /// </summary>
    public IEnumerable<CompletionResult> CompleteShortParam(string paramName,
                                                            int position,
                                                            string indicator)
    {
        if (ShortNames.Length == 0)
        {
            return [];
        }
        var paramName1 = paramName[..position];
        var paramName2 = paramName[position..];
        var desc = string.IsNullOrEmpty(Description) ? string.Empty : $" ({Description})";
        return ShortNames.Where(c => !paramName1.Contains(c))
                         .Select(c => new CompletionResult($"{indicator}{paramName1}{c}{paramName2}",
                                                           $"{indicator}{c}{desc}",
                                                           CompletionResultType.ParameterValue,
                                                           $"[{indicator}{c}]{desc}"));
    }

    /// <summary>
    /// Complete parameter's argument values
    /// </summary>
    public IEnumerable<CompletionResult> CompleteValue(string paramName,
                                                       string paramValue,
                                                       int position,
                                                       string indicator,
                                                       string prefix = "")
    {
        if (Arguments.Length > 0)
        {
            var values = string.IsNullOrEmpty(paramValue)
                ? Arguments
                : Arguments.Where(v => v.StartsWith(paramValue, StringComparison.OrdinalIgnoreCase));
            foreach (var value in values)
            {
                var text = $"{prefix}{value}";
                yield return new(text,
                                 text,
                                 CompletionResultType.ParameterValue,
                                 $"[{indicator}{paramName}] {value}");
            }
        }
        if (ArgumentCompleter is null)
            yield break;

        CompletionResult completionResult;
        foreach (var psobject in ArgumentCompleter.Invoke(paramValue, position))
        {
            if (LanguagePrimitives.TryConvertTo<CompletionResult>(psobject, out var result))
            {
                completionResult = new($"{prefix}{result.CompletionText}",
                                       $"{prefix}{result.ListItemText}",
                                       CompletionResultType.ParameterValue,
                                       $"[{indicator}{paramName}] {result.ToolTip}");

            }
            else
            {
                var text = $"{psobject}";
                completionResult = new($"{prefix}{text}",
                                       $"{prefix}{text}",
                                       CompletionResultType.ParameterValue,
                                       $"[{indicator}{paramName}] {text}");
            }
            yield return completionResult;
        }
    }
}
