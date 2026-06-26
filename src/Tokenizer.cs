using System.Collections.Immutable;
using System.Management.Automation.Language;

namespace Sabamiso;

public static class Tokenizer
{
    public readonly record struct Result(ImmutableArray<ArgumentElement> Arguments,
                                         ImmutableArray<ArgumentElement> Redirections);

    /// <summary>
    /// Reconstruct command arguments from <paramref name="commandAst"/>.
    /// <para>
    /// Generates an argument list for a native command based on the results of token analysis.
    /// </para>
    /// </summary>
    /// <param name="commandAst">AST built by PowerShell</param>
    public static Result ReconstructArgv(CommandAst commandAst, out ImmutableArray<Token> immutableTokens)
    {
        var commandLine = commandAst.ToString();
        _ = Parser.ParseInput(commandLine, null, out var tokens, out _);
        immutableTokens = tokens.ToImmutableArray();
        return ReconstructArgvImpl(commandLine, immutableTokens);
    }

    /// <summary>
    /// Reconstruct command arguments from <paramref name="commandLine"/> string.
    /// <para>
    /// Generates an argument list for a native command based on the results of token analysis.
    /// </para>
    /// </summary>
    /// <param name="commandLine">Command-line string</param>
    public static Result ReconstructArgv(string commandLine, out ImmutableArray<Token> immutableTokens)
    {
        _ = Parser.ParseInput(commandLine, null, out var tokens, out _);
        immutableTokens = tokens.ToImmutableArray();
        return ReconstructArgvImpl(commandLine, immutableTokens);
    }

    [Flags]
    private enum State
    {
        InArray    = 1 << 0,
        InVariable = 1 << 1,
        InBracket  = 1 << 2,
        InDot      = 1 << 3,
        InRedirection = 1 << 4,
        InIndex    = InVariable | InBracket,
        InMember   = InVariable | InDot,
    }

