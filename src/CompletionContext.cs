using System.Collections.ObjectModel;
using System.Diagnostics;
using System.Management.Automation;
using System.Management.Automation.Language;

namespace MT.Comp;

internal record PendingParamCompleter(ParamCompleter Completer, string ParamName, string Indicator);

internal class CompletionContext
{
    [Conditional("DEBUG")]
    private void Debug(string msg)
    {
        NativeCompleter.Messages.Add($"[{Name}] {msg}");
    }

    public string Name { get; }
    public CommandCompleter CommandCompleter { get; }

    /// <summary>
    /// Arguments of the command that precedes the cursor position
    /// </summary>
    public ReadOnlyCollection<Token> Arguments => _arguments.AsReadOnly();
    /// <summary>
    /// Token at the cursor position
    /// </summary>
    public Token? CurrentToken { get; private set; }
    /// <summary>
    /// Arguments after the cursor position
    /// </summary>
    public ReadOnlyCollection<Token> RemainingArguments => _remainingArguments.AsReadOnly();

    /// <summary>
    /// Arguments before the cursor position that are not parameters and not the parameter's values
    /// </summary>
    public ReadOnlyCollection<Token> UnboundArguments => _unboundArguments.AsReadOnly();

    private List<Token> _arguments = [];
    private List<Token> _remainingArguments = [];
    private List<Token> _unboundArguments = [];

    private PendingParamCompleter? _pendingParam;
    // private (ParamCompleter? Completer, string ParamName, string Indicator) _pendingParam = (null, string.Empty, string.Empty);
    private CompletionContext? _parent = null;

    private CompletionContext(CommandCompleter commandCompleter)
    {
        Name = commandCompleter.Name;
        CommandCompleter = commandCompleter;
    }
    private CompletionContext(CommandCompleter commandCompleter, CompletionContext parentContext, int argumentIndex)
    {
        Name = $"{parentContext.Name}-{commandCompleter.Name}";
        CommandCompleter = commandCompleter;
        _parent = parentContext;
        if (argumentIndex < parentContext.Arguments.Count - 1)
        {
            _arguments = parentContext._arguments[(argumentIndex + 1)..];
        }
        _remainingArguments = parentContext._remainingArguments;
        CurrentToken = parentContext.CurrentToken;
    }

    public static CompletionContext Create(CommandCompleter commandCompleter, CommandAst ast, int cursorPosition)
    {
        CompletionContext context = new(commandCompleter);
        NativeCompleter.Messages.Add($"[{context.Name}] Create CompletionContext");
        for (var i = 1; i < ast.CommandElements.Count; i++)
        {
            var elm = ast.CommandElements[i];
            if (elm.Extent.EndOffset < cursorPosition)
            {
                context._arguments.Add(new Token(elm));
            }
            else if (elm.Extent.StartOffset <= cursorPosition && cursorPosition <= elm.Extent.EndOffset)
            {
                context.CurrentToken = new Token(elm, cursorPosition);
            }
            else
            {
                context._remainingArguments.Add(new Token(elm));
            }
        }
        return context.Build();
    }

