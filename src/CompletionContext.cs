using System.Collections;
using System.Collections.ObjectModel;
using System.Management.Automation;
using System.Management.Automation.Host;
using System.Management.Automation.Language;

namespace MT.Comp;

internal record PendingParamCompleter(ParamCompleter Completer,
                                      string ParamName,
                                      string[] ParamArgs,
                                      string OptionPrefix,
                                      bool CompleteOnly);

public sealed class CompletionContext
{
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
    public ReadOnlyDictionary<string, ArrayList> BoundParameters { get; }

    public Hashtable? Metadata => CommandCompleter.Metadata;

    private List<Token> _arguments = [];
    private List<Token> _remainingArguments = [];
    private List<Token> _unboundArguments = [];
    private Dictionary<string, ArrayList> _boundParameters = [];

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
    private CompletionContext(CommandCompleter commandCompleter, ReadOnlySpan<char> cmdName, CompletionContext parentContext, int argumentIndex)
    {
        Name = $"{parentContext.Name} {cmdName}";
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

    /// <summary>
    /// Create new CompletionContext from CommandAst
    /// </summary>
    /// <param name="commandCompleter">CommandCompleter</param>
    /// <param name="wordToComplete">Word to complete</param>
    /// <param name="ast">CommandAst</param>
    /// <param name="cursorPosition">Cursor position</param>
    /// <param name="host">Host interface</param>
    /// <param name="cwd">Current directory</param>
    /// <returns>CompletionContext</returns>
    public static CompletionContext Create(CommandCompleter commandCompleter, string wordToComplete, CommandAst ast, int cursorPosition, PSHost host, PathInfo cwd)
    {
        CompletionContext context = new(commandCompleter, wordToComplete, ast, cursorPosition, host, cwd);
        NativeCompleter.Debug($"[{context.Name}] Create CompletionContext");
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
        return commandCompleter.ParseArguments(context);
    }

    /// <summary>
    /// Create nested CompletionContext for sub-command
    /// </summary>
    /// <param name="commandCompleter">CommandCompleter</param>
    /// <param name="cmdName">Command name</param>
    /// <param name="argumentIndex">Argument index of the sub-command</param>
    /// <returns>CompletionContext</returns>
    public CompletionContext CreateNestedContext(CommandCompleter commandCompleter, ReadOnlySpan<char> cmdName, int argumentIndex)
    {
        var nestedContext = new CompletionContext(commandCompleter, cmdName, this, argumentIndex);
        return commandCompleter.ParseArguments(nestedContext);
    }

    /// <inheritdoc cref="CreateNestedContext(CommandCompleter, ReadOnlySpan{char}, int)"/>
    public CompletionContext CreateNestedContext(CommandCompleter commandCompleter, int argumentIndex)
    {
        return CreateNestedContext(commandCompleter, commandCompleter.Name, argumentIndex);
    }

    internal void AddBoundParameter(string name, object? paramValue = null)
    {
        if (_boundParameters.TryGetValue(name, out var found))
        {
            found.Add(paramValue);
            NativeCompleter.Debug($"[{Name}] BoundParameter: Added: '{name}', {paramValue}; (Count = {found.Count})");
        }
        else
        {
            _boundParameters.Add(name, [paramValue]);
            NativeCompleter.Debug($"[{Name} BoundParameter: Added: '{name}', {paramValue} (New)");
        }
    }

    internal void AddUnboundArgument(Token token)
    {
        _unboundArguments.Add(token);
    }

    /// <summary>
    /// Set up data for later processing of parameter argument completions
    /// </summary>
    /// <param name="parameter">The parameter object</param>
    /// <param name="paramName">Parameter name of the parameter</param>
    /// <param name="paramArgs">Arguments of the parameter</param>
    /// <param name="optionPrefix">Prefix of the prameter name. e.g) <c>-</c>, <c>--</c></param>
    /// <param name="completeOnly">
    /// <see langword="true"/> for only completion of this parameter argument,
    /// <see langword="false"/> for completion of other parameters as well
    /// </param>
    internal void SetPendingParameter(ParamCompleter parameter,
                                      string paramName,
                                      string[] paramArgs,
                                      string optionPrefix,
                                      bool completeOnly = true)
    {
        _pendingParam = new(parameter, paramName, paramArgs, optionPrefix, completeOnly);
    }

    public IEnumerable<CompletionResult?> Complete()
    {
        NativeCompleter.Debug($"[{Name}] Start Complete");

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
                                                              _pendingParam.ParamArgs,
                                                              cursorPosition,
                                                              _pendingParam.OptionPrefix);
            if (!_pendingParam.CompleteOnly)
            {
                completed = CommandCompleter.CompleteSubCommands(results, this, tokenValue);

                completed = CommandCompleter.CompleteParams(results, this, tokenValue, cursorPosition)
                            || completed;
            }
        }
        else
        {
            completed = CommandCompleter.CompleteSubCommands(results, this, tokenValue);

            completed = CommandCompleter.CompleteParams(results, this, tokenValue, cursorPosition)
                        || completed;

            completed = CommandCompleter.CompleteArgument(results, this, tokenValue, cursorPosition, _unboundArguments.Count)
                        || completed;
        }

        NativeCompleter.Debug($"[{Name} Completed = {completed}, Count = {results.Count}");
        if (completed && results.Count == 0)
        {
            // Prevent fallback to filename completion
            return [null];
        }
        NativeCompleter.Debug($"[{Name}] Build completion data");
        return results.Build(Host);
    }
}
