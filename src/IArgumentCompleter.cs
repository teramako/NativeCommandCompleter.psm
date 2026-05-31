namespace Sabamiso;

/// <summary>
/// Interface for argument completers, which provides completion candidates for command and parameter arguments.
/// </summary>
public interface IArgumentCompleter
{
    /// <summary>
    /// Variable name
    /// </summary>
    string Name { get; }

    /// <summary>
    /// The argment's description
    /// </summary>
    string Description { get; }

    /// <summary>
    /// Represents a constraint on the number of argument values accepted by a parameter.
    /// </summary>
    Nargs Nargs { get; }

    /// <summary>
    /// Indicates that the argument is a comma-separated list
    /// </summary>
    bool List { get; }

    /// <summary>
    /// Returns completion candidates for the argument
    /// </summary>
    /// <param name="context">The completion context</param>
    /// <param name="wordToComplete">The word to be completed</param>
    /// <param name="offsetPosition">The offset position of the <paramref name="wordToComplete"/></param>
    /// <param name="argumentIndex">The index of the argument in the command</param>
    /// <returns>Completion candidates</returns>
    IEnumerable<CompletionData> Complete(CompletionContext context, ReadOnlySpan<char> wordToComplete, int offsetPosition, int argumentIndex);
}
