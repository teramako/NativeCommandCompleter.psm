using System.Management.Automation;

namespace MT.Comp;

public static class Helper
{
    public static IEnumerable<CompletionData> CompleteFilename(string wordToComplete, PathInfo cwd)
    {
        bool isAbsolutePath = Path.IsPathFullyQualified(wordToComplete) || wordToComplete.StartsWith('~');
        if (string.IsNullOrEmpty(wordToComplete))
            wordToComplete = $".{Path.DirectorySeparatorChar}";

        string path = isAbsolutePath
            ? wordToComplete
            : Path.Combine(cwd.Path, wordToComplete);

        foreach (var result in CompletionCompleters.CompleteFilename($"FileSystem::{path}"))
        {
            var text = result.ToolTip;
            if (!isAbsolutePath)
            {
                var relativePath = Path.GetRelativePath(cwd.Path, text);
                if (relativePath == ".")
                {
                    text = $"..{Path.DirectorySeparatorChar}{result.ListItemText}";
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
            var desc = result.ResultType switch
            {
                CompletionResultType.ProviderItem => "File",
                CompletionResultType.ProviderContainer => "Directory",
                _ => string.Empty
            };

            if (text.Contains(' '))
            {
                text = $"'{text}'";
            }
            
            yield return new CompletionValue(text, desc, result.ListItemText, result.ToolTip, result.ResultType);
        }
    }
}
