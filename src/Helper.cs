using System.Collections.ObjectModel;
using System.Management.Automation;
using System.Text;

namespace Sabamiso;

public static class Helper
{
    /// <param name="context">Completion context</param>
    /// <inheritdoc cref="CompleteFilename(string, string, bool, bool, ScriptBlock?, string?, string?)"/>
    public static Collection<CompletionData> CompleteFilename(CompletionContext context,
                                                              bool includeHidden = false,
                                                              bool onlyDirectory = false,
                                                              ScriptBlock? filter = null,
                                                              ReadOnlySpan<char> prefix = default,
                                                              ReadOnlySpan<char> suffix = default)
        => CompleteFilename(context.CurrentArgument.Value, context.CurrentDirectory, includeHidden, onlyDirectory, filter, prefix, suffix);

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
    public static Collection<CompletionData> CompleteFilename(ReadOnlySpan<char> pathToComplete,
                                                              string cwd,
                                                              bool includeHidden = false,
                                                              bool onlyDirectory = false,
                                                              ScriptBlock? filter = null,
                                                              ReadOnlySpan<char> prefix = default,
                                                              ReadOnlySpan<char> suffix = default)
    {
        bool isStartsWithTilde = false;
        char quote = default;
        if (!pathToComplete.IsEmpty && pathToComplete[0] is '\'' or '"')
        {
            quote = pathToComplete[0];
            pathToComplete = pathToComplete[1..];
            if (!pathToComplete.IsEmpty && pathToComplete[^1] == quote)
            {
                pathToComplete = pathToComplete[..^1];
            }
        }
        if (!prefix.IsEmpty
            && pathToComplete.StartsWith(prefix, StringComparison.OrdinalIgnoreCase))
        {
            pathToComplete = pathToComplete[prefix.Length..];
        }
        if (!suffix.IsEmpty
            && pathToComplete.EndsWith(suffix, StringComparison.OrdinalIgnoreCase))
        {
            pathToComplete = pathToComplete[..^suffix.Length];
        }
        bool isAbsolutePath = Path.IsPathFullyQualified(pathToComplete);
        string homeDir = string.Empty;
        if (pathToComplete.IsEmpty)
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
            ? pathToComplete.ToString()
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
            bool isDirectory;
            try
            {
                isDirectory = file.Attributes.HasFlag(FileAttributes.Directory);
            }
            catch
            {
                continue;
            }
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

            if (isDirectory)
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
        string tokenValue = context.CurrentArgument.Value;
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

    /// <summary>
    /// Reconstructs a PowerShell-valid string representation of this argument.
    /// </summary>
    /// <remarks>
    /// If <paramref name="quote"/> is one of the following, the <paramref name="text"/> is
    /// enclosed in the corresponding quotation marks, and any quotation marks
    /// inside the content are escaped according to PowerShell rules:
    /// <list type="bullet">
    ///     <item><term><c>'</c></term><description>enclosed in single quotes, internal <c>'</c> becomes <c>''</c></description></item>
    ///     <item><term><c>"</c></term><description>enclosed in double quotes, internal <c>"</c> becomes <c>""</c></description></item>
    /// </list>
    /// For all other types (e.g., bare words), <see cref="Value"/> is returned as-is.
    /// </remarks>
    /// <param name="quote"></param>
    /// <param name="text"></param>
    public static string Quote(char quote, ReadOnlySpan<char> text)
    {
        StringBuilder sb = new(text.Length + 2);
        sb.Append(quote);
        Quote(sb, text, quote);
        sb.Append(quote);
        return sb.ToString();
    }

    internal static string Quote(char quote, ReadOnlySpan<char> text1, ReadOnlySpan<char> text2)
    {
        StringBuilder sb = new(text1.Length + text2.Length + 2);
        sb.Append(quote);
        Quote(sb, text1, quote);
        Quote(sb, text2, quote);
        sb.Append(quote);
        return sb.ToString();
    }

    internal static void Quote(StringBuilder sb, ReadOnlySpan<char> text, char quote)
    {
        if (quote is '\'')
        {
            foreach (char c in text)
            {
                if (c == quote)
                    sb.Append(c, 2);
                else
                    sb.Append(c);
            }
        }
        else if (quote is '"')
        {
            foreach (char c in text)
            {
                if (c is '"')
                    sb.Append("`\"");
                else if (c is '`')
                    sb.Append("``");
                else
                    sb.Append(c);
            }
        }
        else
        {
            sb.Append(text);
        }
    }
}