    private CompletionContext Build()
    {
        NativeCompleter.Messages.Add($"[{Name}] Build CompletionContext");
        int argumentsCount = Arguments.Count;
        for (int argumentIndex = 0; argumentIndex < argumentsCount; argumentIndex++)
        {
            Token token = Arguments[argumentIndex];
            ReadOnlySpan<char> tokenValue = token.Value;
            string indicator;
            if (tokenValue.StartsWith(CommandCompleter.LongParamIndicator, StringComparison.Ordinal))
            {
                indicator = CommandCompleter.LongParamIndicator;
                var paramName = tokenValue[indicator.Length..];
                if (!paramName.Contains(CommandCompleter.ValueSeparator))
                {
                    foreach (var param in CommandCompleter.Params)
                    {
                        if (param.IsMatchLongParam(paramName, out var outParamName))
                        {
                            if (param.Type.HasFlag(ArgumentType.Flag))
                            {
                                break;
                            }
                            else if (argumentIndex < argumentsCount - 1)
                            {
                                argumentIndex++;
                                break;
                            }
                            else
                            {
                                Debug($"Set pending: {tokenValue}");
                                _pendingParam = new(param, $"{outParamName}", indicator);
                            }
                            break;
                        }
                    }
                }
            }
            else if (tokenValue.StartsWith(CommandCompleter.ParamIndicator, StringComparison.Ordinal))
            {
                indicator = CommandCompleter.ParamIndicator;
                var paramName = tokenValue[indicator.Length..];
                foreach (var param in CommandCompleter.Params)
                {
                    if (param.IsMatchOldStyleParam(paramName, out var outParamName))
                    {
                        if (param.Type.HasFlag(ArgumentType.Flag))
                        {
                            break;
                        }
                        else if (argumentIndex < argumentsCount - 1)
                        {
                            argumentIndex++;
                            break;
                        }
                        else
                        {
                            _pendingParam = new(param, $"{outParamName}", indicator);
                        }
                        break;
                    }
                    if (param.IsMatchShortParam(paramName, out char paramChar, out int position))
                    {
                        var key = $"{indicator}{paramChar}";
                        if (param.Type.HasFlag(ArgumentType.Flag))
                        {
                            break;
                        }
                        else if (position == paramName.Length - 1) // paramName[^1] == paramChar
                        {
                            if (argumentIndex < argumentsCount - 1)
                            {
                                argumentIndex++;
                            }
                            else
                            {
                                _pendingParam = new(param, $"{paramChar}", indicator);
                            }
                        }
                        break;
                    }
                }
            }
            else if (CommandCompleter.SubCommands.Count > 0)
            {
                if (CommandCompleter.SubCommands.TryGetValue($"{tokenValue}", out var subCmd))
                {
                    var subContext = new CompletionContext(subCmd, this, argumentIndex);
                    return subContext.Build();
                }

                _unboundArguments.Add(token);
            }
            else
            {
                _unboundArguments.Add(token);
            }
        }
        return this;
    }

    public IEnumerable<CompletionResult> Complete()
    {
        NativeCompleter.Messages.Add($"[{Name}] Start Complete");

        string tokenValue = CurrentToken?.Value ?? string.Empty;
        int cursorPosition = CurrentToken?.Position ?? 0;

        if (_pendingParam is not null)
        {
            NativeCompleter.Messages.Add($"[{Name}] Complete parameter arguments: {_pendingParam.ParamName}");
            return _pendingParam.Completer.CompleteValue(_pendingParam.ParamName,
                                                         tokenValue,
                                                         cursorPosition,
                                                         _pendingParam.Indicator);
        }

        if (CurrentToken is not null)
        {
            if (tokenValue.StartsWith(CommandCompleter.LongParamIndicator, StringComparison.Ordinal))
            {
                NativeCompleter.Messages.Add($"Start complete long params: '{tokenValue}', {cursorPosition}");
                return CompleteLongParams(tokenValue, cursorPosition);
            }
            else if (tokenValue.StartsWith(CommandCompleter.ParamIndicator, StringComparison.Ordinal))
            {
                return CompleteOldOrShortParams(tokenValue, cursorPosition);
            }
            else if (CommandCompleter.SubCommands.Count > 0 && _unboundArguments.Count == 0)
            {
                return CompleteSubCommands(tokenValue, cursorPosition);
            }

            return CompleteArgument(tokenValue, cursorPosition);
        }

        if (CommandCompleter.SubCommands.Count > 0 && _unboundArguments.Count == 0)
        {
            return CompleteSubCommands(tokenValue, cursorPosition);
        }

        return CompleteArgument(tokenValue, cursorPosition);
    }

    private IEnumerable<CompletionResult> CompleteSubCommands(string tokenValue, int cursorPosition)
    {
        var subCommands = string.IsNullOrEmpty(tokenValue)
            ? CommandCompleter.SubCommands
            : CommandCompleter.SubCommands.Where(kv => kv.Key.StartsWith(tokenValue, StringComparison.OrdinalIgnoreCase));

        return subCommands.Select(kv => new CompletionResult(kv.Value.Name,
                                                             $"{kv.Value.Name} - ({kv.Value.Description})",
                                                             CompletionResultType.Command,
                                                             $"{CommandCompleter.Name} {kv.Value.Name} - ({kv.Value.Description})"));
    }

