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
        if (!Type.HasFlag(ArgumentType.File)
            && !Type.HasFlag(ArgumentType.Directory))
        {
            return [];
        }
        bool onlyDirectory = !Type.HasFlag(ArgumentType.File);
        return Helper.CompleteFilename(context, true, onlyDirectory);
    }
}
