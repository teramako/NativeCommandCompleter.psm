using System.Collections.Immutable;
using System.Management.Automation.Language;

namespace Sabamiso;

public static class Tokenizer
{
    /// <summary>
    /// Reconstruct command arguments from <paramref name="commandAst"/>.
    /// <para>
    /// Generates an argument list for a native command based on the results of token analysis.
    /// </para>
    /// </summary>
    /// <param name="commandAst">AST built by PowerShell</param>
    public static ImmutableArray<ArgumentElement> ReconstructArgv(CommandAst commandAst, out ImmutableArray<Token> immutableTokens)
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
    public static ImmutableArray<ArgumentElement> ReconstructArgv(string commandLine, out ImmutableArray<Token> immutableTokens)
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
        InIndex    = InVariable | InBracket,
        InMember   = InVariable | InDot,
    }

    private static ImmutableArray<ArgumentElement> ReconstructArgvImpl(string commandLine, ImmutableArray<Token> tokens)
    {
        ArgumentOutOfRangeException.ThrowIfLessThanOrEqual(tokens.Length, 1, nameof(tokens));

        var builder = ImmutableArray.CreateBuilder<ArgumentElement>();
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
                default:
                    HandleDefault();
                    break;
            }

            index++;
        }
        endLoop:

        FlushCurrent();
        return builder.ToImmutableArray();

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
                    builder.Add(ArgumentElement.Create(commandLine, start, index, tokens, state.HasFlag(State.InArray) ? arrayRangeBuilder.ToImmutable() : null));
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
                builder.Add(ArgumentElement.Create(tokens[index], index));
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
            state &= State.InBracket;
            state |= State.InMember;
        }

        void FlushCurrent()
        {
            if (start < index)
            {
                if (state.HasFlag(State.InArray) && arrayStart < index)
                {
                    arrayRangeBuilder.Add(arrayStart..index);
                }
                builder.Add(ArgumentElement.Create(commandLine, start, index - 1, tokens, state.HasFlag(State.InArray) ? arrayRangeBuilder.ToImmutable() : null));
                state = default;
                arrayRangeBuilder.Clear();
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
