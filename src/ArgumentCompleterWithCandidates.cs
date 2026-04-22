namespace MT.Comp;

/// <summary>
/// A command and parameter argument completer.
/// Can register static completion suggestions.
/// </summary>
public class ArgumentCompleterWithCandidates : ArgumentCompleterBase
{
    /// <summary>
    /// Array of static completion candidates
    /// </summary>
    public required CompletionValue[] Candidates { get; init; }

    public override IEnumerable<CompletionData> Complete(CompletionContext context,
                                                         ReadOnlySpan<char> tokenValue,
                                                         int offsetPosition,
                                                         int argumentIndex)
    {
        string arg = $"{tokenValue}";
        return Candidates.Where(data => data.IsMatch(arg, ignoreCase: true));
    }
}
