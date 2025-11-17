# Arguments completions

To complete an argument, define an "ArgumentCompleter" which is `ScriptBlock` of PowerShell for completing arguments of commands or parameters.

```powershell
New-CommandCompleter ... -ArgumentCompleter [ScriptBlock]
New-ParamCompleter ... -ArgumentCompleter [ScriptBlock]
```

`New-CommandCompleter` and `New-ParamCompleter` details, see:
- [New-CommandCompleter](./NativeCommandCompleter.psm/New-CommandCompleter.md)
- [New-ParamCompleter](./NativeCommandCompleter.psm/New-ParamCompleter.md)

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

> [!WARNING]
> Other variables and functions defined outside of a `ScriptBlock` cannot be referenced.
> This is because they are kicked in a different context.
>
> ```powershell
> $outsideVariable = 10;
> New-ParamCompleter ... -ArgumentCompleter {
>     $outsideVariable # <- cannt reference
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

#### Example 1. Completes the first argument

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

#### Example 2. Completes filesystem directories only

```powershell
$argumentCompleter = {
    [MT.Comp.Helper]::CompleteFilename($this, $false, $true)
}
```

#### Example 3. Completes filesystem directories or files with ".txt" extension

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

> [!TIP]
> If you already know the string you want to complete, consider using `-Arguments [string[]]` instead of `-ArgumentCompleter [ScriptBlock]`.
> `-Arguments [string[]]` is easier to write.

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

