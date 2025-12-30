using System.Diagnostics.CodeAnalysis;

namespace MT.Comp;

/// <summary>
/// Represents a constraint on the number of argument values accepted by a parameter.
/// </summary>
/// <remarks>
/// <para>
/// <see cref="Nargs"/> models the minimum and maximum number of values that a
/// command-line parameter may consume. It generalizes common CLI patterns such as:
/// </para>
/// <list type="bullet">
///   <item>
///     <description>
///       <b>Fixed count</b>: A single non‑negative integer (e.g., <c>"3"</c>) requires
///       exactly that many values.
///     </description>
///   </item>
///   <item>
///     <description>
///       <b>Lower bound only</b>: A non‑negative integer followed by <c>'+'</c>
///       (e.g., <c>"2+"</c>) requires at least that many values and consumes all
///       remaining arguments.
///     </description>
///   </item>
///   <item>
///     <description>
///       <b>Bounded range</b>: Two non‑negative integers separated by <c>'-'</c>
///       (e.g., <c>"1-3"</c>) specify an inclusive minimum and maximum.
///     </description>
///   </item>
/// </list>
/// <para>
/// Internally, an unbounded upper limit is represented by <c>MaxCount = -1</c>.
/// This avoids <c>Nullable&lt;int&gt;</c> overhead and ensures that
/// <c>default(Nargs)</c> does not accidentally represent a valid specification.
/// </para>
/// </remarks>
public readonly struct Nargs : ISpanParsable<Nargs>
{
    /// <summary>
    /// Gets the minimum number of values required.
    /// </summary>
    public int MinCount { get; }

    /// <summary>
    /// Gets the maximum number of values allowed.
    /// A value of <c>-1</c> indicates no upper bound.
    /// </summary>
    public int MaxCount { get; }

    /// <summary>
    /// Gets a value indicating whether this specification consumes all remaining values.
    /// </summary>
    public bool ConsumeRest => MaxCount < 0;

    /// <summary>
    /// Initializes a new instance representing a fixed number of values.
    /// </summary>
    public Nargs(int fixedCount)
        : this(fixedCount, fixedCount)
    {
    }

    /// <summary>
    /// Initializes a new instance with the specified minimum and maximum counts.
    /// Use <c>-1</c> for <paramref name="maxCount"/> to indicate an unbounded upper limit.
    /// </summary>
    public Nargs(int minCount, int maxCount)
    {
        if (minCount < 0)
            throw new ArgumentOutOfRangeException(nameof(minCount));

        if (maxCount != -1 && maxCount < minCount)
            throw new ArgumentException("MaxCount cannot be less than MinCount unless it is -1.");

        MinCount = minCount;
        MaxCount = maxCount;
    }

    /// <inheritdoc/>
    public static Nargs Parse(ReadOnlySpan<char> s, IFormatProvider? provider = null)
    {
        if (TryParse(s, provider, out var result))
            return result;

        throw new FormatException($"Invalid nargs specification: '{s.ToString()}'");
    }

    /// <inheritdoc/>
    public static bool TryParse(ReadOnlySpan<char> s, IFormatProvider? provider, out Nargs result)
    {
        result = default;

        if (s.IsEmpty)
            return false;

        // 1) "n+" → lower bound only
        if (s[^1] == '+')
        {
            var numPart = s[..^1];
            if (!int.TryParse(numPart, out int min) || min < 0)
                return false;

            result = new Nargs(min, -1);
            return true;
        }

        // 2) "min-max" or "min-*"
        var dashIndex = s.IndexOf('-');
        if (dashIndex >= 0)
        {
            var minSpan = s[..dashIndex];
            var maxSpan = s[(dashIndex + 1)..];

            if (!int.TryParse(minSpan, out int min) || min < 0)
                return false;

            if (maxSpan.SequenceEqual("*"))
            {
                result = new Nargs(min, -1);
                return true;
            }

            if (!int.TryParse(maxSpan, out int max) || max < min)
                return false;

            result = new Nargs(min, max);
            return true;
        }

        // 3) fixed number
        if (int.TryParse(s, out int fixedCount) && fixedCount >= 0)
        {
            result = new Nargs(fixedCount);
            return true;
        }

        return false;
    }

    /// <summary>
    /// Returns a compact string representation of the argument count specification.
    /// </summary>
    public override string ToString()
    {
        if (MaxCount < 0)
            return $"{MinCount}+";

        if (MinCount == MaxCount)
            return MinCount.ToString();

        return $"{MinCount}-{MaxCount}";
    }

    /// <inheritdoc/>
    public static Nargs Parse(string s, IFormatProvider? provider)
    {
        return Parse(s.AsSpan(), provider);
    }

    /// <inheritdoc/>
    public static bool TryParse([NotNullWhen(true)] string? s, IFormatProvider? provider, [MaybeNullWhen(false)] out Nargs result)
    {
        return TryParse(s.AsSpan(), provider, out result);
    }

    /// <summary>
    /// A predefined specification representing exactly zero values.
    /// Used for flag parameter.
    /// </summary>
    public static readonly Nargs Zero = default;

    /// <summary>
    /// A predefined specification representing exactly one value.
    /// </summary>
    public static readonly Nargs One = new(1);

    /// <summary>
    /// A predefined specification representing zero or one value.
    /// Used for flag or value parameter.
    /// </summary>
    public static readonly Nargs ZeroOrOne = new(0, 1);
}
