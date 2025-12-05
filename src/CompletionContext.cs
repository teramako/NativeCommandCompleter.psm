using System.Collections.ObjectModel;
using System.Diagnostics;
using System.Management.Automation;
using System.Management.Automation.Host;
using System.Management.Automation.Language;

namespace MT.Comp;

internal record PendingParamCompleter(ParamCompleter Completer, string ParamName, string OptionPrefix);

public sealed class CompletionContext
{
    [Conditional("DEBUG")]
    private void Debug(string msg)
    {
        NativeCompleter.Messages.Add($"[{Name}] {msg}");
    }

    public string Name { get; }
    public CommandCompleter CommandCompleter { get; }

    /// <summary>
    /// Completion target words supplied from PowerShell-Core
    /// </summary>
    public string WordToComplete { get; }

    /// <summary>
    /// Abstract Syntax Tree of the command
    /// </summary>
    public CommandAst CommandAst { get; }

    /// <summary>
    /// Cursor position in the command line
    /// </summary>
    public int CursorPosition { get; }

    /// <summary>
    /// Host interface
    /// </summary>
    public PSHost Host { get; }

    /// <summary>
    /// Current directory
    /// </summary>
    public PathInfo CurrentDirectory { get; }

    /// <summary>
    /// Arguments of the command that precedes the cursor position
    /// </summary>
    public ReadOnlyCollection<Token> Arguments { get; }
    /// <summary>
    /// Token at the cursor position
    /// </summary>
    public Token? CurrentToken { get; private set; }
    /// <summary>
    /// Arguments after the cursor position
    /// </summary>
    public ReadOnlyCollection<Token> RemainingArguments { get; }

    /// <summary>
    /// Arguments before the cursor position that are not parameters and not the parameter's values
    /// </summary>
    public ReadOnlyCollection<Token> UnboundArguments { get; }

    /// <summary>
    /// Dictionary parsed parameters to parameters and their value
    /// </summary>
    public ReadOnlyDictionary<string, System.Collections.ArrayList> BoundParameters { get; }

    private List<Token> _arguments = [];
    private List<Token> _remainingArguments = [];
    private List<Token> _unboundArguments = [];
    private Dictionary<string, System.Collections.ArrayList> _boundParameters = [];

    private PendingParamCompleter? _pendingParam;
    private CompletionContext? _parent = null;

    private CompletionContext(CommandCompleter commandCompleter, string wordToComplete, CommandAst ast, int cursorPosition, PSHost host, PathInfo cwd)
    {
        Name = commandCompleter.Name;
        CommandCompleter = commandCompleter;
        WordToComplete = wordToComplete;
        CommandAst = ast;
        CursorPosition = cursorPosition;
        Host = host;
        CurrentDirectory = cwd;
        Arguments = _arguments.AsReadOnly();
        RemainingArguments = _remainingArguments.AsReadOnly();
        UnboundArguments = _unboundArguments.AsReadOnly();
        BoundParameters = _boundParameters.AsReadOnly();
    }
    private CompletionContext(CommandCompleter commandCompleter, CompletionContext parentContext, int argumentIndex)
    {
        Name = $"{parentContext.Name} {commandCompleter.Name}";
        CommandCompleter = commandCompleter;
        WordToComplete = parentContext.WordToComplete;
        CommandAst = parentContext.CommandAst;
        CursorPosition = parentContext.CursorPosition;
        Host = parentContext.Host;
        CurrentDirectory = parentContext.CurrentDirectory;
        _parent = parentContext;
        if (argumentIndex < parentContext.Arguments.Count - 1)
        {
            _arguments = parentContext._arguments[(argumentIndex + 1)..];
        }
        _remainingArguments = parentContext._remainingArguments;
        _boundParameters = parentContext._boundParameters;
        CurrentToken = parentContext.CurrentToken;
        Arguments = _arguments.AsReadOnly();
        RemainingArguments = _remainingArguments.AsReadOnly();
        UnboundArguments = _unboundArguments.AsReadOnly();
        BoundParameters = _boundParameters.AsReadOnly();
    }

