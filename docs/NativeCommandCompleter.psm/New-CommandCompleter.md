---
document type: cmdlet
external help file: NativeCommandCompleter.dll-Help.xml
HelpUri: ''
Locale: en-US
Module Name: NativeCommandCompleter.psm
ms.date: 12/10/2025
PlatyPS schema version: 2024-05-01
title: New-CommandCompleter
---

# New-CommandCompleter

## SYNOPSIS

Create a CommandCompleter object.

## SYNTAX

### __AllParameterSets

```
New-CommandCompleter [-Name] <string> [[-Description] <string>] [-Aliases <string[]>]
 [-Parameters <ParamCompleter[]>] [-SubCommands <CommandCompleter[]>]
 [-ArgumentCompleter <scriptblock>] [-NoFileCompletions] [-Style <CommandParameterStyle>]
 [-DelegateArgumentIndex <int>] [-Metadata <hashtable>]
```

## ALIASES

## DESCRIPTION

Create a CommandCompleter object and output.
Unlike `Register-NativeCompleter`, it does not register the completer.

Typically, this command will be used for creating subcommands.
It would be easier to use `Register-NativeCompleter`, which can also be registered for normal commands.

## EXAMPLES

### Example 1. Create a completer

```powershell
$completer = New-CommandCompleter -Name cmd-name -Description 'command explanation' -Parameters @(
    New-ParamCompleter -ShortName h -LongName help -Description 'Display help'
) -SubCommands @(
    New-CommandCompleter -Name sub-command-name -Description '...' # -Parameters ... -SubCommands ...
)
```

## PARAMETERS

### -Aliases

Alias names for the command.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ArgumentCompleter

Specifies a script (`ScriptBlock`) to complete the argument.

If not specified, normal path completion will be performed.

For example:

```powershell
New-CommandCompleter ... -ArgumentCompleter {
    param([int] $position, [int] $argumentIndex)
    # $_    # <- word to complete
    # $this # <- completion context
    $prefix = $_.Substring(0, $position)
    "dog", "cat" | Where-Object { $_ -like "$prefix*" }
}
```

For more details, see [About ArgumentCompleter](../about_ArgumentCompleter.md).

```yaml
Type: System.Management.Automation.ScriptBlock
DefaultValue: ''
SupportsWildcards: false
Aliases:
- a
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -DelegateArgumentIndex

Argument index of a command to delegate completions.

Specifies the index of the argument that will be "{COMMAND}". (starting from 0)

For examples:

 - `sudo {COMMAND} [args...]`
 - `time {COMMAND} [args...]`

```yaml
Type: System.Int32
DefaultValue: -1
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Description

Command Description.
This is primarily used to output a completion list of subcommands.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- d
ParameterSets:
- Name: (All)
  Position: 1
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Metadata

Metadata settings.

The given data can be accessed through `-ArgumentCompleter`'s ScriptBlock.
This may reduce the amount of code by eliminating the need to redefine static data.

Typically, it can be used to get localized messages.

```yaml
Type: System.Collections.Hashtable
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Name

Command Name

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- n
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -NoFileCompletions

No file or directory completion in command argument completion.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: false
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Parameters

List of parameters that can be used in the command or subcommand.

```yaml
Type: MT.Comp.ParamCompleter[]
DefaultValue: ''
SupportsWildcards: false
Aliases:
- p
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Style

Style of the command parameters.

Availables:

- `GNU`: Set long option prefix to `--`, short option prefix to `-` and value spprator to `=`. (Default)
- `TraditionalWindows`: Set short option prefix to `-` and value spprator to `:`.

```yaml
Type: MT.Comp.Commands.CommandParameterStyle
DefaultValue: GNU
SupportsWildcards: false
Aliases:
- t
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -SubCommands

List of subcommands.

```yaml
Type: MT.Comp.CommandCompleter[]
DefaultValue: ''
SupportsWildcards: false
Aliases:
- s
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### MT.Comp.CommandCompleter

Created command completer.

## NOTES

## RELATED LINKS

- [Register-NativeCommandCompleter](./Register-NativeCommandCompleter.md)
- [New-ParamCompleter](./New-ParamCompleter.md)
