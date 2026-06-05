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
                                      bool CompleteOnly);

/// <param name="IsAvailable">
/// <see langword="true"/> indicates that an element at the cursor position is found, otherwise <see langword="false"/>.
/// </param>
/// <param name="Element">
/// The element at the cursor position.</param>
/// <param name="Index">
/// The array index where the cursor is located. If invalid, it will be <c>-1</c>.
/// </param>
internal readonly record struct CursorElement(bool IsAvailable, ArgumentElement Element, int Index);

public sealed class CompletionContext
{
    public string Name { get; }
    public CommandCompleter CommandCompleter { get; }

    /// <summary>
    /// Command-line string
    /// </summary>
    public string CommandLine { get; }

    /// <summary>
    /// Abstract Syntax Tree of the command
    /// </summary>
    public CommandAst CommandAst { get; }

    /// <summary>
    /// All tokens in the command-line
    /// </summary>
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
    [Hidden]
    public ReadOnlySpan<ArgumentElement> ArgumentsBeforeCursor => Arguments.AsSpan(_argumentsBeforeCursorRange);

    /// <summary>
    /// Argument at the cursor position
    /// </summary>
    public ArgumentElement CurrentArgument { get; }

    /// <summary>
    /// Arguments after the cursor position
    /// </summary>
    [Hidden]
    public ReadOnlySpan<ArgumentElement> RemainingArguments => Arguments.AsSpan(_remainingArgumentsRange);

    /// <summary>
    /// Arguments before the cursor position that are not parameters and not the parameter's values
    /// </summary>
    public ReadOnlyCollection<ArgumentElement> UnboundArguments { get; }

    /// <summary>
    /// Dictionary parsed parameters to parameters and their value
    /// </summary>
    public ReadOnlyDictionary<string, ArrayList> BoundParameters { get; }

    /// <summary>
    /// An element of the argument at the cursor.
    /// </summary>
    /// <remarks>
    /// The difference from <see cref="CurrentArgument"/> is that, in the case of an array literal, it returns the value of the extracted element.
    /// </remarks>
    internal CursorElement CursorElement => _lazyCursorElement.Value;

    private Range _argumentsBeforeCursorRange;
    private Range _remainingArgumentsRange;

    private List<ArgumentElement> _unboundArguments = [];
    private Dictionary<string, ArrayList> _boundParameters = [];

    private PendingParamCompleter? _pendingParam;
    private CompletionContext? _parent = null;

    private readonly Lazy<CursorElement> _lazyCursorElement;

