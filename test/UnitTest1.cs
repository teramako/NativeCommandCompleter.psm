namespace Sabamiso.Test;

public class TokenizerTest
{
    [Theory]
    [InlineData("cmd a b c", new[] { "a", "b", "c" }, new[] { "a", "b", "c" })]
    [InlineData("cmd 'a'", new[] { "'a'" }, new[] { "a" }, new[] { ArgumentElementType.StringSingleQuoted })]
    [InlineData("cmd \"a\"", new[] { "\"a\"" }, new[] { "a" }, new[] { ArgumentElementType.StringDoubleQuoted })]
    [InlineData("cmd a'b'", new[] { "a'b'" }, new[] { "ab" }, new[] { ArgumentElementType.String })]
    [InlineData("cmd a\"b\"", new[] { "a\"b\"" }, new[] { "ab" }, new[] { ArgumentElementType.String })]
    [InlineData("cmd 'a'b", new[] { "'a'", "b" }, new[] { "a", "b" }, new[] { ArgumentElementType.StringSingleQuoted, ArgumentElementType.String })]
    [InlineData("cmd \"a\"b", new[] { "\"a\"", "b" }, new[] { "a", "b" }, new[] { ArgumentElementType.StringDoubleQuoted, ArgumentElementType.String })]
    [InlineData("cmd -i.bak file", new[] { "-i.bak", "file" }, null, new[] { ArgumentElementType.String, ArgumentElementType.String })]
    [InlineData("cmd (1,2,3)", new[] { "(1,2,3)" }, null, new[] { ArgumentElementType.NestedExpression })]
    [InlineData("cmd foo@(1,2,3)", new[] { "foo@", "(1,2,3)" }, null, new[] { ArgumentElementType.String, ArgumentElementType.NestedExpression })]
    [InlineData("cmd (1,(2,3),4)", new[] { "(1,(2,3),4)" }, null, new[] { ArgumentElementType.NestedExpression })]
    [InlineData("cmd {Write-Host hi}", new[] { "{Write-Host hi}" }, null, new[] { ArgumentElementType.String })]
    [InlineData("cmd -a{}b", new[] { "-a{}b" }, null, new[] { ArgumentElementType.String })]
    [InlineData("cmd @{a=1;b=2}", new[] { "@{a=1;b=2}" }, null, new[] { ArgumentElementType.HashtableExpression })]
    [InlineData("cmd foo$(1+2)bar", new[] { "foo$(1+2)bar" }, null, new[] { ArgumentElementType.String })]
    [InlineData("cmd $(1+2)bar", new[] { "$(1+2)", "bar" }, null, new[] { ArgumentElementType.NestedExpression, ArgumentElementType.String })]
    [InlineData("cmd \"foo$(1+2)bar\"", new[] { "\"foo$(1+2)bar\"" }, new[] { "foo$(1+2)bar" }, new[] { ArgumentElementType.StringDoubleQuoted })]
    [InlineData("cmd $val", new[] { "$val" }, null, new[] { ArgumentElementType.VariableExpression })]
    [InlineData("cmd $val[0]", new[] { "$val[0]" }, null, new[] { ArgumentElementType.VariableExpression })]
    [InlineData("cmd $val[0, 1]", new[] { "$val[0, 1]" }, null, new[] { ArgumentElementType.VariableExpression })]
    [InlineData("cmd $val [0, 1]", new[] { "$val", "[0,", "1]" }, null, new[] { ArgumentElementType.VariableExpression, ArgumentElementType.ArrayLiteral, ArgumentElementType.String })]
    [InlineData("cmd $val.Prop", new[] { "$val.Prop" }, null, new[] { ArgumentElementType.VariableExpression })]
    [InlineData("cmd $val.Method(1, 2)", new[] { "$val.Method(1, 2)" })]
    [InlineData("cmd $val[0].Prop.Method()", new[] { "$val[0].Prop.Method()" })]
    [InlineData("cmd $val[0][1][2]", new[] { "$val[0][1][2]" })]
    [InlineData("cmd $val[0].Prop[1]", new[] { "$val[0].Prop[1]" })]
    [InlineData("cmd $val[0].Prop $(1+2)", new[] { "$val[0].Prop", "$(1+2)" }, null, new[] { ArgumentElementType.VariableExpression, ArgumentElementType.NestedExpression })]
    [InlineData("cmd $val(1)", new[] { "$val", "(1)" }, null, new[] { ArgumentElementType.VariableExpression, ArgumentElementType.NestedExpression })]
    [InlineData("cmd $val. a", new[] { "$val", ".", "a" }, null, new[] { ArgumentElementType.VariableExpression, ArgumentElementType.String, ArgumentElementType.String })]
    [InlineData("cmd $val .a", new[] { "$val", ".a" }, null, new[] { ArgumentElementType.VariableExpression, ArgumentElementType.String })]
    [InlineData("cmd $val.\"a\"", new[] { "$val.\"a\"" }, null, new[] { ArgumentElementType.VariableExpression })]
    [InlineData("cmd $val. \"a\"", new[] { "$val", ".", "\"a\"" }, null, new[] { ArgumentElementType.VariableExpression, ArgumentElementType.String, ArgumentElementType.StringDoubleQuoted })]
    [InlineData("cmd $val.Method()", new[] { "$val.Method()" }, null, new[] { ArgumentElementType.VariableExpression })]
    [InlineData("cmd $val.Method()[1]", new[] { "$val.Method()[1]" }, null, new[] { ArgumentElementType.VariableExpression })]
    [InlineData("cmd $val.Prop.Method()", new[] { "$val.Prop.Method()" }, null, new[] { ArgumentElementType.VariableExpression })]
    [InlineData("cmd $val[0]bar", new[] { "$val[0]", "bar" }, null, new[] { ArgumentElementType.VariableExpression, ArgumentElementType.String })]
    [InlineData("cmd $val[0](1)", new[] { "$val[0]", "(1)" }, null, new[] { ArgumentElementType.VariableExpression, ArgumentElementType.NestedExpression })]
    [InlineData("cmd $val[0].Method(1)", new[] { "$val[0].Method(1)" }, null, new[] { ArgumentElementType.VariableExpression })]
    [InlineData("cmd $val[0]. Method(1)", new[] { "$val[0]", ".", "Method", "(1)" }, null, new[] { ArgumentElementType.VariableExpression, ArgumentElementType.String, ArgumentElementType.String, ArgumentElementType.NestedExpression })]
    [InlineData("cmd $val[0] .Method(1)", new[] { "$val[0]", ".Method", "(1)" }, null, new[] { ArgumentElementType.VariableExpression, ArgumentElementType.String, ArgumentElementType.NestedExpression })]
    [InlineData("cmd a,b", new[] { "a,b" }, null, new[] { ArgumentElementType.ArrayLiteral })]
    [InlineData("cmd a,'b c'", new[] { "a,'b c'" }, null, new[] { ArgumentElementType.ArrayLiteral })]
    [InlineData("cmd a,\"b c\"", new[] { "a,\"b c\"" }, null, new[] { ArgumentElementType.ArrayLiteral })]
    [InlineData("cmd a,b, c", new[] { "a,b,", "c" }, null, new[] { ArgumentElementType.ArrayLiteral, ArgumentElementType.String })]
    [InlineData("cmd a,b ,c", new[] { "a,b", ",c" }, null, new[] { ArgumentElementType.ArrayLiteral, ArgumentElementType.String })]
    [InlineData("cmd 'a',b", new[] { "'a',b" }, null, new[] { ArgumentElementType.ArrayLiteral })]
    [InlineData("cmd \"a\",b", new[] { "\"a\",b" }, null, new[] { ArgumentElementType.ArrayLiteral })]
    [InlineData("cmd a,(1),b", new[] { "a,(1),b" }, null, new[] { ArgumentElementType.ArrayLiteral })]
    [InlineData("cmd a, (1),b", new[] { "a,", "(1),b" }, null, new[] { ArgumentElementType.ArrayLiteral, ArgumentElementType.ArrayLiteral})]
    public void TestTokenizer(string input, string[] expectedRawValues, string[]? expectedValues = null, ArgumentElementType[]? expectedTyeps = null)
    {
        var args = Tokenizer.ReconstuctArgv(input);
        Assert.Equal(expectedRawValues, args.Select(arg => $"{arg.GetRawValue(input)}").ToArray());

        if (expectedValues is not null)
        {
            Assert.Equal(expectedValues, args.Select(arg => arg.Value).ToArray());
        }

        if (expectedTyeps is not null)
        {
            Assert.Equal(expectedTyeps, args.Select(arg => arg.Type).ToArray());
        }
    }
}
