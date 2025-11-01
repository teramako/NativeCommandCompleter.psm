using System.Collections.ObjectModel;
using System.Diagnostics;
using System.Management.Automation;

namespace MT.Comp;

[Flags]
public enum ArgumentType
{
    Flag = 1 << 0,
    Required = 1 << 1,
    File = 1 << 2,
    OnlyWithValueSperator = 1 << 3,
}

public class ParamCompleter
{
    [Conditional("DEBUG")]
    private void Debug(string msg)
    {
        NativeCompleter.Messages.Add(msg);
    }

    public ParamCompleter(ArgumentType type, string[] longNames, string[] oldStyleNames, char[] shortNames)
    {
        Name = longNames.Union(oldStyleNames).Union(shortNames.Select(c => $"{c}")).First()
            ?? throw new ArgumentException("At least one of 'ShortName', 'OldStyleName' or 'LongName' must be specified");
        Type = type;
        LongNames = longNames;
        OldStyleNames = oldStyleNames;
        ShortNames = shortNames;
    }

    public string Name { get; }

    public ArgumentType Type { get; }

    /// <summary>
    /// One character parameter names.
    /// </summary>
    public char[] ShortNames { get; internal set; }

    /// <summary>
    /// Long parameter names.
    /// </summary>
    public string[] LongNames { get; internal set; }

    /// <summary>
    /// Old styles parameter names.
    /// </summary>
    public string[] OldStyleNames { get; internal set; }

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
        foreach (ReadOnlySpan<char> name in OldStyleNames)
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
    /// Complete parameter's argument values
    /// </summary>
    /// <param name="results">Completion result data to be stored</param>
    /// <param name="paramName">Parameter name</param>
    /// <param name="paramValue">Parameter value to be completed</param>
    /// <param name="position">Position of cursor in <paramref name="paramValue"/></param>.
    /// <param name="indicator">
    /// <see cref="CommandCompleter.LongParamIndicator"/> or <see cref="CommandCompleter.ParamIndicator"/>
    /// </param>
    /// <param name="prefix">Prefix string of <paramref name="paramValue"/>.
    /// <para>
    /// e.g.)
    /// <code>"--param-name="</code>
    /// </para>
    /// </param>
    /// <returns>
    /// <see langword="true"/> if completion is end (prevent fallback to filename completion); otherwise, <see langword="false"/>.
    /// </returns>
    public bool CompleteValue(ICollection<CompletionData> results,
                              ReadOnlySpan<char> paramName,
                              ReadOnlySpan<char> paramValue,
                              int position,
                              string indicator,
                              string prefix = "")
    {
        string fullParamName = $"{indicator}{paramName}";

        if (Arguments.Length > 0)
        {
            Debug($"CompleteValue[Arguments]: {{ name: '{paramName}', value: '{paramValue}', position: {position}  }}");

            foreach (ReadOnlySpan<char> value in Arguments)
            {
                var data = CompletionValue.Parse(value, null);
                if (data.IsMatch(paramValue))
                {
                    results.Add(data.SetPrefix(prefix));
                    Debug($"Matched: '{data.CompletionText}', '{data.ListItemText}'");
                }
            }

            return true;
        }

        bool canFallbackToFilenameCompletion = Type.HasFlag(ArgumentType.File);

        if (ArgumentCompleter is null)
        {
            if (canFallbackToFilenameCompletion)
            {
                foreach (var result in CompletionCompleters.CompleteFilename($"{paramValue}"))
                {
                    results.Add(CompletionValue.FromCommpletionResult(result, prefix));
                }
            }
            return !canFallbackToFilenameCompletion;
        }

        Collection<PSObject?>? invokeResults = null;
        try
        {
            Debug($"[{Name}] Start Argument complete {{ '{paramName}', '{paramValue}', {position} }}");
            invokeResults = ArgumentCompleter.Invoke($"{paramValue}", position);
            Debug($"[{Name}] ArgumentCompleter results {{ count = {invokeResults.Count} }}");
        }
        catch
        {
        }
        if (invokeResults is not null && invokeResults.Count > 0)
        {
            foreach (var item in NativeCompleter.PSObjectsToCompletionData(invokeResults))
            {
                results.Add(item.SetTooltipPrefix($"[{fullParamName}] ").SetPrefix(prefix));
            }
        }

        if (results.Count == 0 && !canFallbackToFilenameCompletion)
        {
            // Prevent fallback to filename completion
            return true;
        }

        return false;
    }
}
