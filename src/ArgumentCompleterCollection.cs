using System.Collections.ObjectModel;
using System.Text;

namespace MT.Comp;

/// <summary>
/// <see cref="IArgumentCompleter"/> 's container
/// </summary>
public class ArgumentCompleterCollection : Collection<IArgumentCompleter>
{
    /// <exception cref="ArgumentException"/>
    public static ArgumentCompleterCollection Create(params IEnumerable<IArgumentCompleter> completers)
    {
        ArgumentCompleterCollection result = [];
        foreach (var ac in completers)
        {
            result.Add(ac);
        }
        return result;
    }

    /// <summary>
    /// Total Nargs range of the arguments
    /// </summary>
    public Nargs Nargs { get; private set; }

    /// <summary>
    /// Append an argument completer
    /// </summary>
    /// <exception cref="ArgumentException"/>
    public new void Add(IArgumentCompleter ac)
    {
        if (Count > 0)
        {
            var lastAc = this[^1];
            if (lastAc.Remainings)
            {
                throw new ArgumentException($"Could not add because the last completer's `Remaining` flag is set: {lastAc}");
            }
            if (!lastAc.Required && ac.Required)
            {
                throw new ArgumentException($"Cound not add a required item after a non-required item.");

            }
        }
        base.Add(ac);
        Nargs += ac.Nargs;
    }

    public override string ToString()
    {
        StringBuilder sb = new();
        PrintSyntax(sb);
        return sb.ToString();
    }

    /// <summary>
    /// Writes fragments of the argument portions of command and parameter syntax.
    /// </summary>
    public void PrintSyntax(StringBuilder sb)
    {
        if (Count == 0)
            return;

        int optionalLevel = 0;
        int i = 0;
        foreach (var ac in this)
        {
            if (i++ > 0)
                sb.Append(' ');

            var name = ac.List ? $"{ac.Name}[,…]" : ac.Name;
            if (!ac.Required)
            {
                sb.Append('[')
                  .Append(name);
                optionalLevel++;
            }
            else
            {
                sb.AppendJoin(' ', Enumerable.Repeat(name, ac.Nargs.MinCount));
            }
            if (ac.Remainings)
            {
                sb.Append(" …");
            }
            else if (ac.Nargs.MaxCount > ac.Nargs.MinCount)
            {
                sb.Append('[')
                  .AppendJoin(' ', Enumerable.Repeat(name, ac.Nargs.MaxCount - ac.Nargs.MinCount))
                  .Append(']');
            }
        }
        sb.Append(']', optionalLevel);
    }

    /// <summary>
    /// Get the complement corresponding to the argument <paramref name="argumentIndex"/>
    /// </summary>
    /// <param name="argumentIndex"></param>
    public IArgumentCompleter? GetByArgumentIndex(int argumentIndex = 0)
    {
        if (Count == 0)
            return null;
        int offsetIndex = argumentIndex;
        foreach (var ac in this)
        {
            if (ac.Nargs.IsIndexAllowd(offsetIndex))
            {
                return ac;
            }
            offsetIndex -= ac.Nargs.MaxCount;
        }

        return null;
    }
}
