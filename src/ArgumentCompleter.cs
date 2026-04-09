using System.Management.Automation;
using System.Collections.ObjectModel;

namespace MT.Comp;

public abstract class ArgumentCompleter : IArgumentCompleter
{
    public required string Name { get; init; }
    public string Description { get; set; } = "";
    public bool Required { get; init; } = true;
    public bool Remainings { get; init; } = false;
    public override string ToString()
    {
        return Remainings ? $"{Name} …" : Name;
    }
    public abstract IEnumerable<CompletionData> Complete(CompletionContext context, string tokenValue, int offsetPosition, int argumentIndex);
}

public class ArgumentCompleterScript : ArgumentCompleter
{
    public required ScriptBlock Script { get; init; }

    public override IEnumerable<CompletionData> Complete(CompletionContext context,
                                                         string tokenValue,
                                                         int offsetPosition,
                                                         int argumentIndex)
    {
        Collection<PSObject?>? invokeResults = null;
        try
        {
            invokeResults = Script.GetNewClosure()
                                  .InvokeWithContext(null,
                                                     [new("_", tokenValue), new("this", context)],
                                                     offsetPosition,
                                                     argumentIndex);
            return NativeCompleter.PSObjectsToCompletionData(invokeResults);
        }
        catch
        {
        }
        return [];
    }
}

public class ArgumentCompleterList : ArgumentCompleter
{
    public required string[] Candidates { get; init; }

    public override IEnumerable<CompletionData> Complete(CompletionContext context,
                                                         string tokenValue,
                                                         int offsetPosition,
                                                         int argumentIndex)
    {
        return Candidates.Select(val => CompletionValue.Parse(val, null))
                         .Where(data => data.IsMatch(tokenValue, ignoreCase: true));
    }
}
