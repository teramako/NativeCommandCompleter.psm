using System.Collections;
using System.Management.Automation;

namespace MT.Comp.Commands;

/// <summary>
/// Converts values of various types into a <seealso cref="ArgumentCompleterCollection"/>.
/// </summary>
public class ArgumentsTransformationAttribute : ArgumentTransformationAttribute
{
    private const string COMPLEX_TYPES_EXCEPTION = """
        Argumets must be a `(string|CompletionData)[]` or list of `ArgumentCompleter|ScriptBlock|(string|CompletionData)[]`
        """;
    private const string COULD_NOT_CONVERT_TO = """
        Could not convert to IArgumentCompleter
        """;

    public override object Transform(EngineIntrinsics engineIntrinsics, object inputData)
    {
        if (inputData is PSObject pso)
            inputData = pso.BaseObject;

        ArgumentCompleterCollection results = [];
        IArgumentCompleter ac;
        switch (inputData)
        {
            case IList list:
                List<CompletionValue> bufList = [];
                bool processingCompletionData = false;
                bool processingCompleter = false;
                for (int i = 0; i < list.Count; i++)
                {
                    var item = list[i];
                    switch (item)
                    {
                        case null:
                            break;
                        case CompletionValue data:
                            if (processingCompleter)
                                throw new ArgumentException(COMPLEX_TYPES_EXCEPTION);

                            bufList.Add(data);
                            processingCompletionData = true;
                            break;
                        case string str:
                            if (processingCompleter)
                                throw new ArgumentException(COMPLEX_TYPES_EXCEPTION);

                            bufList.Add(CompletionValue.Parse(str));
                            processingCompletionData = true;
                            break;
                        default:
                            if (processingCompletionData)
                                throw new ArgumentException(COMPLEX_TYPES_EXCEPTION);

                            results.Add(ConvertToArgumentCompleter(item, $"{i + 1}"));
                            break;
                    }
                }
                if (bufList.Count > 0)
                {
                    ac = new ArgumentCompleterWithCandidates()
                    {
                        Name = "arg", 
                        Candidates = bufList.ToArray()
                    };
                    results.Add(ac);
                }
                break;
            default:
                results.Add(ConvertToArgumentCompleter(inputData));
                break;

        }

        return results.ToArray();
    }

    public static IArgumentCompleter ConvertToArgumentCompleter(object obj, string suffix = "")
    {
        switch (obj)
        {
            case IArgumentCompleter ac:
                return ac;
            case string str:
                return new ArgumentCompleterWithCandidates()
                {
                    Name = $"arg{suffix}",
                    Candidates = [CompletionValue.Parse(str)]
                };
            case ScriptBlock sb:
                return new ArgumentCompleterWithScript()
                {
                    Name = $"arg{suffix}",
                    Script = sb
                };
            case IList list:
                object[] arr = [..list];
                return new ArgumentCompleterWithCandidates()
                {
                    Name = $"arg{suffix}",
                    Candidates = arr.Select(obj => obj switch
                                            {
                                                CompletionValue data => data,
                                                string str => CompletionValue.Parse(str),
                                                _ => CompletionValue.Parse($"{obj}")
                                            })
                                    .ToArray()
                };
            case IDictionary dict:
                if (LanguagePrimitives.TryConvertTo<ArgumentCompleterWithType>(dict, out var acType))
                {
                    return acType;
                }
                else if (LanguagePrimitives.TryConvertTo<ArgumentCompleterWithScript>(dict, out var acScript))
                {
                    return acScript;
                }
                else if (LanguagePrimitives.TryConvertTo<ArgumentCompleterWithCandidates>(dict, out var acList))
                {
                    return acList;
                }
                break;
        }
        throw new ArgumentException($"{COULD_NOT_CONVERT_TO}: {obj}");
    }
}
