---
document type: cmdlet
external help file: NativeCommandCompleter.dll-Help.xml
HelpUri: ''
Locale: en-US
Module Name: NativeCommandCompleter.psm
ms.date: 04/22/2026
PlatyPS schema version: 2024-05-01
title: Register-NativeCompleter
---

# Register-NativeCompleter

## SYNOPSIS

Create and register a CommandCompleter object.

## SYNTAX

### New

```
Register-NativeCompleter [-Name] <string> [[-Description] <string>] [-Aliases <string[]>]
 [-Parameters <ParamCompleter[]>] [-SubCommands <CommandCompleter[]>]
 [-Arguments <ArgumentCompleterCollection>] [-Style <CommandParameterStyle>]
 [-CustomStyle <ParameterStyle>] [-NoFileCompletions] [-DelegateArgumentIndex <int>]
 [-Metadata <hashtable>] [-Force]
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

### -Aliases

Alias names for the command.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
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

### -Arguments

Specifies argument definitions and their associated completers.

The -Arguments parameter accepts values of several types:
- A list of candidates (`string` or `CompletionValue`)
- A `ScriptBlock`
- An object implementing `IArgumentCompleter`
- A `Hashtable` (automatically converted to an `IArgumentCompleter`)  
  See following examples.

If omitted, standard file‑system path completion is used, unless `-NoFileCompletions` is specified.

For examples:

```powershell
# Perform file‑path completion for one or more arguments
New-CommandCompleter ... -Arguments @{ Name = 'path'; Type = 'File'; Nargs = '1+' }

# Perform autocompletion from a statically defined list
New-CommandCompleter ... -Arguments @{ Name = 'animal'; Candidates = "dog", "cat"; }

# Define separate completers for two arguments
New-CommandCompleter ... -Arguments @{
  Name = '1st'; Candidates = "A", "B", "C";
}, @{
  Name = '2nd'; Candidates = "X", "Y", "Z"
}

# Use a script block for dynamic autocompletion
New-CommandCompleter ... -Arguments @{
  Name = 'animal';
  Script = {
    param([int] $position, [int] $argumentIndex)
    # $_    # <- word to complete
    # $this # <- completion context
    $prefix = $_.Substring(0, $position)
    "dog", "cat" | Where-Object { $_ -like "$prefix*" }
  }
}
```

```yaml
Type: MT.Comp.ArgumentCompleterCollection
DefaultValue: ''
SupportsWildcards: false
Aliases:
- a
- ArgumentCompleter
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

### -CustomStyle

Sets a special non-standard parameter style.
This setting is inherited by each parameter.

```yaml
Type: MT.Comp.ParameterStyle
DefaultValue: ''
SupportsWildcards: false
Aliases: []
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

### -NoFileCompletions

No file or directory completion in command argument completion.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: false
SupportsWildcards: false
Aliases: []
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

### -Style

Style of the command parameters.

Availables:

- `GNU`: Set long option prefix to `--`, short option prefix to `-` and value spprator to `=`. (Default)
- `Windows`: Set short option prefix to `-` and value spprator to `:`.
- `Unix`: Similer to `GNU`, but disallow adjacent value parameter like `-key=value`

```yaml
Type: MT.Comp.Commands.CommandParameterStyle
DefaultValue: GNU
SupportsWildcards: false
Aliases:
- t
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
