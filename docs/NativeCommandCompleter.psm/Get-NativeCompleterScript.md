---
document type: cmdlet
external help file: NativeCommandCompleter.dll-Help.xml
HelpUri: ''
Locale: en-US
Module Name: NativeCommandCompleter.psm
ms.date: 03/21/2026
PlatyPS schema version: 2024-05-01
title: Get-NativeCompleterScript
---

# Get-NativeCompleterScript

## SYNOPSIS

Enumerate completer script files.

## SYNTAX

### __AllParameterSets

```
Get-NativeCompleterScript [[-Name] <string>] [-All]
```

## ALIASES

## DESCRIPTION

If nothing is specified, enumerate the loaded completer scripts.

The `-All` option lists scripts that have not yet been loaded.
You can also filter by command name, and wildcards can be used for this.

## EXAMPLES

### Example 1. Get loaded scripts

```powershell
Get-NativeCompleterScript
```

### Example 2. Get all scripts contains not loaded

```powershell
Get-NativeCompleterScript -All
```

### Example 3. Listing completer scripts for commands starting with "g"

```powershell
Get-NativeCompleterScript g* -All
```

## PARAMETERS

### -All

Get all scripts, including those that haven't been loaded yet.

```yaml
Type: System.Management.Automation.SwitchParameter
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

### -Name

Filter results to show only scripts that match the specified value.

Can use wildcards such as `*`.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: true
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
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

### MT.Comp.CompleterScript

An object with the following properties:

- `Name`: File name (command name) without the file extension
- `Status`: Indicates whether it is being loaded
- `File`: Full path to the script

## NOTES

## RELATED LINKS

