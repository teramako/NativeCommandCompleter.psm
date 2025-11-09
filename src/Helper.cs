using System.Collections.ObjectModel;
using System.Management.Automation;

namespace MT.Comp;

public static class Helper
{
    /// <param name="context">Completion context</param>
    /// <inheritdoc cref="CompleteFilename(string, string, bool, bool, Func{FileInfo, bool}?)"/>
    public static Collection<CompletionData> CompleteFilename(CompletionContext context,
                                                              bool includeHidden = false,
                                                              bool onlyDirectory = false,
                                                              ScriptBlock? filter = null)
    {
        string pathToComplete = context.CurrentToken?.Value ?? string.Empty;
        string cwd = context.CurrentDirectory.Path;
        return CompleteFilename(pathToComplete, cwd, includeHidden, onlyDirectory, filter);
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
    /// <returns>Completion candidates</returns>
    public static Collection<CompletionData> CompleteFilename(string pathToComplete,
                                                              string cwd,
                                                              bool includeHidden = false,
                                                              bool onlyDirectory = false,
                                                              ScriptBlock? filter = null)
    {
        bool isStartsWithTilde = false;
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
                    text = $"..{Path.DirectorySeparatorChar}{file.Name}";
                }
                else if (relativePath.StartsWith("..", StringComparison.Ordinal))
                {
                    text = relativePath;
                }
                else
                {
                    text = $".{Path.DirectorySeparatorChar}{relativePath}";
                }
            }
            else if (isStartsWithTilde)
            {
                text = $"~{path.Substring(homeDir.Length)}";
            }
            else
            {
                text = file.FullName;
            }

            if (text.Contains(' '))
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
}