    private IEnumerable<CompletionResult> CompleteArgument(string tokenValue, int cursorPosition)
    {
        if (CommandCompleter.ArgumentCompleter is null)
            return [];

        var argIndex = _unboundArguments.Count;
        NativeCompleter.Messages.Add($"=> CompleterArgument: {tokenValue}, {cursorPosition}, {argIndex}");
        return NativeCompleter.PSObjectsToCompletionResults(
                CommandCompleter.ArgumentCompleter.Invoke(tokenValue, cursorPosition, argIndex));
    }

    private IEnumerable<CompletionResult> CompleteLongParams(ReadOnlySpan<char> tokenValue, int cursorPosition)
    {
        const StringComparison comparison = StringComparison.OrdinalIgnoreCase;
        string indicator = CommandCompleter.LongParamIndicator;
        ReadOnlySpan<char> paramName = tokenValue[indicator.Length..];
        string sParamName;
        int position;
        int separatorPosition = tokenValue.IndexOf(CommandCompleter.ValueSeparator);
        if (separatorPosition > 0 && separatorPosition < cursorPosition)
        {
            sParamName = $"{tokenValue[indicator.Length..separatorPosition]}";
            var completer = CommandCompleter.Params.FirstOrDefault(p => p.LongNames.Any(n => n.Equals(sParamName, comparison)));
            if (completer is not null)
            {
                var sParamValue = $"{tokenValue[(separatorPosition + 1)..]}";
                position = separatorPosition - cursorPosition;
                return completer.CompleteValue(sParamName,
                                               sParamValue,
                                               position,
                                               indicator,
                                               $"{tokenValue[..(separatorPosition + 1)]}");
            }
            return [];
        }
        sParamName = $"{tokenValue[indicator.Length..cursorPosition]}";
        position = cursorPosition - indicator.Length;
        var paramCompleters = string.IsNullOrEmpty(sParamName)
            ? CommandCompleter.Params.Where(p => p.LongNames.Length > 0)
            : CommandCompleter.Params.Where(p => p.LongNames.Any(n => n.StartsWith(sParamName, comparison)));
        return paramCompleters.SelectMany(p => p.CompleteLongParam(sParamName, position, indicator));
    }

    private IEnumerable<CompletionResult> CompleteOldOrShortParams(string tokenValue, int cursorPosition)
    {
        var indicator = CommandCompleter.ParamIndicator;
        var paramName = tokenValue[indicator.Length..];
        cursorPosition -= indicator.Length;
        foreach (var result in CommandCompleter.Params.Where(p => p.OldShortNames.Length > 0)
                                                      .SelectMany(p => p.CompleteOldParam(paramName, cursorPosition, indicator)))
        {
            yield return result;
        }

        Collection<ParamCompleter> avairableParams = new();
        foreach (var param in CommandCompleter.Params.Where(p => p.ShortNames.Length > 0))
        {
            if (param.IsMatchShortParam(paramName, out char paramChar, out int position))
            {
                var key = $"{indicator}{paramChar}";
                if (param.Type.HasFlag(ArgumentType.Flag))
                {
                    continue;
                }
                else
                {
                    var paramValue = paramName[(position + 1)..];
                    paramName = paramName[..(position + 1)];
                    cursorPosition -= position + 1;
                    foreach (var result in param.CompleteValue($"{paramChar}", paramValue, cursorPosition, indicator, $"{indicator}{paramName}"))
                    {
                        yield return result;
                    }
                    yield break;
                }
            }
            else
            {
                avairableParams.Add(param);
            }
        }
        foreach (var result in avairableParams.SelectMany(p => p.CompleteShortParam(paramName, cursorPosition, indicator)))
        {
            yield return result;
        }
    }
}
