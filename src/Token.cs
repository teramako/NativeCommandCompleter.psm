using System.Management.Automation.Language;

namespace MT.Comp;

public class Token
{
    public Token(CommandElementAst ast, int cursorPosition)
    {
        Ast = ast;
        int offset = 0;
        if (ast is StringConstantExpressionAst stringAst)
        {
            Value = stringAst.Value;
            offset = stringAst.StringConstantType switch
            {
                StringConstantType.SingleQuoted or StringConstantType.DoubleQuoted => 1,
                StringConstantType.SingleQuotedHereString or StringConstantType.DoubleQuotedHereString=> 2,
                _ => 0
            };
        }
        else
        {
            Value = ast.Extent.Text;
        }
        if (ast.Extent.StartOffset < cursorPosition && cursorPosition <= ast.Extent.EndOffset)
        {
            IsTarget = true;
            Position = cursorPosition - ast.Extent.StartOffset - offset;
        }
        else
        {
            Position = Value.Length;
        }
    }

    public CommandElementAst Ast { get; }
    public bool IsTarget { get; private set; }
    public int Position { get; private set; }
    public string Value { get; private set; }

    public string Prefix => Position > 0 ? Value[0..Position] : Value;
    public string Suffix => Position > 0 ? Value[Position..] : string.Empty;

    public override string ToString() => Value;

    internal void Append(CommandElementAst ast, int cursorPosition)
    {
        string newValue;
        int offset = 0;
        if (ast is StringConstantExpressionAst stringAst)
        {
            newValue = Value + stringAst.Value;
            offset = stringAst.StringConstantType switch
            {
                StringConstantType.SingleQuoted or StringConstantType.DoubleQuoted => 1,
                StringConstantType.SingleQuotedHereString or StringConstantType.DoubleQuotedHereString=> 2,
                _ => 0
            };
        }
        else
        {
            newValue = Value + ast.Extent.Text;
        }
        if (ast.Extent.StartOffset < cursorPosition && cursorPosition <= ast.Extent.EndOffset)
        {
            Position = Value.Length + (cursorPosition - ast.Extent.StartOffset - offset);
            IsTarget = true;
        }
        if (!IsTarget)
        {
            Position = newValue.Length;
        }
        Value = newValue;
    }
}
