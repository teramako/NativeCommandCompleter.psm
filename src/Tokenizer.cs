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
    public static IReadOnlyList<ArgumentElement> ReconstructArgv(CommandAst commandAst)
    {
        var commandLine = commandAst.ToString();
        _ = Parser.ParseInput(commandLine, null, out var tokens, out _);
        return ReconstructArgvImpl(commandLine, tokens);
    }

    /// <summary>
    /// Reconstruct command arguments from <paramref name="commandLine"/> string.
    /// <para>
    /// Generates an argument list for a native command based on the results of token analysis.
    /// </para>
    /// </summary>
    /// <param name="commandLine">Command-line string</param>
    public static IReadOnlyList<ArgumentElement> ReconstuctArgv(string commandLine)
    {
        _ = Parser.ParseInput(commandLine, null, out var tokens, out _);
        return ReconstructArgvImpl(commandLine, tokens);
    }

    private static IReadOnlyList<ArgumentElement> ReconstructArgvImpl(string commandLine, Token[] tokens)
    {
        ArgumentOutOfRangeException.ThrowIfLessThanOrEqual(tokens.Length, 1, nameof(tokens));

        var builder = ImmutableArray.CreateBuilder<ArgumentElement>();

        int start = 1;
        int index = 1;

        bool inArray = false;
        bool inVariable = false;

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
        }

        void HandleBalancedParen()
        {
            if ((inArray || inVariable) && !IsWhitespaceBefore(tokens[index]))
            {
                index = ScanBalancedExpression();
            }
            else
            {
                FlushCurrent();
                (start, index) = (index, ScanBalancedExpression());
                if (!IsArrayLiteralAhead(index))
                {
                    builder.Add(new(commandLine, tokens[start..(index+1)].ToImmutableArray(), inArray));
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
            else if (inVariable)
            {
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
            if (inArray && !IsWhitespaceBefore(tokens[index]))
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
                builder.Add(new(tokens[index]));
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
                inArray = true;
            }
        }
        void HandleVariable()
        {
            if (IsWhitespaceBefore(tokens[index]))
            {
                FlushCurrent();
                start = index;
            }
            inVariable = true;
        }

        void FlushCurrent()
        {
            if (start < index)
            {
                builder.Add(new(commandLine, tokens[start..index].ToImmutableArray(), inArray));
                inArray = false;
                inVariable = false;
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

    private static int ScanBalancedExpression(Token[] tokens, int index, TokenKind endKind, params scoped ReadOnlySpan<TokenKind> startKinds)
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
