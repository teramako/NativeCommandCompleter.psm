using System.Management.Automation.Language;

namespace MT.Comp;

public class Token
{
    public Token(CommandElementAst ast)
    {
        _ast = ast;
        Position = ast.Extent.Text.Length;
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
}