    public static CompletionContext Create(CommandCompleter commandCompleter, string wordToComplete, CommandAst ast, int cursorPosition, PSHost host, PathInfo cwd)
    {
        CompletionContext context = new(commandCompleter, wordToComplete, ast, cursorPosition, host, cwd);
        NativeCompleter.Messages.Add($"[{context.Name}] Create CompletionContext");
        int prevEndOffset = -1;
        Token? prevToken = null;
        for (var i = 1; i < ast.CommandElements.Count; i++)
        {
            var elm = ast.CommandElements[i];
            var token = new Token(elm, cursorPosition);
            if (elm.Extent.StartOffset == prevEndOffset && prevToken is not null)
            {
                // Merge tokens that have been split into separate tokens into a single token.
                // e.g.) `-i.bk` -> splitted to `-i` and `.bk`
                // See: https://github.com/PowerShell/PowerShell/issues/6291
                token = prevToken;
                token.Append(elm, cursorPosition);
                if (token.IsTarget)
                {
                    context.CurrentToken = token;
                    context._arguments.RemoveAt(context._arguments.Count - 1);
                }
            }
            else if (elm.Extent.EndOffset < cursorPosition)
            {
                context._arguments.Add(token);
            }
            else if (token.IsTarget)
            {
                context.CurrentToken = token;
            }
            else
            {
                context._remainingArguments.Add(token);
            }
            prevEndOffset = elm.Extent.EndOffset;
            prevToken = token;
        }
        return context.Build();
    }

