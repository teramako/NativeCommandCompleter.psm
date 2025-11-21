using System.Collections;
using System.Collections.ObjectModel;
using System.Diagnostics;
using System.Diagnostics.CodeAnalysis;
using System.Management.Automation;
using System.Management.Automation.Language;
using System.Management.Automation.Runspaces;

namespace MT.Comp;

public static class NativeCompleter
{
    [Conditional("DEBUG")]
    private static void Debug(string msg)
    {
        Messages.Add($"Completer: {msg}");
    }
    /// <summary>
    /// Debug messages
    /// </summary>
    public static readonly List<string> Messages = [];

    /// <summary>
    /// Envinronment varible name
    /// </summary>
    public const string ENV_COMPLETER_PATH_NAME = "PS_COMPLETE_PATH";

    internal static readonly Dictionary<string, CommandCompleter> _completers = new();

    /// <summary>
    /// Registered completers
    /// </summary>
    public static ReadOnlyDictionary<string, CommandCompleter> Completers => _completers.AsReadOnly();

    /// <summary>
    /// Find script file path from completion directories
    /// </summary>
    public static bool TryGetCompleterScript(string scriptName, [MaybeNullWhen(false)] out string scriptPath)
    {
        var envPath = Environment.GetEnvironmentVariable(ENV_COMPLETER_PATH_NAME);
        if (string.IsNullOrEmpty(envPath))
        {
            scriptPath = null;
            return false;
        }
        var searchFile = $"{scriptName}.ps1";
        Debug($"SearchFile: {searchFile} in {envPath}");
        scriptPath = envPath.Split(Path.PathSeparator, StringSplitOptions.TrimEntries | StringSplitOptions.RemoveEmptyEntries)
                            .Select(d => Path.Combine(d, searchFile))
                            .FirstOrDefault(File.Exists);
        return !string.IsNullOrEmpty(scriptPath);
    }

    private static bool TryLoadScript(string scriptPath,
                                      IDictionary? parameters,
                                      out Collection<PSObject> results)
    {
        try
        {
            
            Shell.AddCommand(scriptPath);
            if (parameters is not null)
            {
                Shell.AddParameters(parameters);
            }
            results = Shell.Invoke();
            if (Shell.Streams.Error.Count > 0)
            {
                foreach (var error in Shell.Streams.Error)
                {
                    Console.Error.WriteLine($"[{scriptPath}] Error: {error}");
                }
                return false;
            }
            return true;
        }
        finally
        {
            Shell.Commands.Clear();
            Shell.Streams.ClearStreams();
        }
    }

    /// <summary>
    /// Get command completer.
    /// <para>
    /// If not registered, find the command completer generation script in the "completions" directory and run it,
    /// then try again to get the registered completers.
    /// </para>
    /// </summary>
    /// <param name="fileName">Command name</param>
    /// <param name="parameters">Arguments to pass to the command completer generation script</param>
    /// <param name="completer">Command completer obtained</param>
    /// <param name="loadResults">Return values from running the command completer generation script</param>
    /// <returns><see langword="true"/> if the completer is found; otherwise, <see langword="false"/>.</returns>
    public static bool TryGetCommandCompleter(ReadOnlySpan<char> fileName,
                                              IDictionary? parameters,
                                              [MaybeNullWhen(false)] out CommandCompleter completer,
                                              out Collection<PSObject> loadResults)
    {
        completer = null;
        loadResults = [];
        var cmdName = Path.GetExtension(fileName) switch
        {
            ".exe" or ".EXE" when Platform.IsWindows => Path.GetFileNameWithoutExtension(fileName).ToString(),
            _ => fileName.ToString()
        };
        if (_completers.TryGetValue(cmdName, out completer))
        {
            return true;
        }
        if (TryGetCompleterScript(cmdName, out var completerFile)
            && TryLoadScript(completerFile, parameters, out loadResults))
        {
            return _completers.TryGetValue(cmdName, out completer);
        }
        return false;
    }

