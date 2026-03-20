using System.Collections.ObjectModel;
using System.Management.Automation;

namespace MT.Comp;

public static class Helper
{
    /// <param name="context">Completion context</param>
    /// <inheritdoc cref="CompleteFilename(string, string, bool, bool, ScriptBlock?, string?, string?)"/>
    public static Collection<CompletionData> CompleteFilename(CompletionContext context,
                                                              bool includeHidden = false,
                                                              bool onlyDirectory = false,
                                                              ScriptBlock? filter = null,
                                                              string? prefix = null,
                                                              string? suffix = null)
    {
        string pathToComplete = context.CurrentToken?.Value ?? string.Empty;
        string cwd = context.CurrentDirectory.Path;
        return CompleteFilename(pathToComplete, cwd, includeHidden, onlyDirectory, filter, prefix, suffix);
    }

    /// <summary>
    /// Generate a completion list for a file or directory paths
    /// </summary>
    /// <param name="pathToComplete">
    /// Path string for completion. Can use wildcards <c>*</c> for the filename part at the end.
    /// </param>
    /// <param name="cwd">Current working directory</param>
    /// <param name="includeHidden">Complete hidden files or directories</param>
    /// <param name="onlyDirectory">Complete only directories</param>
    /// <param name="filter">Addtional fileter function</param>
    /// <param name="prefix">Prefix string of the completion text</param>
    /// <param name="suffix">Suffix string of the completion text</param>
    /// <returns>Completion candidates</returns>
    public static Collection<CompletionData> CompleteFilename(string pathToComplete,
                                                              string cwd,
                                                              bool includeHidden = false,
                                                              bool onlyDirectory = false,
                                                              ScriptBlock? filter = null,
                                                              string? prefix = null,
                                                              string? suffix = null)
    {
        bool isStartsWithTilde = false;
        char quote = default;
        if (!string.IsNullOrEmpty(pathToComplete) && pathToComplete[0] is '\'' or '"')
        {
            quote = pathToComplete[0];
            pathToComplete = pathToComplete.Replace($"{quote}", string.Empty);
        }
        if (!string.IsNullOrEmpty(prefix)
            && pathToComplete.StartsWith(prefix, StringComparison.OrdinalIgnoreCase))
        {
            pathToComplete = pathToComplete.Substring(prefix.Length);
        }
        if (!string.IsNullOrEmpty(suffix)
            && pathToComplete.EndsWith(suffix, StringComparison.OrdinalIgnoreCase))
        {
            pathToComplete = pathToComplete.Substring(0, pathToComplete.Length - suffix.Length);
        }
        bool isAbsolutePath = Path.IsPathFullyQualified(pathToComplete);
        string homeDir = string.Empty;
        if (string.IsNullOrEmpty(pathToComplete))
        {
            pathToComplete = $".{Path.DirectorySeparatorChar}";
        }
        else if (pathToComplete[0] is '~')
        {
            if (pathToComplete.Length == 1)
                return [];

            if (pathToComplete[1] != Path.DirectorySeparatorChar)
            {
                // Expansion of '~username' is not supported.
                return [];
            }
            isAbsolutePath = true;
            isStartsWithTilde = true;
            homeDir = Environment.GetEnvironmentVariable(@"HOME") ?? "~";
            pathToComplete = $"{homeDir}{pathToComplete[1..]}";
        }

        string absPath = isAbsolutePath
            ? pathToComplete
            : Path.Join(cwd, pathToComplete);

        var targetDir = Path.GetDirectoryName(absPath);
        if (!Directory.Exists(targetDir))
        {
            return [];
        }
        var opts = new EnumerationOptions()
        {
            AttributesToSkip = FileAttributes.System | (includeHidden ? FileAttributes.None : FileAttributes.Hidden),
            MatchCasing = MatchCasing.CaseInsensitive,
            IgnoreInaccessible = true,
            RecurseSubdirectories = false
        };
        var wordToComplete = $"{Path.GetFileName(absPath)}*";
        Collection<CompletionData> results = [];
        var directoryEnumerator = onlyDirectory
            ? Directory.EnumerateDirectories(targetDir, wordToComplete, opts)
            : Directory.EnumerateFileSystemEntries(targetDir, wordToComplete, opts);
        foreach (string path in directoryEnumerator)
        {
            var file = new FileInfo(path);
            bool filtered = false;
            if (filter is not null)
            {
                try
                {
                    var filterReults = filter.InvokeWithContext(null, [new("_", file)]);
                    filtered = filterReults.Count > 0
                               && LanguagePrimitives.TryConvertTo<bool>(filterReults[0], out var filterResult)
                        ? !filterResult
                        : true;
                }
                catch
                {
                    filtered = true;
                }
            }
            if (filtered)
            {
                continue;
            }
            string text;
            if (!isAbsolutePath)
            {
                var relativePath = Path.GetRelativePath(cwd, path);
                if (relativePath == ".")
                {
                    text = $"{prefix}..{Path.DirectorySeparatorChar}{file.Name}{suffix}";
                }
                else if (relativePath.StartsWith("..", StringComparison.Ordinal))
                {
                    text = $"{prefix}{relativePath}{suffix}";
                }
                else
                {
                    text = $"{prefix}.{Path.DirectorySeparatorChar}{relativePath}{suffix}";
                }
            }
            else if (isStartsWithTilde)
            {
                text = $"{prefix}~{path.Substring(homeDir.Length)}{suffix}";
            }
            else
            {
                text = $"{prefix}{file.FullName}{suffix}";
            }

            if (quote > 0)
            {
                text = $"{quote}{text}{quote}";
            }
            else if (text.Contains(' '))
            {
                text = $"'{text}'";
            }

            if (file.Attributes.HasFlag(FileAttributes.Directory))
            {
                results.Add(new CompletionValue(text, "Directory", $"{file.Name}{Path.DirectorySeparatorChar}",
                                                file.FullName, CompletionResultType.ProviderContainer));
            }
            else
            {
                results.Add(new CompletionValue(text, "File", file.Name,
                                                file.FullName, CompletionResultType.ProviderItem));
            }
        }
        return results;
    }

    /// <summary>
    /// Generate a completion list for commands or filename
    /// </summary>
    /// <param name="context">Completion context</param>
    public static IEnumerable<CompletionData> CompleteCommandOrFilename(CompletionContext context)
    {
        string tokenValue = context.CurrentToken?.Value ?? string.Empty;
        IEnumerable<CompletionResult>? commandsResults
            = CompletionCompleters.CompleteCommand(tokenValue, string.Empty, CommandTypes.Application);
        if (commandsResults is not null)
        {
            string prevCmdName = string.Empty;
            foreach (var result in commandsResults)
            {
                if (result.ListItemText == prevCmdName)
                    continue;

                yield return new CompletionValue(result.CompletionText,
                                                 $"{result.ResultType}",
                                                 result.ListItemText,
                                                 result.ToolTip);
                prevCmdName = result.ListItemText;
            }
        }
        else
        {
            foreach (var result in CompleteFilename(context, onlyDirectory: false, includeHidden: false))
            {
                yield return result;
            }
        }
    }
}
