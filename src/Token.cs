using System.Management.Automation.Language;

namespace MT.Comp;

[Flags]
public enum TokenType
{
    Value = 1 << 0,
    ShortParameter = 1 << 1,
    LongParameter = 1 << 2,
}

public class Token
{
    public const string LongParamIndicator = "--";
    public const string ParamIndicator = "-";
    public const char ValueSeparator = '=';

    public Token(CommandElementAst ast)
    {
        _ast = ast;
    }
    public Token(CommandElementAst ast, int cursorPosition)
    {
        _ast = ast;
        Position = cursorPosition - ast.Extent.StartOffset;
        IsTarget = true;
    }

    private CommandElementAst _ast;
    public bool IsTarget { get; }
    public int Position { get; set; }
    public string Value => _ast.Extent.Text;

    public string Prefix => Position > 0 ? Value[0..Position] : Value;
    public string Suffix => Position > 0 ? Value[Position..] : string.Empty;

    public override string ToString() => Value;

    public TokenType GetTokenType()
    {
        if (Value.StartsWith(LongParamIndicator, StringComparison.Ordinal))
        {
            return TokenType.LongParameter;
        }
        else if (Value.StartsWith(ParamIndicator, StringComparison.Ordinal))
        {
            return TokenType.ShortParameter;
        }
        return TokenType.Value;
    }
}
