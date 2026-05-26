using System.Collections;
using System.Collections.Immutable;
using System.Collections.ObjectModel;
using System.Management.Automation;
using System.Management.Automation.Host;
using System.Management.Automation.Language;

namespace Sabamiso;

internal record PendingParamCompleter(ParamCompleter Completer,
                                      string ParamName,
                                      IList<ArgumentElement> ParamArgs,
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

    public ImmutableArray<Token> Tokens { get; }

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
    /// All arguments
    /// </summary>
    public ImmutableArray<ArgumentElement> Arguments { get; }

    /// <summary>
    /// Arguments of the command that precedes the cursor position
    /// </summary>
    public ReadOnlySpan<ArgumentElement> ArgumentsBeforeCursor => Arguments.AsSpan(_argumentsBeforeCursorRange);
    /// <summary>
    /// Token at the cursor position
    /// </summary>
    public ArgumentElement CurrentArgument { get; }
    /// <summary>
    /// Arguments after the cursor position
    /// </summary>
    public ReadOnlySpan<ArgumentElement> RemainingArguments => Arguments.AsSpan(_remainingArgumentsRange);

    /// <summary>
    /// Arguments before the cursor position that are not parameters and not the parameter's values
    /// </summary>
    public ReadOnlyCollection<ArgumentElement> UnboundArguments { get; }

    /// <summary>
    /// Dictionary parsed parameters to parameters and their value
    /// </summary>
    public ReadOnlyDictionary<string, ArrayList> BoundParameters { get; }

    private Range _argumentsBeforeCursorRange;
    private Range _remainingArgumentsRange;

    private List<ArgumentElement> _unboundArguments = [];
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
        UnboundArguments = _unboundArguments.AsReadOnly();
        BoundParameters = _boundParameters.AsReadOnly();
        Arguments = Tokenizer.ReconstructArgv(ast, out var tokens);
        Tokens = tokens;
        (_argumentsBeforeCursorRange, int index, _remainingArgumentsRange) = AnalyzeArguments(Arguments, cursorPosition);
        CurrentArgument = index < 0 ? ArgumentElement.CreateEmptyArgument(cursorPosition) : Arguments[index];
    }
    private CompletionContext(CommandCompleter commandCompleter, ReadOnlySpan<char> cmdName, CompletionContext parentContext, int argumentIndex)
    {
        Name = $"{parentContext.Name} {cmdName}";
        CommandCompleter = commandCompleter;
        WordToComplete = parentContext.WordToComplete;
        CommandAst = parentContext.CommandAst;
        Tokens = parentContext.Tokens;
        CursorPosition = parentContext.CursorPosition;
        Host = parentContext.Host;
        CurrentDirectory = parentContext.CurrentDirectory;
        _parent = parentContext;
        Arguments = parentContext.Arguments;
        _argumentsBeforeCursorRange = argumentIndex < parentContext.ArgumentsBeforeCursor.Length
                ? (argumentIndex + 1)..
                : default;
        CurrentArgument = parentContext.CurrentArgument;
        _remainingArgumentsRange = parentContext._remainingArgumentsRange;
        _boundParameters = parentContext._boundParameters;
        UnboundArguments = _unboundArguments.AsReadOnly();
        BoundParameters = _boundParameters.AsReadOnly();
    }

    /// <summary>
    /// Split the list of command arguments into those preceding the cursor position, those at the cursor position, and the remaining arguments
    /// </summary>
    private static (Range ArgumentsBeforeCursorRange, int CurrentArgumentIndex, Range RemainingArgumentsRange)
        AnalyzeArguments(ImmutableArray<ArgumentElement> arguments, int cursorPosition)
    {
        var current = -1;
        var i = 0;
        for (; i < arguments.Length; i++)
        {
            var arg = arguments[i];
            if (arg.EndOffset < cursorPosition)
                continue;

            if (cursorPosition <= arg.StartOffset)
            {
                break;
            }
            else if (arg.StartOffset < cursorPosition && cursorPosition <= arg.EndOffset)
            {
                current = i;
                break;
            }
        }
        var argumentsBeforeCursorRange = ..i;
        var remainingArgumentsRange = current < 0 ? i.. : (i + 1)..;
        return (argumentsBeforeCursorRange, current, remainingArgumentsRange);
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

    internal void AddBoundParameter(string name, object paramValue)
    {
        ArrayList values = paramValue is ICollection c ? [..c] : [paramValue];

        if (_boundParameters.TryGetValue(name, out var found))
        {
            found.AddRange(values);
            NativeCompleter.Debug($"[{Name}] AddBoundParameter {{ Id='{name}', Value='{string.Join(',', values.Cast<object>().Select(o=>$"{o}"))}', (Count = {found.Count}) }}");
        }
        else
        {
            _boundParameters.Add(name, values);
            NativeCompleter.Debug($"[{Name}] AddBoundParameter {{ Id='{name}', Value='{string.Join(',', values.Cast<object>().Select(o=>$"{o}"))}' (New) }}");
        }
    }

    internal void AddUnboundArgument(ArgumentElement arg)
    {
        _unboundArguments.Add(arg);
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
                                      IList<ArgumentElement> paramArgs,
                                      string optionPrefix,
                                      bool completeOnly = true)
    {
        _pendingParam = new(parameter, paramName, paramArgs, optionPrefix, completeOnly);
        NativeCompleter.Debug($"[{Name}] SetPendingParameter: {{ ID='{parameter.Id}', Name='{paramName}', Args=[{string.Join(',', paramArgs)}], Prefix='{optionPrefix}' }}");
    }

    public IEnumerable<CompletionResult?> Complete()
    {
        NativeCompleter.Debug($"[{Name}] Start Complete");

        int cursorPosition = CursorPosition - CurrentArgument.StartOffset;

        CompletionDataCollection results = new();
        bool completed = false;

        if (_pendingParam is not null)
        {
            completed = _pendingParam.Completer.CompleteValue(results,
                                                              this,
                                                              _pendingParam.ParamName,
                                                              CurrentArgument.Value,
                                                              _pendingParam.ParamArgs.AsReadOnly(),
                                                              cursorPosition,
                                                              _pendingParam.OptionPrefix);
            if (!_pendingParam.CompleteOnly)
            {
                completed = CommandCompleter.CompleteSubCommands(results, this, CurrentArgument);

                completed = CommandCompleter.CompleteParams(results, this, CurrentArgument, cursorPosition)
                            || completed;
            }
        }
        else
        {
            completed = CommandCompleter.CompleteSubCommands(results, this, CurrentArgument);

            completed = CommandCompleter.CompleteParams(results, this, CurrentArgument, cursorPosition)
                        || completed;

            if (!completed)
                completed = CommandCompleter.CompleteArgument(results, this, CurrentArgument, cursorPosition, _unboundArguments.Count);
        }

        NativeCompleter.Debug($"[{Name}] Completed = {completed}, Count = {results.Count}");
        if (completed && results.Count == 0)
        {
            // Prevent fallback to filename completion
            return [null];
        }
        NativeCompleter.Debug($"[{Name}] Build completion data");
        return results.Build(Host);
    }
}
