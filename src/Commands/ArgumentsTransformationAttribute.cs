using System.Collections;
using System.Management.Automation;

namespace Sabamiso.Commands;

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
        switch (inputData)
        {
            case IList list:
                foreach (var item in list)
                {
                    if (item is null)
                        continue;
                    results.Add(ConvertToArgumentCompleter(item));
                }
                break;
            default:
                results.Add(ConvertToArgumentCompleter(inputData));
                break;

        }

        return results;
    }

    public static IArgumentCompleter ConvertToArgumentCompleter(object obj)
    {
        switch (obj)
        {
            case IArgumentCompleter ac:
                return ac;
            case string str:
                return new ArgumentCompleterWithType { Name = str };
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
