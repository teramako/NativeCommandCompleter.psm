using System.Collections.ObjectModel;
using System.Diagnostics;
using System.Management.Automation;

namespace MT.Comp;

[Flags]
public enum ArgumentType
{
    /// <summary>
    /// Flag parameters that do not require argument values
    /// </summary>
    Flag = 0,

    /// <summary>
    /// like `nargs='?'`, e.g. `sed -i[.bk]`
    /// </summary>
    FlagOrValue = 1 << 0,

    /// <summary>
    /// Parameter for which argument values are required
    /// </summary>
    Required = 1 << 1,

    /// <summary>
    /// Parameter for which file or directory argument are required
    /// </summary>
    File = 1 << 2,

    /// <summary>
    /// Parameter for which directory argument are required
    /// </summary>
    Directory = 1 << 3,

    /// <summary>
    /// Parameters that require comma-separated value(s)
    /// </summary>
    List = 1 << 4,
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
        if (type > 0 && !type.HasFlag(ArgumentType.FlagOrValue))
        {
            type |= ArgumentType.Required;
        }
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
    /// <param name="context">Completion context</param>
    /// <param name="paramName">Parameter name</param>
    /// <param name="paramValue">Parameter value to be completed</param>
    /// <param name="position">Position of cursor in <paramref name="paramValue"/></param>.
    /// <param name="optionPrefix">
    /// <see cref="CommandCompleter.LongOptionPrefix"/> or <see cref="CommandCompleter.ShortOptionPrefix"/>
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
                              CompletionContext context,
                              ReadOnlySpan<char> paramName,
                              ReadOnlySpan<char> paramValue,
                              int position,
                              string optionPrefix,
                              string prefix = "")
    {
        string fullParamName = $"{optionPrefix}{paramName}";

        if (Type.HasFlag(ArgumentType.List))
        {
            Debug($"CompleteValue[List]: {{ name '{paramName}', value: '{paramValue}', position: {position}, prefx: '{prefix}' }}");
            var commaCount = paramValue.Count(',');
            if (commaCount > 0)
            {
                Span<Range> ranges = new Range[commaCount + 1];
                paramValue.Split(ranges, ',', StringSplitOptions.None);
                for (var i = 0; i <= commaCount; i++)
                {
                    var r = ranges[i];
                    if (position <= r.End.Value)
                    {
                        paramValue = paramValue[r];
                        position = position - r.Start.Value;
                        prefix = string.Empty;
                        break;
                    }
                }
            }
            Debug($"CompleteValue[List]: result = {{ name '{paramName}', value: '{paramValue}', position: {position}, prefx: '{prefix}' }}");
        }

        if (Arguments.Length > 0)
        {
            Debug($"CompleteValue[Arguments]: {{ name: '{paramName}', value: '{paramValue}', position: {position}  }}");

            foreach (ReadOnlySpan<char> value in Arguments)
            {
                var data = CompletionValue.Parse(value, null);
                if (data.IsMatch(paramValue, ignoreCase: true))
                {
                    results.Add(data.SetPrefix(prefix));
                    Debug($"Matched: '{data.CompletionText}', '{data.ListItemText}'");
                }
            }

            return true;
        }

        // | tokenValue  | WordToComplete | prefix | paramValue | Note
        // |:------------|:---------------|:-------|:-----------|:-------------------------------------------------
        // | `-f`        | `-f`           | `-f`   | ``         |
        // | `-f./`      | `./`           | `-f`   | `./`       | WordToComplete is set incorrectly
        // | `-fFoo.txt` | `.txt`         | `-f`   | `Foo.txt`  | WordToComplete is set incorrectly
        // | `-f'./'`    | `-f./`         | `-f`   | `'./'`     |
        //
        // Leading hyphen(`-`) and contains dot(`.`) value is splitted to two token, and words to be completed is set incorrectly.
        // See: https://github.com/PowerShell/PowerShell/issues/6291
        //
        // Quoting completion text for proper handling.
        bool shouldBeQuoted = !string.IsNullOrEmpty(prefix) && optionPrefix == "-";
        if (shouldBeQuoted && !context.WordToComplete.StartsWith('-'))
        {
            // As a workaround, fix to quoted value
            var cv = new CompletionValue($"{paramValue}", "Fix to quoted");
            cv.QuoteText();
            results.Add(cv);
            return true;
        }

        bool useFilenameCompletion = Type.HasFlag(ArgumentType.File)
                                     || Type.HasFlag(ArgumentType.Directory);

        if (ArgumentCompleter is null)
        {
            if (useFilenameCompletion)
            {
                Debug($"CompleteValue[Filename]: {{ name: '{paramName}', value: '{paramValue}', position: {position}, prefix: '{prefix}' }}");
                bool onlyDirectory = !Type.HasFlag(ArgumentType.File);
                try
                {
                    foreach (var result in Helper.CompleteFilename($"{paramValue}", context.CurrentDirectory.Path, true, onlyDirectory))
                    {
                        if (shouldBeQuoted)
                        {
                            result.QuoteText();
                        }
                        results.Add(result.SetPrefix(prefix));
                    }
                }
                catch (Exception e)
                {
                    Debug($"CompleteValue[Filename]: [{e.GetType().Name}] {e.Message} }}");
                }
            }
            return true;
        }

        Collection<PSObject?>? invokeResults = null;
        try
        {
            Debug($"[{Name}] Start Argument complete {{ '{paramName}', '{paramValue}', {position} }}");
            invokeResults = ArgumentCompleter.GetNewClosure()
                                             .InvokeWithContext(null,
                                                                [new("_", $"{paramValue}"), new("this", context)],
                                                                position);
            Debug($"[{Name}] ArgumentCompleter results {{ count = {invokeResults.Count} }}");
        }
        catch
        {
        }
        int completionCount = 0;
        if (invokeResults is not null && invokeResults.Count > 0)
        {
            foreach (var item in NativeCompleter.PSObjectsToCompletionData(invokeResults))
            {
                if (shouldBeQuoted)
                {
                    item.QuoteText();
                }
                results.Add(item.SetTooltipPrefix($"[{fullParamName}] ").SetPrefix(prefix));
                completionCount++;
            }
        }

        if (completionCount == 0 && !useFilenameCompletion)
        {
            // Prevent fallback to filename completion
            return true;
        }

        return false;
    }
}
