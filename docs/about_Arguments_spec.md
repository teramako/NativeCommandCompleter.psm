# Arguments specification

Arguments define how to complete argument values for commands or parameters.

```powershell
New-CommandCompleter ... -Arguments [argumentDefinitions]
New-ParamCompleter ... -Arguments [argumentDefinitions]
```

`New-CommandCompleter` and `New-ParamCompleter` details, see:
- [New-CommandCompleter]
- [New-ParamCompleter]

There are two ways to define "Arguments": using the [New-ArgumentCompleter] cmdlet and using a PowerShell Hashtable literal.

[New-CommandCompleter]: ./Sabamiso.psm/New-CommandCompleter.md
[New-ParamCompleter]: ./Sabamiso.psm/New-ParamCompleter.md
[New-ArgumentCompleter]: ./Sabamiso.psm/New-ArgumentCompleter.md

## Define with `New-ArgumentCompleter` cmdlet

For details on the syntax, see [New-ArgumentCompleter].

## Define with Hashtable literal

### keys and default values

```powershell
@{
    Name = "arg";     # Variable name
    Description = ""; # Description of this argument
    Nargs = "1";      # Represents a constraint on the number of argument values accepted by a parameter.
    List = $false;    # Set $true if this argument are camma-separated values
}
```

### Additional Keys and Values (mutually exclusive)

The following keys define **how completion candidates are generated**.

**Only one of these keys can be specified at a time**:
`Type`, `Candidates`, or `Script`.

#### With `Type`

To configure type-based autocompletion, specify the type using the `Type` key.

| Type                 | Description                                                                                     |
|:---------------------|:------------------------------------------------------------------------------------------------|
| `File`               | File or directory completion                                                                    |
| `Directory`          | Directory completion                                                                            |
| `Command`            | Command or file completion                                                                      |
| `DelegatingCommand`  | Same as `Command`, but subsequent arguments are passed to that command                          |

##### Example: File or Directory completion
```powershell
@{
    Name = "path";
    Nargs = "1+";
    Type = "File";
}
```

#### With `Candidates`

Static completion list:

```powershell
@{
    Name = "animal";
    Candidates = @("dog", "cat");
}
```

For each element, you can specify the completion string and its description, separated by a tab (`\t`) or a newline character (`\r`, `\n`).
If no tab or newline character, everything is a completion text.
This is probably the easiest format to handle.

#### With `Script`

Dynamic completion using a ScriptBlock:

```powershell
@{
    Name = "animal";
    Script = {
        param([string] $wordToComplete, [int] $offsetPosition, [int] $argumentIndex)
        $q = $wordToComplete + "*"
        "textA", "textB", "textC" | Where-Object { $_ -like $q } # outputs of the completion list
    }
}
```

## Script specification

A script that returns completion candidates dynamically.

### Automatic Variabls in ScriptBlock

| Name             | Type              | Description       |
|:-----------------|:-----------------:|:------------------|
| `$this`          | CompletionContext | Parsed command-line context |

### Arguments

| Index | Type              | Description       |
|:------|:-----------------:|:------------------|
| 0     | string            | Word to complete. |
| 1     | int               | Cursor position within the word. |
| 2     | int               | Index of the argument (0-based). |

> [!WARNING]
> The first argument, which is the word to complete, may differ from PowerShell's native `$wordToComplete`.
> - Quotes are removed (`'abc'` → `abc`)
> - For `--opt=value`, only `value` is passed

### Outputs

Following types are supported:

- `Sabamiso.CompletionValue`
- `System.Management.Automation.CompletionResult`
- `string`: A completion text and description delimited by a leading tab (`\t`) or newline (`\n`, `\r`) character.
- `Array`: Array of completion text and descriptions.

#### `Sabamiso.CompletionValue`

The output of the script is eventually converted to this `CompletionValue` object.

#### `string`

The completion text and its description are separated by a tab character (`\t`) or a newline character (`\n`, `\r`).
If no tab or newline character, everything is a completion text.
This is probably the easiest format to handle.

```powershell
@(
    "itemA`tDescription A",  # => completion text: "itemA", description: "Description A"
    "itemB`tDescription B",  # => completion text: "itemB", description: "Description B"
    "itemC"                  # => completion text: "itemC", description: empty
)
```

#### `Array`

An array containing the completion text and its description; at least two elements are required, and the third and subsequent elements are ignored.

```powershell
@(
    @("itemA", "Description A"),      # => completion text: "itemA", description: "Description A"
    @("itemB", "Description B", ...), # => completion text: "itemB", description: "Description B"
    @("itemC")                        # Error
)
```

### Examples

#### Example 1. Config file parameter

```powershell
New-ParamCompleter -ShortName c -LongName config -Description "Configuration file" -Arguments @{ Name = 'CONFIG'; Type = 'File'; }
```

#### Example 2. Flag or Value parameter

```powershell
New-ParamCompleter -LongName color -Description "color output" -Arguments @{
  Name = 'WHEN';
  Nargs = '?';
  Candidates = "always", "never", "auto";
}
```

Syntax will be: `--color[={always|never|auto}]`

#### Example 3. Completes filesystem directories or files with ".txt" extension

> [!TIP]
> It is a bit tedious, but you need to determine if it is a directory or not.
> Otherwise, you will not be able to get deep into the hierarchy.

```powershell
New-CommandCompleter -Name readtxt -Arguments @{
    Name = "textfile";
    Nargs = "1+";
    Script = {
        [Sabamiso.Helper]::CompleteFilename($this, $false, $false, {
            $_.Attributes.HasFlag([System.IO.FileAttributes]::Directory) -or $_.Extension -eq ".txt"
        })
    }
}
```
