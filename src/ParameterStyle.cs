namespace MT.Comp;

/// <summary>
/// Parameter style definition.
/// </summary>
/// <param name="LongOptionPrefix"></param>
/// <param name="ShortOptionPrefix"></param>
/// <param name="ValueSeparator"></param>
/// <param name="ValueStyle"></param>
public record ParameterStyle(string LongOptionPrefix,
                             string ShortOptionPrefix,
                             char ValueSeparator,
                             ParameterValueStyle ValueStyle)
{
    /// <summary>
    /// GNU style.
    /// </summary>
    public static readonly ParameterStyle GNU = new("--", "-", '=', ParameterValueStyle.Both);

    /// <summary>
    /// Traditional Windows OS style.
    /// </summary>
    public static readonly ParameterStyle Windows = new("/", "/", ':', ParameterValueStyle.Adjacent);

    /// <summary>
    /// Traditional Unix style.
    /// Almost same as GNU style, but value must be separated by space.
    /// </summary>
    public static readonly ParameterStyle Unix = new("--", "-", ' ', ParameterValueStyle.Separated);

    /// <summary>
    /// Indicates whether short option prefix is defined.
    /// </summary>
    public bool HasShortOptionPrefix { get; } = !string.IsNullOrEmpty(ShortOptionPrefix);

    /// <summary>
    /// Indicates whether long option prefix is defined.
    /// </summary>
    public bool HasLongOptionPrefix { get; } = !string.IsNullOrEmpty(LongOptionPrefix);

    public override string ToString()
    {
        return $"[\"{LongOptionPrefix}\", \"{ShortOptionPrefix}\"], [{ValueStyle}, '{ValueSeparator}']";
    }
}
