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

    private static (List<Token?> args, int argIndex) ParseCommandElements(CommandAst commandAst, int cursorPosition)
    {
        List<Token?> args = new();
        Token? currentToken = null;
        int argIndex = 0;
        foreach (var ast in commandAst.CommandElements)
        {
            if (ast.Extent.StartOffset <= cursorPosition && cursorPosition <= ast.Extent.EndOffset)
            {
                currentToken = new Token(ast, cursorPosition);
                args.Add(currentToken);
                argIndex = args.Count - 1;
                Debug($"Add Token [{args.Count - 1}] (Current): '{currentToken}'");
                break;
            }
            else
            {
                if (ast.Extent.StartOffset > cursorPosition)
                {
                    args.Add(null);
                    argIndex = args.Count - 1;
                    Debug($"Add Empty Token [{args.Count - 1}]");
                }
                var token = new Token(ast);
                args.Add(token);
                Debug($"Add Token [{args.Count - 1}]: '{token}'");
            }
        }
        if (argIndex == 0)
        {
            args.Add(null);
            argIndex = args.Count - 1;
        }
        return (args, argIndex);
    }

    /// <summary>
    /// Find script file path from completion directories
    /// </summary>
    public static bool TryGetCompleterScript(string scriptName, [NotNullWhen(true)] out string? scriptPath)
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
                                      string wordToComplete,
                                      CommandAst commandAst,
                                      int cursorPosition,
                                      out Collection<PSObject> results)
    {
        try
        {
            results = Shell.AddCommand(scriptPath)
                           .AddParameter("wordToComplete", wordToComplete)
                           .AddParameter("commandAst", commandAst)
                           .AddParameter("cursorPosition", cursorPosition)
                           .Invoke();
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
    /// Get completion results from <paramref name="commandLine"/>
    /// </summary>
    /// <seealso cref="Complete(string, CommandAst, int)"/>
    public static IEnumerable<CompletionResult?> Complete(string commandLine, int cursorPosition)
    {
        var ast = Parser.ParseInput(commandLine, out _, out _);
        var commandAst = ast.Find(a => a is CommandAst, false) as CommandAst;
        if (commandAst is null)
            return [];

        return Complete(string.Empty, commandAst, cursorPosition);
    }

    /// <summary>
    /// Get completion results from <paramref name="commandAst"/>.
    /// It is assumed to be called from ScriptBlock registered with <c>Register-ArgumentCompleter</c> cmdlet.
    /// </summary>
    public static IEnumerable<CompletionResult?> Complete(string wordToComplete, CommandAst commandAst, int cursorPosition)
    {
        var fullName = commandAst.GetCommandName();
        var cmdName = Path.GetFileName(fullName);

        Debug("--------------------------------------");
        CommandCompleter? commandCompleter;
        if (!_completers.TryGetValue(cmdName, out commandCompleter))
        {
            if (TryGetCompleterScript(cmdName, out var completerFile)
                && TryLoadScript(completerFile, wordToComplete, commandAst, cursorPosition, out var results))
            {
                if (!_completers.TryGetValue(cmdName, out commandCompleter))
                {
                    return PSObjectsToCompletionResults(results);
                }
            }
        }

        if (commandCompleter is not null)
        {
            var context = CompletionContext.Create(commandCompleter, commandAst, cursorPosition);
            return context.Complete();
        }

        return [];
    }

    internal static IEnumerable<CompletionResult?> PSObjectsToCompletionResults(IEnumerable<PSObject> psobjects)
    {
        foreach (var pso in psobjects)
        {
            if (pso.BaseObject is CompletionResult completionResult
                || LanguagePrimitives.TryConvertTo<CompletionResult>(pso, out completionResult))
            {
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
