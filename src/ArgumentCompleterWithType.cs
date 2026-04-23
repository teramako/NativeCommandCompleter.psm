namespace MT.Comp;

/// <summary>
/// A command and parameter argument completer.
/// Generates completion candidates by <see cref="ArgumentType"/> of <see cref="Type"/>
/// </summary>
public class ArgumentCompleterWithType : ArgumentCompleterBase
{
    public override IEnumerable<CompletionData> Complete(CompletionContext context,
                                                         ReadOnlySpan<char> tokenValue,
                                                         int offsetPosition,
                                                         int argumentIndex)
    {
        return Type switch
        {
            ArgumentType.File => Helper.CompleteFilename($"{tokenValue}", $"{context.CurrentDirectory}", true, false),
            ArgumentType.Directory => Helper.CompleteFilename($"{tokenValue}", $"{context.CurrentDirectory}", true, true),
            _ => []
        };
    }
}