    private static Result ReconstructArgvImpl(string commandLine, ImmutableArray<Token> tokens)
    {
        ArgumentOutOfRangeException.ThrowIfLessThanOrEqual(tokens.Length, 1, nameof(tokens));

        var argvBuilder = ImmutableArray.CreateBuilder<ArgumentElement>();
        var redirectionsBuilder = ImmutableArray.CreateBuilder<ArgumentElement>();
        var arrayRangeBuilder = ImmutableArray.CreateBuilder<Range>();

        int start = 1;
        int index = 1;
        int arrayStart = 1;

        State state = default;

        while (index < tokens.Length)
        {
            var token = tokens[index];

            switch (token.Kind)
            {
                case TokenKind.EndOfInput or TokenKind.NewLine:
                    goto endLoop;
                case TokenKind.LParen or TokenKind.AtParen or TokenKind.DollarParen:
                    HandleBalancedParen();
                    break;
                case TokenKind.LCurly or TokenKind.AtCurly:
                    HandleBalancedCurly();
                    break;
                case TokenKind.LBracket:
                    HandleBalancedBracket();
                    break;
                case TokenKind.StringLiteral or TokenKind.StringExpandable:
                    HandleString();
                    break;
                case TokenKind.Comma:
                    HandleComma();
                    break;
                case TokenKind.Dot:
                    HandleDot();
                    break;
                case TokenKind.Variable:
                    HandleVariable();
                    break;
                case TokenKind.Redirection:
                    HandleRedirection();
                    break;
                default:
                    HandleDefault();
                    break;
            }

            index++;
        }
        endLoop:

        FlushCurrent();

        // Cases where the command-line ends with a redirection token like `>` (no file path)
        if (state.HasFlag(State.InRedirection) && start > 0)
            AddRedirection(start - 1, start - 1);

        return new(argvBuilder.ToImmutableArray(), redirectionsBuilder.ToImmutableArray());

        // ---------------------------------------------------------------------
        // Helper functions
        // ---------------------------------------------------------------------

        bool IsWhitespaceBefore(Token t)
            => t.Extent.StartOffset > 0 && char.IsWhiteSpace(commandLine[t.Extent.StartOffset - 1]);

        void HandleDefault()
        {
            if (IsWhitespaceBefore(tokens[index]))
            {
                FlushCurrent();
                start = index;
            }
            else if (state is State.InVariable or State.InIndex)
            {
                FlushCurrent();
                start = index;
            }
        }

        void HandleBalancedParen()
        {
            if ((state.HasFlag(State.InArray) || state.HasFlag(State.InMember)) && !IsWhitespaceBefore(tokens[index]))
            {
                index = ScanBalancedExpression();
            }
            else
            {
                FlushCurrent();
                (start, index) = (index, ScanBalancedExpression());
                if (!IsArrayLiteralAhead(index))
                {
                    Add(start, index, state.HasFlag(State.InArray) ? arrayRangeBuilder.ToImmutable() : null);
                    state = default;
                    arrayRangeBuilder.Clear();
                    start = index + 1;
                }
            }
        }
        void HandleBalancedCurly()
        {
            if (IsWhitespaceBefore(tokens[index]))
            {
                FlushCurrent();
                (start, index) = (index, ScanBalancedExpression());
            }
            else
            {
                index = ScanBalancedExpression();
            }
        }
        void HandleBalancedBracket()
        {
            if (IsWhitespaceBefore(tokens[index]))
            {
                FlushCurrent();
                start = index;
            }
            else if (state.HasFlag(State.InVariable))
            {
                state &= ~State.InDot;
                state |= State.InIndex;
                index = ScanBalancedExpression();
            }
        }

        int ScanBalancedExpression()
        {
            return tokens[index].Kind switch
            {
                TokenKind.LCurly or TokenKind.AtCurly
                    => Tokenizer.ScanBalancedExpression(tokens, index, TokenKind.RCurly, [TokenKind.LCurly, TokenKind.AtCurly]),
                TokenKind.LBracket
                    => Tokenizer.ScanBalancedExpression(tokens, index, TokenKind.RBracket, [TokenKind.LBracket]),
                TokenKind.LParen or TokenKind.AtParen or TokenKind.DollarParen
                    => Tokenizer.ScanBalancedExpression(tokens, index, TokenKind.RParen, [TokenKind.LParen, TokenKind.AtParen, TokenKind.DollarParen]),
                _ =>
                    throw new NotImplementedException()
            };
        }

        void HandleString()
        {
            if (state.HasFlag(State.InArray) && !IsWhitespaceBefore(tokens[index]))
            {
                return;
            }
            else if (state.HasFlag(State.InMember))
            {
                return;
            }

            FlushCurrent();

            if (IsArrayLiteralAhead(index))
            {
                start = index;
            }
            else
            {
                Add(index, index);
                start = index + 1;
            }
        }
        void HandleComma()
        {
            if (IsWhitespaceBefore(tokens[index]))
            {
                FlushCurrent();
                start = index;
            }
            else
            {
                if (state.HasFlag(State.InArray))
                {
                    arrayRangeBuilder.Add(arrayStart..index);
                }
                else
                {
                    arrayRangeBuilder.Add(start..index);
                    state |= State.InArray;
                }
                arrayStart = index + 1;
            }
        }
        void HandleVariable()
        {
            if (IsWhitespaceBefore(tokens[index]))
            {
                FlushCurrent();
                start = index;
            }
            state |= State.InVariable;
        }
        void HandleDot()
        {
            state &= State.InBracket | State.InRedirection;
            state |= State.InMember;
        }

        void HandleRedirection()
        {
            FlushCurrent();

            // e.g) `2>&1`
            if (tokens[index] is MergingRedirectionToken)
            {
                AddRedirection(index, index);
                start = index + 1;
                return;
            }

            // FileRedirectionToken:
            // Only set the flag and skip the rest here. The redirection check is performed in Add() function.
            state = State.InRedirection;
            start = index + 1;
        }

        void FlushCurrent()
        {
            if (start < index)
            {
                if (state.HasFlag(State.InArray) && arrayStart < index)
                {
                    arrayRangeBuilder.Add(arrayStart..index);
                }
                Add(start, index - 1, state.HasFlag(State.InArray) ? arrayRangeBuilder.ToImmutable() : null);
            }
        }

        bool IsArrayLiteralAhead(int tokenIndex)
        {
            if (tokenIndex + 1 < tokens.Length && tokens[tokenIndex + 1].Kind is TokenKind.Comma)
            {
                int end = tokens[tokenIndex].Extent.EndOffset;
                return end < commandLine.Length && !char.IsWhiteSpace(commandLine[end]);
            }
            return false;
        }

        void Add(int start, int end, ImmutableArray<Range>? arrayRanges = null)
        {
            // Check if the previous token is a "Redirection"
            if (state.HasFlag(State.InRedirection) && start > 0 && tokens[start - 1].Kind is TokenKind.Redirection)
            {
                AddRedirection(start - 1, end, arrayRanges);
                return;
            }

            if (end - start == 0 && arrayRanges is null)
            {
                argvBuilder.Add(ArgumentElement.Create(tokens[start], start));
            }
            else
            {
                argvBuilder.Add(ArgumentElement.Create(commandLine, start, end, tokens, arrayRanges));
            }
            state = default;
            arrayRangeBuilder.Clear();
        }

        void AddRedirection(int start, int end, ImmutableArray<Range>? arrayRanges = null)
        {
            if (end - start == 0 && arrayRanges is null)
            {
                redirectionsBuilder.Add(ArgumentElement.Create(tokens[start], start));
            }
            else
            {
                redirectionsBuilder.Add(ArgumentElement.Create(commandLine, start, end, tokens, arrayRanges));
            }
            state = default;
            arrayRangeBuilder.Clear();
        }
    }

    private static int ScanBalancedExpression(in ImmutableArray<Token> tokens, int index, TokenKind endKind, params scoped ReadOnlySpan<TokenKind> startKinds)
    {
        int level = 0;
        for (index += 1; index < tokens.Length; index++)
        {
            var t = tokens[index];
            if (startKinds.Contains(t.Kind))
            {
                level++;
            }
            else if (t.Kind == endKind)
            {
                if (level > 0)
                    level--;
                else
                    return index;
            }
        }
        return index;
    }
}
