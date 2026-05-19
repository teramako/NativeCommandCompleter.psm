namespace Sabamiso;

[Flags]
public enum ArgumentElementType
{
    String = 1 << 0,
    Number = 1 << 2,
    Expression = 1 << 3,

    DoubleQuoted = 1 << 4,
    SingleQuoted = 1 << 5,

    Variable = 1 << 6,
    Array = 1 << 7,
    Hashtable = 1 << 8,
    Nested = 1 << 9,

    StringDoubleQuoted = String | DoubleQuoted,
    StringSingleQuoted = String | SingleQuoted,

    VariableExpression = Expression | Variable,
    ArrayExpression = Expression | Array,
    HashtableExpression = Expression | Hashtable,
    NestedExpression = Expression | Nested,
}
