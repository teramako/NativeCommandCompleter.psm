---
document type: cmdlet
external help file: NativeCommandCompleter.dll-Help.xml
HelpUri: ''
Locale: en-US
Module Name: NativeCommandCompleter.psm
ms.date: 11/16/2025
PlatyPS schema version: 2024-05-01
title: Register-NativeCompleter
---

# Register-NativeCompleter

## SYNOPSIS

Create and register a CommandCompleter object.

## SYNTAX

### New

```
Register-NativeCompleter [-Name] <string> [[-Description] <string>] [-Parameters <ParamCompleter[]>]
 [-SubCommands <CommandCompleter[]>] [-ArgumentCompleter <scriptblock>] [-Force]
```

### Input

```
Register-NativeCompleter [-Completer] <CommandCompleter> [-Force] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Create and **register** a CommandCompleter object.

Typically, this command will be used for registering normal commands not subcommands.

## EXAMPLES

### Example 1. Register normal command

```powershell
Register-NativeCompleter -Name cmd-name -Parameters @(
    New-ParamCompleter -ShortName h -LongName help -Description 'Display help'
    # ...
)
```

## PARAMETERS

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
- Name: New
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Completer

Specify the CommadCompleter object to be registered.
Typically, used for registering the command completer which created by `New-CommandCompleter` cmdlet.

```yaml
Type: MT.Comp.CommandCompleter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Input
  Position: 0
  IsRequired: true
  ValueFromPipeline: true
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Description

Command Description.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- d
ParameterSets:
- Name: New
  Position: 1
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Force

Even if a command with the same name is already registered, it will be forcibly overwritten.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- f
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
- Name: New
  Position: 0
  IsRequired: true
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
- Name: New
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
- Name: New
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

### MT.Comp.CommandCompleter

Registers the CommandCompleter input from the pipeline.

## OUTPUTS

### System.Void

None of output

## NOTES

## RELATED LINKS

- [New-CommandCompleter](./New-CommandCompleter.md)
- [New-ParamCompleter](./New-ParamCompleter.md)
- [Unregister-NativeCompleter](./Unregister-NativeCompleter.md)
