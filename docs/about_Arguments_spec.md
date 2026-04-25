# Arguments specification

To complete an argument, define "Arguments" for completing arguments of commands or parameters.

```powershell
New-CommandCompleter ... -Arguments [argumentDefinitions]
New-ParamCompleter ... -Arguments [argumentDefinitions]
```

`New-CommandCompleter` and `New-ParamCompleter` details, see:
- [New-CommandCompleter]
- [New-ParamCompleter]

There are two ways to define "Arguments": using the [New-ArgumentCompleter] cmdlet and using a PowerShell Hashtable literal.

[New-CommandCompleter]: ./NativeCommandCompleter.psm/New-CommandCompleter.md
[New-ParamCompleter]: ./NativeCommandCompleter.psm/New-ParamCompleter.md
[New-ArgumentCompleter]: ./NativeCommandCompleter.psm/New-ArgumentCompleter.md

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

### Additional completer definition

#### With `Type`

To configure type-based autocompletion, specify the type using the `Type` key.

| Type        | Description                  |
|:------------|:-----------------------------|
| `File`      | File or directory completion |
| `Directory` | Directory completion         |


##### Example: File or Directory completion
```powershell
@{
    Name = "path";
    Nargs = "1+";
    Type = "File";
}
```

#### With `Candidates`

To use a list of static completion candidates, set the completion list in the `Candidates` key.

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

To generate dynamic completion candidates using a PowerShell script, set the `Script` key to `ScriptBlock`.

```powershell
@{
    Name = "animal";
    Script = {
        $q = $this.WordToComplete + "*"
        "textA", "textB", "textC" | Where-Object { $_ -like $q } # outputs of the completion list
    }
}
```

## Script specification

A script that returns a completion list of arguments dynamically.

### Automatic Variabls

| Name             | Type              | Description       |
|:-----------------|:-----------------:|:------------------|
| `$_`             | string            | Word to complete. |
| `$this`          | CompletionContext | Objects with different values as a result of command line parsing. |

### Arguments

| Index | Type              | Description       |
|:------|:-----------------:|:------------------|
| 0     | int               | Cursor position in the word to be completed. |
| 1     | int               | Index of the list of arguments not parsed into parameters.(starting with `0`). |

> [!WARNING]
> Other variables and functions defined outside of a `ScriptBlock` cannot be referenced.
> This is because they are kicked in a different context.
>
> ```powershell
> $outsideVariable = 10;
> New-ParamCompleter ... -Arguments @{
>     Name = "arg";
>     Script = {
>         $outsideVariable # <- cannt reference
>     }
> }
> ```

### Outputs

Following types are supported:

- `MT.Comp.CompletionValue`
- `System.Management.Automation.CompletionResult`
- `string`: A completion text and description delimited by a leading tab (`\t`) or newline (`\n`, `\r`) character.
- `Array`: Array of completion text and descriptions.

#### `MT.Comp.CompletionValue`

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
        [MT.Comp.Helper]::CompleteFilename($this, $false, $false, {
            $_.Attributes.HasFlag([System.IO.FileAttributes]::Directory) -or $_.Extension -eq ".txt"
        })
    }
}
```