    private CompletionContext(CommandCompleter commandCompleter, CommandAst commandAst, int cursorPosition, PSHost host, PathInfo cwd)
    {
        Name = commandCompleter.Name;
        CommandCompleter = commandCompleter;
        CommandLine = commandAst.ToString();
        CommandAst = commandAst;
        CursorPosition = cursorPosition;
        Host = host;
        CurrentDirectory = cwd;
        UnboundArguments = _unboundArguments.AsReadOnly();
        BoundParameters = _boundParameters.AsReadOnly();
        Arguments = Tokenizer.ReconstructArgv(CommandLine, out var tokens);
        Tokens = tokens;
        (_argumentsBeforeCursorRange, int index, _remainingArgumentsRange) = AnalyzeArguments(Arguments, cursorPosition);
        CurrentArgument = index < 0 ? ArgumentElement.CreateEmptyArgument(cursorPosition) : Arguments[index];
        _lazyCursorElement = new(() => new(TryGetElementAtCursor(out var elem, out index), elem, index));
    }
    private CompletionContext(CommandCompleter commandCompleter, ReadOnlySpan<char> cmdName, CompletionContext parentContext, int argumentIndex)
    {
        Name = $"{parentContext.Name} {cmdName}";
        CommandCompleter = commandCompleter;
        CommandLine = parentContext.CommandLine;
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
        _lazyCursorElement = parentContext._lazyCursorElement;
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
    /// <param name="commandAst">CommandAst</param>
    /// <param name="cursorPosition">Cursor position</param>
    /// <param name="host">Host interface</param>
    /// <param name="cwd">Current directory</param>
    /// <returns>CompletionContext</returns>
    public static CompletionContext Create(CommandCompleter commandCompleter, CommandAst commandAst, int cursorPosition, PSHost host, PathInfo cwd)
    {
        CompletionContext context = new(commandCompleter, commandAst, cursorPosition, host, cwd);
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
    /// <param name="completeOnly">
    /// <see langword="true"/> for only completion of this parameter argument,
    /// <see langword="false"/> for completion of other parameters as well
    /// </param>
    internal void SetPendingParameter(ParamCompleter parameter,
                                      string paramName,
                                      IList<ArgumentElement> paramArgs,
                                      bool completeOnly = true)
    {
        _pendingParam = new(parameter, paramName, paramArgs, completeOnly);
        NativeCompleter.Debug($"[{Name}] SetPendingParameter: {{ ID='{parameter.Id}', Name='{paramName}', Args=[{string.Join(',', paramArgs)}] }}");
    }

    /// <summary>
    /// Attempts to retrieve the element at the cursor position from <paramref name="arg"/>.
    /// <para>
    /// If <paramref name="arg"/> is an array literal, each element is scanned in an attempt to detect a match.
    /// If it is not an array literal, <paramref name="arg"/> itself is scanned.
    /// </para>
    /// </summary>
    /// <param name="arg">Argument value to be scanned</param>
    /// <param name="element">The detected element.</param>
    /// <param name="index">The array index where the cursor is located. If invalid, it will be <c>-1</c>.</param>
    /// <returns>
    /// <see langword="true"/> indicates that an element at the cursor position is found, otherwise <see langword="false"/>.
    /// </returns>
    internal bool TryGetElementAtCursor(ArgumentElement arg, out ArgumentElement element, out int index)
    {
        index = -1;

        if (arg.ArrayElements is null)
        {
            if (arg.StartOffset == CursorPosition)
            {
                element = ArgumentElement.CreateEmptyArgument(CursorPosition);
                return true;
            }
            else if (arg.StartOffset < CursorPosition && CursorPosition <= arg.EndOffset)
            {
                element = arg;
                return true;
            }
            element = ArgumentElement.CreateEmptyArgument(CursorPosition);
            return false;
        }

        if (arg.StartOffset < CursorPosition && CursorPosition <= arg.EndOffset)
        {
            var arrayElements = arg.ArrayElements.Value;
            for (index = arrayElements.Length - 1; index >= 0; index--)
            {
                var arrayElementRange = arrayElements[index];
                var end = arrayElementRange.End.Value - 1;
                var lastToken = Tokens[end];

                if (lastToken.Extent.EndOffset < CursorPosition)
                {
                    element = ArgumentElement.CreateEmptyArgument(CursorPosition);
                    index += 1;
                    return true;
                }

                var start = arrayElementRange.Start.Value;
                var firstToken = Tokens[start];

                if (firstToken.Extent.StartOffset == CursorPosition)
                {
                    element = ArgumentElement.CreateEmptyArgument(CursorPosition);
                    return true;
                }

                if (firstToken.Extent.StartOffset < CursorPosition && CursorPosition <= lastToken.Extent.EndOffset)
                {
                    element = ArgumentElement.Create(CommandLine, start, end, Tokens);
                    return true;
                }
            }
        }

        index = -1;
        element = ArgumentElement.CreateEmptyArgument(CursorPosition);
        return false;
    }
    /// <summary>
    /// Attempts to retrieve the element at the cursor position.
    /// </summary>
    /// <inheritdoc cref="TryGetElementAtCursor(in ArgumentElement, out ArgumentElement, out int)"/>
    public bool TryGetElementAtCursor(out ArgumentElement element, out int index) => TryGetElementAtCursor(CurrentArgument, out element, out index);

    /// <summary>
    /// Get cursor offset position in the <paramref name="arg"/>.
    /// </summary>
    /// <returns>Cursor offset position from the start position of the argument</returns>
    /// <exception cref="ArgumentOutOfRangeException"/>
    public int GetCursorOffsetInValue(ArgumentElement arg)
    {
        ArgumentOutOfRangeException.ThrowIfGreaterThan(arg.StartOffset, CursorPosition);
        ArgumentOutOfRangeException.ThrowIfLessThan(arg.EndOffset, CursorPosition);

        if (arg.Value.Length == arg.EndOffset - arg.StartOffset)
            return CursorPosition - arg.StartOffset;

        if (arg.Type.HasFlag(ArgumentElementType.Expression))
            return CursorPosition - arg.StartOffset;

        var rawValue = CommandLine.AsSpan(arg.RawRange);
        int offset = 0;
        int i = 0;
        int cursorOffset = CursorPosition - arg.StartOffset;
        for (; i < rawValue.Length; i++)
        {
            char c = rawValue[i];

            switch (c)
            {
                case '\'':
                    i = ProcessInnerSingleQuote(rawValue, i, ref offset, cursorOffset);
                    if (offset >= cursorOffset)
                        return offset;
                    continue;
                case '"':
                    i = ProcessInnerDoubleQuote(rawValue, i, ref offset, cursorOffset);
                    if (offset >= cursorOffset)
                        return offset;
                    continue;
                case '`':
                    if (i + 1 < rawValue.Length)
                        i++;
                    break;
            }
            offset++;
            if (offset >= cursorOffset)
                break;
        }

        return offset;
    }

    /// <summary>
    /// Get cursor offset position in the argument at cursor.
    /// </summary>
    /// <returns>Cursor offset position from the start position of the current argument</returns>
    public int GetCursorOffsetInValue() => GetCursorOffsetInValue(CurrentArgument);

    /// <seealso cref="GetCursorOffsetInValue(ArgumentElement)"/>
    private static int ProcessInnerDoubleQuote(scoped ReadOnlySpan<char> rawValue, int index, ref int offset, int cursorOffset)
    {
        for (index += 1; index < rawValue.Length; index++)
        {
            char qc = rawValue[index];
            switch (qc)
            {
                case '"':
                    if (index + 1 < rawValue.Length && rawValue[index + 1] == '"')
                        index++;
                    break;
                case '`':
                    if (index + 1 < rawValue.Length)
                        index++;
                    break;
            }
            offset++;
            if (offset >= cursorOffset)
                return index;
        }
        return index;
    }

    /// <seealso cref="GetCursorOffsetInValue(ArgumentElement)"/>
    private static int ProcessInnerSingleQuote(scoped ReadOnlySpan<char> rawValue, int index, ref int offset, int cursorOffset)
    {
        for (index += 1; index < rawValue.Length; index++)
        {
            char qc = rawValue[index];
            if (qc is '\'')
            {
                if (index + 1 < rawValue.Length && rawValue[index + 1] == '\'')
                    index++;
                else
                    break;
            }
            offset++;
            if (offset >= cursorOffset)
                return index;
        }
        return index;
    }

    public IEnumerable<CompletionResult?> Complete()
    {
        NativeCompleter.Debug($"[{Name}] Start Complete");

        int cursorOffsetPosition = GetCursorOffsetInValue();

        CompletionDataCollection results = new();
        bool completed = false;

        if (_pendingParam is not null)
        {
            completed = _pendingParam.Completer.CompleteValue(results,
                                                              this,
                                                              _pendingParam.ParamName,
                                                              CurrentArgument.Value,
                                                              _pendingParam.ParamArgs.AsReadOnly(),
                                                              cursorOffsetPosition);
            if (!_pendingParam.CompleteOnly)
            {
                completed = CommandCompleter.CompleteSubCommands(results, this);

                completed = CommandCompleter.CompleteParams(results, this, cursorOffsetPosition)
                            || completed;
            }
        }
        else
        {
            completed = CommandCompleter.CompleteSubCommands(results, this);

            completed = CommandCompleter.CompleteParams(results, this, cursorOffsetPosition)
                        || completed;

            if (!completed)
                completed = CommandCompleter.CompleteArgument(results, this, cursorOffsetPosition, _unboundArguments.Count);
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
