using System.Collections.ObjectModel;
using System.Diagnostics.CodeAnalysis;
using System.Management.Automation;
using System.Text;

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
    /// <summary>
    /// Initialize a new instance of ParamCompleter class
    /// </summary>
    /// <param name="type"></param>
    /// <param name="longNames"></param>
    /// <param name="standardNames"></param>
    /// <param name="shortNames"></param>
    /// <param name="variableName"></param>
    /// <param name="style"></param>
    /// <exception cref="ArgumentException"></exception>
    public ParamCompleter(ArgumentType type,
                          string[] longNames,
                          string[] standardNames,
                          char[] shortNames,
                          string variableName = "Val",
                          ParameterStyle? style = null)
    {
        Id = longNames.Union(standardNames).Union(shortNames.Select(c => $"{c}")).First()
            ?? throw new ArgumentException("At least one of 'ShortName', 'OldStyleName' or 'LongName' must be specified");
        if (type > 0 && !type.HasFlag(ArgumentType.FlagOrValue))
        {
            type |= ArgumentType.Required;
        }
        Type = type;
        LongNames = longNames;
        StandardNames = standardNames;
        ShortNames = shortNames;
        VariableName = type > 0 ? variableName : string.Empty;
        if (style is not null)
        {
            _style = style;
        }
    }

    public string Id { get; }

    public ArgumentType Type { get; }

    /// <summary>
    /// One character parameter names.
    /// </summary>
    /// <remarks>
    /// e.g)
    /// <list type="bullet">
    ///     <item><c>-a</c></item>
    ///     <item><c>-v</c></item>
    /// </list>
    /// </remarks>
    public char[] ShortNames { get; internal set; }

    /// <summary>
    /// Standard parameter names.
    /// </summary>
    /// <remarks>
    /// e.g)
    /// <list type="bullet">
    ///     <item><c>-name</c></item>
    ///     <item><c>/recursive</c></item>
    /// </list>
    /// </remarks>
    public string[] StandardNames { get; internal set; }

    /// <summary>
    /// Long parameter names.
    /// </summary>
    /// <remarks>
    /// e.g)
    /// <list type="bullet">
    ///     <item><c>--all</c></item>
    ///     <item><c>--verbose</c></item>
    /// </list>
    /// </remarks>
    public string[] LongNames { get; internal set; }

    /// <summary>
    /// Parameter description.
    /// </summary>
    public string Description { get; set; } = string.Empty;

    /// <summary>
    /// Completer for the parameter's argument.
    /// </summary>
    public ScriptBlock? ArgumentCompleter { get; internal set; }

    public string[] Arguments { get; internal set; } = [];

    public string VariableName { get; set; }

    private ParameterStyle? _style;
    public ParameterStyle Style
    {
        get {
            _style ??= ParameterStyle.GNU;
            return _style;
        }
        set
        {
            _style ??= value;
        }
    }

    public string GetSyntaxes(string delimiter = ", ", bool expandArguments = false)
    {
        ParameterStyle style = Style;
        StringBuilder sb = new();
        int count = 0;

        foreach (var c in ShortNames)
        {
            if (count > 0)
                sb.Append(delimiter);
            PrintSyntax(sb, $"{style.ShortOptionPrefix}{c}", true);
            count++;
        }

        foreach (var name in StandardNames)
        {
            if (count > 0)
                sb.Append(delimiter);
            PrintSyntax(sb, $"{style.ShortOptionPrefix}{name}", false);
            count++;
        }

        foreach (var name in LongNames)
        {
            if (count > 0)
                sb.Append(delimiter);
            PrintSyntax(sb, $"{style.LongOptionPrefix}{name}", false);
            count++;
        }

        if (expandArguments)
            PrintArgumentValues(sb);
        return sb.ToString();
    }

    public string GetSyntax(string name, bool isShortParam = false, bool expandArguments = false)
    {
        StringBuilder sb = new();
        PrintSyntax(sb, name, isShortParam);
        if (expandArguments)
            PrintArgumentValues(sb);
        return sb.ToString();
    }
    private void PrintSyntax(StringBuilder sb, string name, bool isShortParam = false)
    {
        sb.Append(name);
        if (Type == ArgumentType.Flag)
            return;
        bool optional = Type.HasFlag(ArgumentType.FlagOrValue);
        char valueSeparator = optional
            ? Style.ValueSeparator
            : Style.ValueStyle.HasFlag(ParameterValueStyle.Adjacent) ? Style.ValueSeparator : ' ';

        if (optional)
        {
            if (isShortParam)
                sb.Append('[');
            else if (char.IsWhiteSpace(valueSeparator))
                sb.Append(" [");
            else if (valueSeparator > 0)
                sb.Append($"[{valueSeparator}");
        }
        else
        {
            sb.Append(!isShortParam && valueSeparator > 0 ? valueSeparator : ' ');
        }
        sb.Append(VariableName);
        if (Type.HasFlag(ArgumentType.List))
        {
            sb.Append("[,…]");
        }

        if (optional)
            sb.Append(']');
    }
    private void PrintArgumentValues(StringBuilder sb)
    {
        if (Arguments.Length > 0)
        {
            sb.Append($" ({VariableName}={{");
            for (var i = 0; i < Arguments.Length; i++)
            {
                if (i > 0)
                    sb.Append('|');
                var p = Arguments[i].IndexOfAny(['\t', '\n', '\r']);
                var text = p > 0 ? Arguments[i].AsSpan(0, p) : Arguments[i];
                sb.Append(text.Trim());
            }
            sb.Append("})");
        }
    }

    /// <summary>
    /// Parse parameter from input value
    /// </summary>
    /// <param name="inputValue">A command argument which may contains option prefix and adjacented value with a value separator.</param>
    /// <param name="paramName"></param>
    /// <param name="paramValue"></param>
    /// <param name="optionPrefix"></param>
    /// <returns></returns>
    public bool ParseParam(ReadOnlySpan<char> inputValue,
                           out ReadOnlySpan<char> paramName,
                           out ReadOnlySpan<char> paramValue,
                           [MaybeNullWhen(false)] out string optionPrefix)
    {
        ParameterStyle style = Style;
        optionPrefix = style.LongOptionPrefix;
        if (inputValue.StartsWith(optionPrefix, StringComparison.OrdinalIgnoreCase))
        {
            var nameSpan = inputValue[optionPrefix.Length..];
            if (ParseLongParam(nameSpan, out paramName, out paramValue))
                return true;
        }

        optionPrefix = style.ShortOptionPrefix;
        if (inputValue.StartsWith(optionPrefix, StringComparison.OrdinalIgnoreCase))
        {
            var nameSpan = inputValue[optionPrefix.Length..];
            if (ParseStandardParam(nameSpan, out paramName, out paramValue))
                return true;
        }

        paramName = default;
        paramValue = default;
        optionPrefix = null;
        return false;
    }
    internal bool ParseLongParam(ReadOnlySpan<char> inputValue,
                                 out ReadOnlySpan<char> paramName,
                                 out ReadOnlySpan<char> paramValue)
    {
        ParameterStyle style = Style;
        if ((Type != ArgumentType.Flag && style.ValueStyle.HasFlag(ParameterValueStyle.Adjacent))
            || Type.HasFlag(ArgumentType.FlagOrValue))
        {
            var separatorPosition = inputValue.IndexOf(style.ValueSeparator);
            if (separatorPosition >= 0)
            {
                ReadOnlySpan<char> nameSpan = inputValue[..separatorPosition];
                if (IsMatchLongParam(nameSpan, out paramName))
                {
                    paramValue = inputValue[(separatorPosition + 1)..];
                    return true;
                }
                paramValue = default;
                return false;
            }
            else if (!style.ValueStyle.HasFlag(ParameterValueStyle.Separated))
            {
                // No separate value allowed
                paramName = default;
                paramValue = default;
                return false;
            }
        }
        paramValue = default;
        if (IsMatchLongParam(inputValue, out paramName))
        {
            return true;
        }
        paramName = default;
        return false;
    }
    internal bool ParseStandardParam(ReadOnlySpan<char> inputValue,
                                     out ReadOnlySpan<char> paramName,
                                     out ReadOnlySpan<char> paramValue)
    {
        ParameterStyle style = Style;
        if ((Type != ArgumentType.Flag && style.ValueStyle.HasFlag(ParameterValueStyle.Adjacent))
            || Type.HasFlag(ArgumentType.FlagOrValue))
        {
            var separatorPosition = inputValue.IndexOf(style.ValueSeparator);
            if (separatorPosition >= 0)
            {
                ReadOnlySpan<char> nameSpan = inputValue[..separatorPosition];
                if (IsMatchStandardParam(nameSpan, out paramName))
                {
                    paramValue = inputValue[(separatorPosition + 1)..];
                    return true;
                }
                paramValue = default;
                return false;
            }
            else if (!style.ValueStyle.HasFlag(ParameterValueStyle.Separated))
            {
                // No separate value allowed
                paramName = default;
                paramValue = default;
                return false;
            }
        }
        paramValue = default;
        if (IsMatchStandardParam(inputValue, out paramName))
        {
            return true;
        }
        paramName = default;
        return false;
    }
    private bool IsMatchLongParam(ReadOnlySpan<char> inputValue, out ReadOnlySpan<char> paramName)
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
    private bool IsMatchStandardParam(ReadOnlySpan<char> inputValue, out ReadOnlySpan<char> paramName)
    {
        foreach (ReadOnlySpan<char> name in StandardNames)
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

    internal string GetParamNameSuffix()
    {
        if (Type is ArgumentType.Flag)
            return " ";
        if (Type.HasFlag(ArgumentType.FlagOrValue))
        {
            return string.Empty;
        }
        return Style.ValueStyle switch
        {
            ParameterValueStyle.Separated => " ",
            ParameterValueStyle.Adjacent => $"{Style.ValueSeparator}",
            ParameterValueStyle.Both or _=> string.Empty,
        };
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
        if (Type.HasFlag(ArgumentType.List))
        {
            NativeCompleter.Debug($"[{context.Name}] CompleteValue[List]: {{ name '{paramName}', value: '{paramValue}', position: {position}, prefx: '{prefix}' }}");
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
            NativeCompleter.Debug($"  CompleteValue[List]: result = {{ name '{paramName}', value: '{paramValue}', position: {position}, prefx: '{prefix}' }}");
        }

        var tooltipPrefix = $"""
            {GetSyntaxes(expandArguments: false)} : {Description}
            {VariableName}: 
            """;

        if (Arguments.Length > 0)
        {
            NativeCompleter.Debug($"[{context.Name}] CompleteValue[Arguments]: {{ name: '{paramName}', value: '{paramValue}', position: {position}  }}");

            foreach (ReadOnlySpan<char> value in Arguments)
            {
                var data = CompletionValue.Parse(value, null);
                if (data.IsMatch(paramValue, ignoreCase: true))
                {
                    results.Add(data.SetTooltipPrefix(tooltipPrefix).SetPrefix(prefix));
                    NativeCompleter.Debug($"  Matched: '{prefix}{data.Text}', '{data.ListItemText}'");
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
                NativeCompleter.Debug($"[{context.Name}] CompleteValue[Filename]: {{ name: '{paramName}', value: '{paramValue}', position: {position}, prefix: '{prefix}' }}");
                bool onlyDirectory = !Type.HasFlag(ArgumentType.File);
                try
                {
                    foreach (var result in Helper.CompleteFilename($"{paramValue}", context.CurrentDirectory.Path, true, onlyDirectory))
                    {
                        if (shouldBeQuoted)
                        {
                            result.QuoteText();
                        }
                        results.Add(result.SetPrefix(prefix).SetTooltipPrefix(tooltipPrefix));
                    }
                }
                catch (Exception e)
                {
                    NativeCompleter.Debug($"  CompleteValue[Filename]: [{e.GetType().Name}] {e.Message} }}");
                }
            }
            return true;
        }

        Collection<PSObject?>? invokeResults = null;
        try
        {
            NativeCompleter.Debug($"[{context.Name}] Start Argument complete {{ '{paramName}', '{paramValue}', {position} }}");
            invokeResults = ArgumentCompleter.GetNewClosure()
                                             .InvokeWithContext(null,
                                                                [new("_", $"{paramValue}"), new("this", context)],
                                                                position);
            NativeCompleter.Debug($"[{context.Name}] ArgumentCompleter results {{ count = {invokeResults.Count} }}");
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
                results.Add(item.SetTooltipPrefix(tooltipPrefix).SetPrefix(prefix));
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
