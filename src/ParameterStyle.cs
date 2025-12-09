namespace MT.Comp;

/// <summary>
/// Parameter style definition.
/// </summary>
/// <param name="LongOptionPrefix"></param>
/// <param name="ShortOptionPrefix"></param>
/// <param name="ValueSeparator"></param>
/// <param name="ValueStyle"></param>
/// <param name="DisableOptionPrefix"></param>
public record ParameterStyle(string LongOptionPrefix,
                             string ShortOptionPrefix,
                             char ValueSeparator,
                             ParameterValueStyle ValueStyle,
                             bool DisableOptionPrefix)
{
    /// <summary>
    /// GNU style.
    /// </summary>
    public static readonly ParameterStyle GNU = new("--", "-", '=', ParameterValueStyle.Both, false);

    /// <summary>
    /// Traditional Windows OS style.
    /// </summary>
    public static readonly ParameterStyle Windows = new("-", "/", ':', ParameterValueStyle.AllowAdjacent, false);

    /// <summary>
    /// Traditional Unix style.
    /// Almost same as GNU style, but value must be separated by space.
    /// </summary>
    public static readonly ParameterStyle UnixTraditional = new("--", "-", ' ', ParameterValueStyle.AllowSeparated, false);
}
