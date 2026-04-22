using System.Diagnostics.CodeAnalysis;
using System.Text;

namespace MT.Comp;

public enum ParameterType
{
    /// <summary>
    /// Flag parameters that do not require argument values
    /// </summary>
    Flag,

    /// <summary>
    /// like `nargs='?'`, e.g. `sed -i[.bk]`
    /// </summary>
    FlagOrValue,

    /// <summary>
    /// Parameter for which argument values are required
    /// </summary>
    Required
}

public enum ArgumentType
{
    /// <summary>
    /// Default (not specified)
    /// </summary>
    Any = 0,

    /// <summary>
    /// Indicates that the argument is a file or directory path
    /// </summary>
    File = 1 << 2,

    /// <summary>
    /// Indicates that the argument is a directory path
    /// </summary>
    Directory = 1 << 3,
}

public class ParamCompleter
{
    /// <summary>
    /// Initialize a new instance of ParamCompleter class
    /// </summary>
    /// <param name="standardNames"></param>
    /// <param name="longNames"></param>
    /// <param name="shortNames"></param>
    /// <param name="arguments"></param>
    /// <param name="style"></param>
    /// <exception cref="ArgumentException"></exception>
    public ParamCompleter(string[] standardNames,
                          string[] longNames,
                          char[] shortNames,
                          ArgumentCompleterCollection arguments,
                          ParameterStyle? style = null)
    {
        Id = longNames.Union(standardNames).Union(shortNames.Select(c => $"{c}")).First()
            ?? throw new ArgumentException("At least one of 'StandardName', 'LongName', or 'ShortName' must be specified");
        Type = arguments.Count == 0
            ? ParameterType.Flag
            : arguments.Nargs.MinCount == 0
            ? ParameterType.FlagOrValue
            : ParameterType.Required;
        LongNames = longNames;
        StandardNames = standardNames;
        ShortNames = shortNames;
        Arguments = arguments;
        Style = style;
    }

    public string Id { get; }

    /// <summary>
    /// Parameter type.
    /// Indicates whether arguments are required
    /// </summary>
    public ParameterType Type { get; }

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
    /// Represents a constraint on the number of argument values accepted by a parameter.
    /// </summary>
    /// <remarks>
    /// This is alias to <see cref="ArgumentCompleterCollection.Nargs"/>
    /// </remarks>
    public Nargs Nargs => Arguments.Nargs;

    /// <summary>
    /// Completer for the parameter's argument.
    /// </summary>
    public ArgumentCompleterCollection Arguments { get; }

    /// <summary>
    /// Parameter style definition
    /// </summary>
    [AllowNull]
    public ParameterStyle Style
    {
        get;
        set => field = value ?? ParameterStyle.GNU;
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
        if (Type is ParameterType.Flag)
            return;
        bool optional = Type is ParameterType.FlagOrValue;
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
        Arguments.PrintSyntax(sb);

        if (optional)
            sb.Append(']');
    }
    private void PrintArgumentValues(StringBuilder sb, int argumentIndex = 0)
    {
        var ac = Arguments.GetByArgumentIndex(argumentIndex);
        if (ac is ArgumentCompleterWithCandidates acList)
        {
            sb.Append($" {acList.Name}={{")
              .AppendJoin('|', acList.Candidates.Select(item => item.Text.Trim()))
              .Append('}');
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
        if ((Type is not ParameterType.Flag && style.ValueStyle.HasFlag(ParameterValueStyle.Adjacent))
            || Type is ParameterType.FlagOrValue)
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
        if ((Type is not ParameterType.Flag && style.ValueStyle.HasFlag(ParameterValueStyle.Adjacent))
            || Type is ParameterType.FlagOrValue)
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
        if (Type is ParameterType.Flag)
            return " ";
        if (Type is ParameterType.FlagOrValue)
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
    /// <param name="paramArgs">Other parameter arguments</param>.
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
                              string[] paramArgs,
                              int position,
                              string optionPrefix,
                              string prefix = "")
    {
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

        int argumentIndex = paramArgs.Length;
        var ac = Arguments.GetByArgumentIndex(argumentIndex);
        if (ac is null)
            return true;

        var tooltipPrefix = $"""
            {GetSyntaxes(expandArguments: false)} : {Description}
            {(paramArgs.Length > 1 ? $"[{argumentIndex + 1}]" : "")}{ac.Name}:
            """;

        NativeCompleter.Debug($"[{context.Name}] Start Completion: {{ name '{paramName}', value: '{paramValue}', position: {position}, prefx: '{prefix}' }}");
        IEnumerable<CompletionData> candidates;
        if (ac.List)
        {
            var result = Helper.ResolveListElement(paramValue, position);
            if (result.Index > 0)
            {
                prefix = string.Empty;
            }
            NativeCompleter.Debug($"[{context.Name}] CompleteValue[List]: {{ name '{paramName}', value: '{result.Slice(paramValue)}', position: {result.Range.Start}, prefix: '{prefix}' }}");
            candidates = ac.Complete(context, result.Slice(paramValue), result.OffsetPosition, argumentIndex);
        }
        else
        {
            NativeCompleter.Debug($"[{context.Name}] CompleteValue: {{ name '{paramName}', value: '{paramValue}', position: {position}, prefx: '{prefix}' }}");
            candidates = ac.Complete(context, paramValue, position, argumentIndex);
        }

        int count = 0;
        foreach (var data in candidates)
        {
            results.Add(data.SetTooltipPrefix(tooltipPrefix).SetPrefix(prefix));
            NativeCompleter.Debug($"  Matched: '{prefix}{data.Text}', '{data.ListItemText}'");
            count++;
        }
        NativeCompleter.Debug($"  ArgumentCompleter results {{ count = {count} }}");
        return true;
    }
}