    /// <summary>
    /// Get completion results from <paramref name="commandLine"/>
    /// </summary>
    /// <seealso cref="Complete(string, CommandAst, int)"/>
    public static IEnumerable<CompletionResult?> Complete(string commandLine, int cursorPosition, PathInfo cwd)
    {
        var ast = Parser.ParseInput(commandLine, out _, out _);
        var commandAst = ast.Find(a => a is CommandAst, false) as CommandAst;
        if (commandAst is null)
            return [];

        return Complete(string.Empty, commandAst, cursorPosition, cwd);
    }

    /// <summary>
    /// Get completion results from <paramref name="commandAst"/>.
    /// It is assumed to be called from ScriptBlock registered with <c>Register-ArgumentCompleter</c> cmdlet.
    /// </summary>
    public static IEnumerable<CompletionResult?> Complete(string wordToComplete, CommandAst commandAst, int cursorPosition, PathInfo cwd)
    {
        var fullName = commandAst.GetCommandName();
        var cmdName = Path.GetFileName(fullName);

        Debug("--------------------------------------");
        Hashtable scriptParameters = new()
        {
            ["wordToComplete"] = wordToComplete,
            ["commandAst"] = commandAst,
            ["cursorPosition"] = cursorPosition
        };
        if (TryGetCommandCompleter(cmdName, scriptParameters, out var commandCompleter, out var loadResults))
        {
            var context = CompletionContext.Create(commandCompleter, wordToComplete, commandAst, cursorPosition, cwd);
            return context.Complete();
        }

        return PSObjectsToCompletionResults(loadResults);
    }

    internal static IEnumerable<CompletionData> PSObjectsToCompletionData(IEnumerable<PSObject?> psobjects)
    {
        foreach (var pso in psobjects)
        {
            if (pso is null)
            {
                continue;
            }
            switch (pso.BaseObject)
            {
                case string:
                case System.Collections.IList:
                case System.Collections.IDictionary:
                    if (LanguagePrimitives.TryConvertTo<CompletionValue>(pso, out var completionValue))
                    {
                        yield return completionValue;
                    }
                    break;
                case CompletionResult result:
                    yield return CompletionValue.FromCommpletionResult(result);
                    break;
                case CompletionData completionData:
                    yield return completionData;
                    break;
                default:
                    var text = $"{pso}";
                    if (string.IsNullOrEmpty(text))
                        break;
                    yield return new CompletionValue(text);
                    break;
            }
        }
    }

    internal static IEnumerable<CompletionResult?> PSObjectsToCompletionResults(IEnumerable<PSObject?> psobjects)
    {
        foreach (var pso in psobjects)
        {
            if (pso is null)
            {
                Debug($"PsoToResult: is null");
                yield return null;
            }
            else if (pso.BaseObject is CompletionResult completionResult
                || LanguagePrimitives.TryConvertTo<CompletionResult>(pso, out completionResult))
            {
                Debug($"PsoToResult: {{ '{completionResult.CompletionText}', '{completionResult.ListItemText}', {completionResult.ResultType}, '{completionResult.ToolTip}' }}");
                yield return completionResult;
            }
        }
    }

    private static Lazy<PowerShell> _shell = new(() =>
    {
        var initialSessionState = InitialSessionState.CreateDefault();
        var assembly = typeof(NativeCompleter).Assembly;
        var moduleDir = Directory.GetParent(assembly.Location)?.Parent?.FullName;
        Debug($"Module dir: {moduleDir}");
        if (moduleDir is not null)
        {
            var psd1File = new FileInfo(Path.Combine(moduleDir, @"NativeCommandCompleter.psm.psd1"));
            Debug($"psd1 path: {psd1File}");
            initialSessionState.ImportPSModule(psd1File.FullName);
        }
        var runspace = RunspaceFactory.CreateRunspace(initialSessionState);
        runspace.Name = assembly.GetName().Name;
        runspace.Open();
        var shell = PowerShell.Create(runspace);
        return shell;
    });

    /// <summary>
    /// PowerShell running on dedicated Runspace named "CommandCompleter"
    /// </sumary>
    public static PowerShell Shell => _shell.Value;
}
