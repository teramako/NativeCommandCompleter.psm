using System.Collections.ObjectModel;
using System.Diagnostics;
using System.Management.Automation;

namespace MT.Comp;

public class CommandCompleter
{
    [Conditional("DEBUG")]
    private void Debug(string msg)
    {
        NativeCompleter.Messages.Add($"[{Name}]: {msg}");
    }

    private const string LongParamIndicator = "--";
    private const string ParamIndicator = "-";
    private const char ValueSeparator = '=';

    public CommandCompleter(string name)
    {
        Name = name;
    }

    public string Name { get; }
    public string Description { get; set; } = description;
    public Collection<ParamCompleter> Params { get; } = [];
    public ScriptBlock? ArgumentCompleter { get; set; }

    public IEnumerable<CompletionResult> Complete(List<Token?> args, int index)
    {
        Debug($"NativeCommandCompleter.Complete: args: {string.Join(", ", args.Select(v => v is null ? "" : $"'{v}'"))}, index: {index}");
        bool completed = false;
        string paramName;

        Token? currentToken = args[index];
        string currentTokenValue = currentToken?.Value ?? string.Empty;
        int currentTokenPosition = currentToken?.Position ?? 0;

        if (currentToken is not null)
        {
            var argType = currentToken.GetTokenType();
            Debug($"CurrentToken[{index}]: {currentToken} Type: {argType}");
            switch (argType)
            {
                case TokenType.LongParameter:
                    // .. --long-param[=value]
                    //      ^^^^^^^^^^^^^^^^^^
                    paramName = currentToken.Prefix[2..];
                    currentTokenPosition -= 2;
                    foreach (var result in Params.SelectMany(param => param.CompleteLongParam(paramName, currentTokenPosition)))
                    {
                        yield return result;
                        completed = true;
                    }
                    break;
                case TokenType.ShortParameter:
                    // .. -c  or -param
                    //     ^      ^^^^^
                    paramName = currentToken.Prefix[1..];
                    currentTokenPosition -= 1;
                    Debug($"param: '{paramName}' as ShortParameter");
                    foreach (var result in Params.SelectMany(param => param.CompleteOldParam(paramName, currentTokenPosition)))
                    {
                        yield return result;
                        completed = true;
                    }
                    if (completed)
                    {
                        break;
                    }

                    foreach (var result in Params.SelectMany(param => param.CompleteShortParam(paramName, currentTokenPosition)))
                    {
                        yield return result;
                        completed = true;
                    }
                    break;
            }
        }

        if (completed)
        {
            yield break;
        }
        if (index < 2)
            yield break;

        var prevToken = args[index - 1];
        if (prevToken is not null)
        {
            var prevType = prevToken.GetTokenType();
            Debug($"PreviousToken: {prevType}");
            switch (prevType)
            {
                case TokenType.LongParameter:
                    // .. --long-param value
                    //                 ^^^^^
                    if (prevToken.Value.Contains(ValueSeparator))
                    {
                        prevType = TokenType.Value;
                        break;
                    }
                    paramName = prevToken.Value[2..];
                    foreach (var result in Params.SelectMany(param => param.CompleteValue(paramName,
                                                                                          currentTokenValue,
                                                                                          currentTokenPosition,
                                                                                          LongParamIndicator)))
                    {
                        yield return result;
                    }
                    break;
                case TokenType.ShortParameter:
                    // .. -c value
                    //       ^^^^^
                    paramName = prevToken.Value[1..];
                    IEnumerable<CompletionResult>? results = null;
                    foreach (var param in Params)
                    {
                        if (param.ArgumentCompleter is null)
                            continue;

                        if (param.OldShortNames.Contains(paramName))
                        {
                            foreach (var result in param.CompleteValue(paramName, currentTokenValue,
                                                                       currentTokenPosition,
                                                                       ParamIndicator))
                            {
                                yield return result;
                            }
                            break;
                        }
                        if (param.ShortNames.Contains(paramName[^1]))
                        {
                            foreach (var result in param.CompleteValue($"{paramName[^1]}",
                                                                       currentTokenValue,
                                                                       currentTokenPosition,
                                                                       ParamIndicator))
                            {
                                yield return result;
                            }
                            break;
                        }
                    }
                    if (results is null)
                    {
                        break;
                    }

                    foreach (var result in results)
                    {
                        yield return result;
                        completed = true;
                    }
                    break;
            }
        }

        if (completed)
        {
            yield break;
        }

        if (ArgumentCompleter is not null)
        {
            var results = ArgumentCompleter.Invoke(currentTokenValue, currentTokenValue);
            foreach (var result in NativeCompleter.PSObjectsToCompletionResults(results))
            {
                yield return result;
            }
        }
    }
}
