namespace Sabamiso;

public enum ArgumentType
{
    /// <summary>
    /// Default (not specified)
    /// </summary>
    Any = 0,

    /// <summary>
    /// Indicates that the argument is a file or directory path
    /// </summary>
    File = 1 << 2,

    /// <summary>
    /// Indicates that the argument is a directory path
    /// </summary>
    Directory = 1 << 3,

    /// <summary>
    /// Indicates that the argument is a command or a path
    /// </summary>
    Command = 1 << 4,

    /// <summary>
    /// Just like <see cref="Command"/>, indicates that the argument is a command or a path.
    /// Additionally, the subsequent arguments serve as arguments for that command.
    /// </summary>
    DelegatingCommand = Command | (1 << 1),
}
