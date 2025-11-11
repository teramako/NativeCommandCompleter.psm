namespace MT.Comp;

internal static class StringExtensions
{
    /// <summary>
    /// Calculate the number of cells for the target character. (how many half-width characters on the terminal)
    /// </summary>
    /// <seealso href="https://github.com/PowerShell/PowerShell/blob/7fe5cb3e354eb775778944e5419cfbcb8fede735/src/Microsoft.PowerShell.ConsoleHost/host/msh/ConsoleControl.cs#L2785-L2806"/>
    internal static int LengthInBufferCells(this string value)
    {
        return value.Sum(LengthInBufferCells);
    }

    internal static int LengthInBufferCells(char c)
    {
        // The following is based on http://www.cl.cam.ac.uk/~mgk25/c/wcwidth.c
        // which is derived from https://www.unicode.org/Public/UCD/latest/ucd/EastAsianWidth.txt
        bool isWide = c >= 0x1100 &&
            (c <= 0x115f || /* Hangul Jamo init. consonants */
             c == 0x2329 || c == 0x232a ||
             ((uint)(c - 0x2e80) <= (0xa4cf - 0x2e80) &&
              c != 0x303f) || /* CJK ... Yi */
             ((uint)(c - 0xac00) <= (0xd7a3 - 0xac00)) || /* Hangul Syllables */
             ((uint)(c - 0xf900) <= (0xfaff - 0xf900)) || /* CJK Compatibility Ideographs */
             ((uint)(c - 0xfe10) <= (0xfe19 - 0xfe10)) || /* Vertical forms */
             ((uint)(c - 0xfe30) <= (0xfe6f - 0xfe30)) || /* CJK Compatibility Forms */
             ((uint)(c - 0xff00) <= (0xff60 - 0xff00)) || /* Fullwidth Forms */
             ((uint)(c - 0xffe0) <= (0xffe6 - 0xffe0)));

        // We can ignore these ranges because .Net strings use surrogate pairs
        // for this range and we do not handle surrogate pairs.
        // (c >= 0x20000 && c <= 0x2fffd) ||
        // (c >= 0x30000 && c <= 0x3fffd)
        return 1 + (isWide ? 1 : 0);
    }

    /// <summary>
    /// Crop string to cell length.
    /// If full-width characters are included, the cropped string may be shorter than the target cell length.
    /// </summary>
    /// <param name="start">Position to start cropping</param>
    /// <param name="cellLength">Target cell length</param>
    /// <param name="actualCellLength">Actual cell length of the result of cropping</param>.
    internal static string CropToCellLength(this string value, int start, int cellLength, out int actualCellLength)
    {
        Span<char> newStr = new char[value.Length];
        actualCellLength = 0;
        int charIndex = 0;
        for (var i = start; i < value.Length - start; i++)
        {
            var c = value[i];
            var cLength = LengthInBufferCells(c);
            if (actualCellLength + cLength > cellLength)
                break;

            if (char.IsSurrogate(c))
            {
                i++;
                cLength += LengthInBufferCells(value[i]);
                if (actualCellLength + cLength > cellLength)
                    break;
                newStr[charIndex++] = c;
                newStr[charIndex++] = value[i];
            }
            else
            {
                newStr[charIndex++] = c;
            }
            actualCellLength += cLength;
        }

        return newStr[..charIndex].ToString();
    }
}
