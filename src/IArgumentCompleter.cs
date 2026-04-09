namespace MT.Comp;

public interface IArgumentCompleter
{
    /// <summary>
    /// Variable name
    /// </summary>
    string Name { get; init; }
    string Description { get; set; }
    bool Required { get; init; }
    bool Remainings { get; init; }

    IEnumerable<CompletionData> Complete(CompletionContext context, string tokenValue, int offsetPosition, int argumentIndex);
    string ToString();
}
