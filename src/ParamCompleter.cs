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

public class ParamCompleter(ArgumentType type,
                            string longParamIndicator = "--",
                            string paramIndicator = "-",
                            char valueSeparator = '=')
{
    [Conditional("DEBUG")]
    private void Debug(string msg)
    {
        NativeCompleter.Messages.Add(msg);
    }

    public ArgumentType Type { get; } = type;
    /// <summary>
    /// Parameter prefix indicator for long parameter names.
    /// <para>
    /// example) <c>--</c>
    /// </para>
    /// </summary>
    private string LongParamIndicator = longParamIndicator;

    /// <summary>
    /// Parameter prefix indicator for short or old style parameter names
    /// <para>
    /// example) <c>-</c>, <c>/</c>
    /// </para>
    /// </summary>
    private string ParamIndicator = paramIndicator;

    /// <summary>
    /// Parameter prefix indicator for long parameter names
    /// <para>
    /// example) <c>=</c>, <c>:</c>
    /// </para>
    /// </summary>
    private char ValueSeparator = valueSeparator;

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

    /// <summary>
    /// Complete long parameters
    /// </summary>
    public IEnumerable<CompletionResult> CompleteLongParam(string paramName, int position)
    {
        Debug($"ParamCompleter.CompleteLongParam paramName: '{paramName}', position: {position}");
        if (LongNames.Length == 0)
        {
            return [];
        }
        var valueSepPosition = paramName.IndexOf(ValueSeparator);
        if (valueSepPosition > 0)
        {
            Debug($"param: '{paramName}'");
            var newParamName = paramName[..valueSepPosition];
            return CompleteValue(newParamName,
                                 paramName[(valueSepPosition + 1)..],
                                 position - valueSepPosition - 1,
                                 LongParamIndicator,
                                 $"{LongParamIndicator}{newParamName}=");
        }

        return LongNames.Where(longName => string.IsNullOrEmpty(paramName)
                                           || longName.StartsWith(paramName, StringComparison.Ordinal))
                        .Select(longName => new CompletionResult($"--{longName}",
                                                                 $"--{longName} ({Description})",
                                                                 CompletionResultType.ParameterValue,
                                                                 $"[--{longName}] - {Description}"));

    }

    /// <summary>
    /// Complete old style parameters
    /// </summary>
    public IEnumerable<CompletionResult> CompleteOldParam(string paramName, int position)
    {
        if (OldShortNames is null or { Length: 0 })
        {
            return [];
        }
        return OldShortNames.Where(name => string.IsNullOrEmpty(paramName)
                                           || name.StartsWith(paramName, StringComparison.Ordinal))
                            .Select(name => new CompletionResult($"-{name}",
                                                                 $"-{name} ({Description})",
                                                                 CompletionResultType.ParameterValue,
                                                                 $"[-{name}] - {Description}"));
    }

    /// <summary>
    /// Complete short parameters
    /// </summary>
    public IEnumerable<CompletionResult> CompleteShortParam(string paramName, int position)
    {
        if (ShortNames is null or { Length: 0 })
        {
            return [];
        }
        return ShortNames.Where(c => !paramName.Contains(c))
                         .Select(c => new CompletionResult($"-{paramName[..position]}{c}{paramName[position..]}",
                                                           $"-{c} ({Description})",
                                                           CompletionResultType.ParameterValue,
                                                           $"[-{c}] - {Description}"));
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
        foreach (var psobject in ArgumentCompleter.Invoke(paramName, paramValue, position))
        {
            if (LanguagePrimitives.TryConvertTo<CompletionResult>(psobject, out var result))
            {
                Debug($"Convert {{ '{result.CompletionText}', '{result.ListItemText}' }} => {{ '{prefix}{result.CompletionText}', '[{paramIndicator}{paramName}] {result.ListItemText}' }}");
                completionResult = new($"{prefix}{result.CompletionText}",
                                       result.ListItemText,
                                       CompletionResultType.ParameterValue,
                                       $"[{paramIndicator}{paramName}] {result.ToolTip}");

            }
            else
            {
                var text = $"{psobject}";
                Debug($"Convert '{text}' => {{ '{prefix}{text}', '[{paramIndicator}{paramName}] {text}' }}");
                completionResult = new($"{prefix}{text}",
                                       text,
                                       CompletionResultType.ParameterValue,
                                       $"[{paramIndicator}{paramName}] {text}");
            }
            yield return completionResult;
        }

    }
}
