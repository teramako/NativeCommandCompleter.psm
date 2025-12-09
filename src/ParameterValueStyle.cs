namespace MT.Comp;

[Flags]
public enum ParameterValueStyle
{
    /// <summary>
    /// Specifies that only adjacent parameter values are allowed.
    /// </summary>
    AllowAdjacent = 1 << 0,

    /// <summary>
    /// Speccifies that parameter values can be placed separated from the parameter name by whitespace.
    /// </summary>
    AllowSeparated = 1 << 1,

    /// <summary>
    /// Specifies that the parameter style allows both adjacent and separated formats.
    /// </summary>
    Both = AllowAdjacent | AllowSeparated,
}
