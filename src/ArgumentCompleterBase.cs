namespace Sabamiso;

/// <summary>
/// Base class for argument completers, which provides completion candidates for command and parameter arguments.
/// </summary>
public abstract class ArgumentCompleterBase : IArgumentCompleter
{
    public required string Name { get; init; }
    public string Description { get; set; } = string.Empty;
    public Nargs Nargs { get; init; } = Nargs.One;
    public bool Required => Nargs.MinCount > 0;
    public bool Remainings => Nargs.ConsumeRest;
    public bool List { get; init; } = false;
    public abstract IEnumerable<CompletionData> Complete(CompletionContext context, ReadOnlySpan<char> tokenValue, int offsetPosiion, int argumentIndex);
    public override string ToString()
    {
        return $"ArgumentCompleter {{ Name = {Name}, Nargs = {Nargs} }}";
    }
}
