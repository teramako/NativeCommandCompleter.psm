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

    /// <summary>
    /// Dictionary parsed parameters to parameters and their value
    /// </summary>
    public ReadOnlyDictionary<string, List<PSObject?>> BoundParameters => _boundParameters.AsReadOnly();

    private List<Token> _arguments = [];
    private List<Token> _remainingArguments = [];
    private List<Token> _unboundArguments = [];
    private Dictionary<string, List<PSObject?>> _boundParameters = [];

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
        _boundParameters = parentContext._boundParameters;
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
                var separatorIndex = tokenValue.IndexOf(CommandCompleter.ValueSeparator);
                if (separatorIndex > 0)
                {
                    var paramValue = tokenValue[(separatorIndex + 1)..];
                    paramName = tokenValue[indicator.Length..separatorIndex];
                    foreach (var param in CommandCompleter.Params)
                    {
                        if (param.IsMatchLongParam(paramName, out var outParamName))
                        {
                            AddBoundParameter(param.Name, $"{paramValue}");
                            break;
                        }
                    }
                }
                else
                {
                    foreach (var param in CommandCompleter.Params)
                    {
                        if (param.IsMatchLongParam(paramName, out var outParamName))
                        {
                            if (param.Type.HasFlag(ArgumentType.Flag))
                            {
                                AddBoundParameter(param.Name, true);
                                break;
                            }
                            else if (argumentIndex < argumentsCount - 1)
                            {
                                argumentIndex++;
                                AddBoundParameter(param.Name, Arguments[argumentIndex].Value);
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
                bool found = false;
                foreach (var param in CommandCompleter.Params)
                {
                    found = param.IsMatchOldStyleParam(paramName, out var outParamName);
                    if (found)
                    {
                        if (param.Type.HasFlag(ArgumentType.Flag))
                        {
                            AddBoundParameter(param.Name, true);
                        }
                        else if (argumentIndex < argumentsCount - 1)
                        {
                            argumentIndex++;
                            AddBoundParameter(param.Name, Arguments[argumentIndex].Value);
                        }
                        else
                        {
                            _pendingParam = new(param, $"{outParamName}", indicator);
                        }
                        break;
                    }
                }

                if (found)
                    continue;

                var shortParams = CommandCompleter.Params.Where(p => p.ShortNames.Length > 0);
                for (var i = 0; i < paramName.Length; i++)
                {
                    var c = paramName[i];
                    var p = shortParams.FirstOrDefault(p => p.ShortNames.Contains(c));
                    if (p is null)
                        continue;

                    if (!p.ShortNames.Contains(c))
                        continue;

                    if (p.Type.HasFlag(ArgumentType.Flag))
                    {
                        AddBoundParameter(p.Name, true);
                    }
                    else if (i == paramName.Length - 1)
                    {
                        if (argumentIndex < argumentsCount - 1)
                        {
                            argumentIndex++;
                            AddBoundParameter(p.Name, Arguments[argumentIndex].Value);
                        }
                        else
                        {
                            _pendingParam = new(p, $"{c}", indicator);
                        }
                        break;
                    }
                    else
                    {
                        AddBoundParameter(p.Name, $"{paramName[(i + 1)..]}");
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

    private void AddBoundParameter(string name, PSObject? paramValue = null)
    {
        if (_boundParameters.TryGetValue(name, out var found))
        {
            found.Add(paramValue);
            Debug($"[BoundParameter]: Added: '{name}', {paramValue}; (Count = {found.Count})");
        }
        else
        {
            _boundParameters.Add(name, [paramValue]);
            Debug($"[BoundParameter]: Added: '{name}', {paramValue} (New)");
        }
    }

    public IEnumerable<CompletionResult?> Complete()
    {
        Debug($"Start Complete");

        string tokenValue = CurrentToken?.Value ?? string.Empty;
        int cursorPosition = CurrentToken?.Position ?? 0;

        CompletionDataCollection results = new();
        bool completed;

        if (_pendingParam is not null)
        {
            completed = _pendingParam.Completer.CompleteValue(results, _pendingParam.ParamName, tokenValue, cursorPosition, _pendingParam.Indicator);
        }
        else if (CurrentToken is not null)
        {
            if (tokenValue.StartsWith(CommandCompleter.LongParamIndicator, StringComparison.Ordinal))
            {
                completed = CommandCompleter.CompleteLongParams(results, tokenValue, cursorPosition);
            }
            else if (tokenValue.StartsWith(CommandCompleter.ParamIndicator, StringComparison.Ordinal))
            {
                completed = CommandCompleter.CompleteOldStyleOrShortParams(results, tokenValue, cursorPosition);
            }
            else if (CommandCompleter.SubCommands.Count > 0 && _unboundArguments.Count == 0)
            {
                completed = CommandCompleter.CompleteSubCommands(results, tokenValue);
            }
            else
            {
                completed = CommandCompleter.CompleteArgument(results, tokenValue, cursorPosition, _unboundArguments.Count);
            }
        }
        else if (CommandCompleter.SubCommands.Count > 0 && _unboundArguments.Count == 0)
        {
            completed = CommandCompleter.CompleteSubCommands(results, tokenValue);
        }
        else
        {
            completed = CommandCompleter.CompleteArgument(results, tokenValue, cursorPosition, _unboundArguments.Count);
        }

        Debug($"Completed = {completed}, Count = {results.Count}");
        if (completed && results.Count == 0)
        {
            // Prevent fallback to filename completion
            return [null];
        }
        Debug($"Build completion data");
        return results.Build();
    }
}