    private CompletionContext Build()
    {
        NativeCompleter.Messages.Add($"[{Name}] Build CompletionContext");

        // Early return if no parameters to analyze
        if (CommandCompleter.SubCommands.Count == 0
            && CommandCompleter.Params.Count == 0
            && CommandCompleter.DelegateArgumentIndex < 0)
        {
            foreach (var token in Arguments)
            {
                AddUnboundArgument(token);
            }
            return this;
        }

        int argumentsCount = Arguments.Count;
        bool hasLongOptionPrefix = !string.IsNullOrEmpty(CommandCompleter.LongOptionPrefix);
        bool hasShortOptionPrefix = !string.IsNullOrEmpty(CommandCompleter.ShortOptionPrefix);

        for (int argumentIndex = 0; argumentIndex < argumentsCount; argumentIndex++)
        {
            Token token = Arguments[argumentIndex];
            ReadOnlySpan<char> tokenValue = token.Value;
            string optionPrefix;

            if (CommandCompleter.SubCommands.Count > 0)
            {
                string tokenStr = tokenValue.ToString();
                foreach (var subCmd in CommandCompleter.SubCommands)
                {
                    if (subCmd.Name.Equals(tokenStr, StringComparison.Ordinal)
                        || subCmd.Aliases.Any(a => a.Equals(tokenStr, StringComparison.Ordinal)))
                    {
                        var subContext = new CompletionContext(subCmd, this, argumentIndex);
                        return subContext.Build();
                    }
                }
            }

            if (hasLongOptionPrefix
                && tokenValue.StartsWith(CommandCompleter.LongOptionPrefix, StringComparison.Ordinal))
            {
                optionPrefix = CommandCompleter.LongOptionPrefix;
                var paramName = tokenValue[optionPrefix.Length..];
                var separatorIndex = tokenValue.IndexOf(CommandCompleter.ValueSeparator);
                if (separatorIndex > 0)
                {
                    // In case the token contains both parameter name and value,
                    // like `--longParam=Value`.
                    var paramValue = tokenValue[(separatorIndex + 1)..];
                    paramName = tokenValue[optionPrefix.Length..separatorIndex];
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
                            if (param.Type == ArgumentType.Flag
                                || param.Type.HasFlag(ArgumentType.FlagOrValue))
                            {
                                AddBoundParameter(param.Name, true);
                                break;
                            }
                            else if (argumentIndex < argumentsCount - 1)
                            {
                                // `--longParam value ...|`
                                //                       ^ cursor
                                argumentIndex++;
                                AddBoundParameter(param.Name, Arguments[argumentIndex].Value);
                                break;
                            }
                            else
                            {
                                // `--longParam |`
                                //              ^ cursor
                                SetPendingParameter(param, $"{outParamName}", optionPrefix);
                            }
                            break;
                        }
                    }
                }
            }
            else if (hasShortOptionPrefix
                     && tokenValue.StartsWith(CommandCompleter.ShortOptionPrefix, StringComparison.Ordinal))
            {
                optionPrefix = CommandCompleter.ShortOptionPrefix;
                var paramName = tokenValue[optionPrefix.Length..];
                bool found = false;
                foreach (var param in CommandCompleter.Params)
                {
                    found = param.IsMatchOldStyleParam(paramName, out var outParamName);
                    if (found)
                    {
                        if (param.Type == ArgumentType.Flag)
                        {
                            AddBoundParameter(param.Name, true);
                        }
                        else if (argumentIndex < argumentsCount - 1)
                        {
                            // `-oldStyleParam value ...|`
                            //                          ^ cursor
                            argumentIndex++;
                            AddBoundParameter(param.Name, Arguments[argumentIndex].Value);
                        }
                        else
                        {
                            // `-oldStyleParam |`
                            //                 ^ cursor
                            SetPendingParameter(param, $"{outParamName}", optionPrefix);
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

                    if (p.Type.HasFlag(ArgumentType.FlagOrValue))
                    {
                        // e.g. `sed -i[.bk]`
                        AddBoundParameter(p.Name, $"{paramName[(i + 1)..]}");
                        break;
                    }
                    else if (p.Type == ArgumentType.Flag)
                    {
                        AddBoundParameter(p.Name, true);
                    }
                    else if (i == paramName.Length - 1)
                    {
                        if (argumentIndex < argumentsCount - 1)
                        {
                            // `-abc Value ... |`
                            //      \          ^ cursor 
                            //       i
                            // the argument of `c` param is supplied
                            argumentIndex++;
                            AddBoundParameter(p.Name, Arguments[argumentIndex].Value);
                        }
                        else
                        {
                            // `-abc  |`
                            //      \ ^ cursor 
                            //       i
                            // the argument of `c` param is NOT supplied
                            SetPendingParameter(p, $"{c}", optionPrefix);
                        }
                        break;
                    }
                    else
                    {
                        AddBoundParameter(p.Name, $"{paramName[(i + 1)..]}");
                        break;
                    }
                }
            }
            else
            {
                if (UnboundArguments.Count == CommandCompleter.DelegateArgumentIndex)
                {
                    var cmdName = Path.GetFileName(tokenValue).ToString();
                    var nestedContext = NativeCompleter.TryGetCommandCompleter(cmdName, null, out var delegatedCompleter, out _)
                        ? new CompletionContext(delegatedCompleter, this, argumentIndex)
                        : new CompletionContext(new(cmdName, "Unknown"), this, argumentIndex);
                    return nestedContext.Build();
                }
                AddUnboundArgument(token);
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

    internal void AddUnboundArgument(Token token)
    {
        _unboundArguments.Add(token);
    }

    internal void SetPendingParameter(ParamCompleter parameter, string name, string value)
    {
        _pendingParam = new(parameter, name, value);
    }

    public IEnumerable<CompletionResult?> Complete()
    {
        Debug($"Start Complete");

        string tokenValue = CurrentToken?.Value ?? string.Empty;
        int cursorPosition = CurrentToken?.Position ?? 0;

        CompletionDataCollection results = new();
        bool completed = false;

        if (_pendingParam is not null)
        {
            completed = _pendingParam.Completer.CompleteValue(results,
                                                              this,
                                                              _pendingParam.ParamName,
                                                              tokenValue,
                                                              cursorPosition,
                                                              _pendingParam.OptionPrefix);
        }
        else
        {
            completed = CommandCompleter.CompleteSubCommands(results, this, tokenValue);

            if (!completed)
                completed = CommandCompleter.CompleteParams(results, this, tokenValue, cursorPosition);

            completed = CommandCompleter.CompleteArgument(results, this, tokenValue, cursorPosition, _unboundArguments.Count)
                        || completed;
        }

        Debug($"Completed = {completed}, Count = {results.Count}");
        if (completed && results.Count == 0)
        {
            // Prevent fallback to filename completion
            return [null];
        }
        Debug($"Build completion data");
        return results.Build(Host);
    }
}
