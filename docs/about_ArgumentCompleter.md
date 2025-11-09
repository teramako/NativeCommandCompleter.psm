# Arguments completions

To complete an argument, define an "ArgumentCompleter" which is `ScriptBlock` of PowerShell for completing arguments of commands or parameters.

```powershell
New-CommandCompleter ... -ArgumentCompleter [ScriptBlock]
New-ParamCompleter ... -ArgumentCompleter [ScriptBlock]
```

## CommandCompleter's ArgumentCompleter

A script that returns a completion list of *command* and *subcommand* arguments.

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

### Outputs

- `MT.Comp.CompletionData`
- `System.Management.Automation.CompletionResult`
- `string`: A completion string and description delimited by a leading tab (`\t`) or newline (`\n`, `\r`) character.
- `Array`: Array of completion strings and descriptions.

### Examples

#### Completes the first argument

```powershell
$argumentCompleter = {
    param(
        [int] $position,       # same as `$args[0]`
        [int] $argumentIndex   # same as `$args[1]`
    )
    if ($argumentIndex -eq 0)
    {
        # completions for the first argument
        $prefix = $_.Substring(0, $position) + "*"
        "textA", "textB", "textC" | Where-Object { $_ -like $prefix } # outputs of the completion list
    }
}
```

#### Completes filesystem directories only

```powershell
$argumentCompleter = {
    [MT.Comp.Helper]::CompleteFilename($this, $false, $true)
}
```

#### Completes filesystem directories or files with ".txt" extension

> [!TIP]
> It is a bit tedious, but you need to determine if it is a directory or not.
> Otherwise, you will not be able to get deep into the hierarchy.

```powershell
$argumentCompleter = {
    [MT.Comp.Helper]::CompleteFilename($this, $false, $false, {
        $_.Attributes.HasFlag([System.IO.FileAttributes]::Directory) -or $_.Extension -eq ".txt"
    })
}
```

## ParamCompleter's ArgumentCompleter

A script that returns a completion list of command *parameter* arguments.

### Automatic Variabls

| Name             | Type              | Description       |
|:-----------------|:-----------------:|:------------------|
| `$_`             | string            | Word to complete. |
| `$this`          | CompletionContext | Objects with different values as a result of command line parsing. |

### Arguments

| Index | Type              | Description       |
|:------|:-----------------:|:------------------|
| 0     | int               | Cursor position in the word to be completed. |

### Outputs

Same as above Outputs of CommandCompleter's ArgumentCompleter

