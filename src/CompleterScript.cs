namespace MT.Comp;

public enum CompleterScriptStatus
{
    NotLoaded = 0,
    Loaded = 1
}

public class CompleterScript
{
    public CompleterScript(string path)
    {
        File = path;
        Name = Path.GetFileNameWithoutExtension(path);
        if (NativeCompleter._scripts.TryGetValue(Name, out var loadedFile))
        {
            if (path.Equals(loadedFile, StringComparison.Ordinal))
            {
                Status = CompleterScriptStatus.Loaded;
            }
        }
    }

    public string Name { get; }
    public CompleterScriptStatus Status { get; } = CompleterScriptStatus.NotLoaded;
    public string File { get; }
}
