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
            else if (text[0] is '@' or '$')
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

    /// <summary>
    /// Represents the result of resolving a list element within a separated string.
    /// </summary>
    /// <param name="Index">
    /// The zero-based index of the element within the list. A negative value indicates that
    /// the position does not correspond to any element.
    /// </param>
    /// <param name="OffsetPosition">
    /// The cursor position relative to the start of the resolved element (0-based).
    /// The value is clamped to the range of the trimmed element.
    /// </param>
    /// <param name="Range">
    /// The <see cref="Range"/> representing the start and end positions of the trimmed element
    /// within the original input string.
    /// </param>
    public readonly record struct ListElementResult(int Index, int OffsetPosition, Range Range)
    {
        public string Slice(string source) => source[Range];
        public ReadOnlySpan<char> Slice(ReadOnlySpan<char> source) => source[Range];
    }

    /// <summary>
    /// Resolves the list element that contains the specified cursor position within a
    /// separator-delimited string.
    /// </summary>
    /// <param name="value">
    /// The input span that may contain multiple elements separated by the specified separator.
    /// </param>
    /// <param name="position">
    /// The cursor position within <paramref name="value"/> (0-based).
    /// Must be within the range <c>[0, value.Length]</c>.
    /// </param>
    /// <param name="separator">
    /// The character used to separate elements in the list. The default is a comma (<c>,</c>).
    /// </param>
    /// <returns>
    /// A <see cref="ListElementResult"/> containing:
    /// <list type="bullet">
    /// <item><description>The index of the resolved element.</description></item>
    /// <item><description>The cursor position relative to the trimmed element.</description></item>
    /// <item><description>The <see cref="Range"/> of the trimmed element.</description></item>
    /// </list>
    /// </returns>
    /// <remarks>
    /// <para>
    /// This method scans the input span, identifies element boundaries based on the specified
    /// separator, and determines which element the cursor position belongs to.
    /// </para>
    /// <para>
    /// Leading and trailing whitespace around each element is trimmed when computing the
    /// returned <see cref="Range"/> and relative cursor position.
    /// </para>
    /// <para>
    /// If the cursor position falls outside the trimmed element but within its untrimmed
    /// boundaries, the relative position is clamped to the nearest valid offset.
    /// </para>
    /// </remarks>
    /// <exception cref="ArgumentOutOfRangeException">
    /// Thrown when <paramref name="position"/> is outside the range of the input span.
    /// </exception>
    public static ListElementResult ResolveListElement(ReadOnlySpan<char> value,
                                                       int position = 0,
                                                       char separator = ',')
    {
        ArgumentOutOfRangeException.ThrowIfNegative(position);
        ArgumentOutOfRangeException.ThrowIfGreaterThan(position, value.Length);

        int start = 0;
        int index = 0;
        int elemStart, elemEnd, offset;
        for (int i = 0; i < value.Length; i++)
        {
            if (value[i] == separator)
            {
                int end = i;

                if (position <= end)
                {
                    elemStart = start;
                    elemEnd = end;

                    // trim-left
                    while (elemStart < elemEnd && char.IsWhiteSpace(value[elemStart]))
                        elemStart++;

                    // trim-right
                    while (elemEnd > elemStart && char.IsWhiteSpace(value[elemEnd - 1]))
                        elemEnd--;

                    offset = Math.Clamp(position, elemStart, elemEnd) - elemStart;
                    return new(index, offset, elemStart .. elemEnd);
                }

                index++;
                start = i + 1;

                // trim-left for next element
                while (start < value.Length && char.IsWhiteSpace(value[start]))
                    start++;
            }
        }

        // last element
        elemStart = start;
        elemEnd = value.Length;

        while (elemStart < elemEnd && char.IsWhiteSpace(value[elemStart]))
            elemStart++;

        while (elemEnd > elemStart && char.IsWhiteSpace(value[elemEnd - 1]))
            elemEnd--;

        offset = Math.Clamp(position, elemStart, elemEnd) - elemStart;

        return new(index, offset, elemStart .. elemEnd);
    }
}
