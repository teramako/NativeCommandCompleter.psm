namespace Sabamiso;

/// <summary>
/// A command and parameter argument completer.
/// Generates completion candidates by <see cref="ArgumentType"/> of <see cref="Type"/>
/// </summary>
public class ArgumentCompleterWithType : ArgumentCompleterBase
{
    /// <summary>
    /// The arument's type
    /// </summary>
    public ArgumentType Type { get; init; }

    public override IEnumerable<CompletionData> Complete(CompletionContext context,
                                                         ReadOnlySpan<char> wordToComplete,
                                                         int offsetPosition,
                                                         int argumentIndex)
    {
        return Type switch
        {
            ArgumentType.File => Helper.CompleteFilename($"{wordToComplete}", context.CurrentDirectory, true, false),
            ArgumentType.Directory => Helper.CompleteFilename($"{wordToComplete}", context.CurrentDirectory, true, true),
            ArgumentType.Command or ArgumentType.DelegatingCommand => Helper.CompleteCommandOrFilename(context),
            _ => []
        };
    }
}
