---
document type: cmdlet
external help file: NativeCommandCompleter.dll-Help.xml
HelpUri: ''
Locale: en-US
Module Name: NativeCommandCompleter.psm
ms.date: 04/25/2026
PlatyPS schema version: 2024-05-01
title: New-ArgumentCompleter
---

# New-ArgumentCompleter

## SYNOPSIS

Create an argument definition for commands and parameters.

## SYNTAX

### Default (Default)

```
New-ArgumentCompleter [-Name] <string> [-Description <string>] [-Nargs <Nargs>] [-List]
 [<CommonParameters>]
```

### WithType

```
New-ArgumentCompleter [-Name] <string> -Type <ArgumentType> [-Description <string>] [-Nargs <Nargs>]
 [-List]
```

### WithScript

```
New-ArgumentCompleter [-Name] <string> -Script <scriptblock> [-Description <string>]
 [-Nargs <Nargs>] [-List]
```

### WithCandidates

```
New-ArgumentCompleter [-Name] <string> -Candidates <CompletionValue[]> [-Description <string>]
 [-Nargs <Nargs>] [-List]
```

## ALIASES

## DESCRIPTION

Create argument definitions to be used with the `New-CommandCompleter` (`Register-NativeCompleter`) command and the `New-ParamCompleter` parameter

## EXAMPLES

### Example 1. Create an argument definition (non-completer)

```powershell
New-ArgumentCompleter -Name arg
```

### Example 2. Create a flag-or-value definition

```powershell
New-ArgumentCompleter -Name opt -Nargs '?'
```

### Example 3. Create a file path argument completer

```powershell
New-ArgumentCompleter -Name path -Type File
```

### Example 4. Create an argument completer from static completion candidates

```powershell
New-ArgumentCompleter -Name animal -Candidates "dog", "cat"
```

### Example 5. Create a dynamic argument completer with ScriptBlock

```powershell
New-ArgumentCompleter -Name 
```

## PARAMETERS

### -Candidates

Array of static completion candidates.

```yaml
Type: MT.Comp.CompletionValue[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: WithCandidates
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Description

Description for the argument.

```yaml
Type: System.String
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

### -List

Indicates that the argument is a comma-separated list.

```yaml
Type: System.Management.Automation.SwitchParameter
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

Name of this argument variable.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- VariableName
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

### -Nargs

Specifies how many argument values the parameter accepts.

e.g.:

- "2" — exactly two values
- "1+" — one or more values
- "2-4" — between two and four values
- "?" — zero or one values (flag-or-value). This is same as "0-1"

```yaml
Type: MT.Comp.Nargs
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

### -Script

Script for dynamically generating autocomplete candidates.

```yaml
Type: System.Management.Automation.ScriptBlock
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: WithScript
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Type

Argument type for completion.

- **`File`**: Performs a file or directory path completion.
- **`Directory`**: Performs directory path completion.

```yaml
Type: MT.Comp.ArgumentType
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: WithType
  Position: Named
  IsRequired: true
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

None

## OUTPUTS

### MT.Comp.ArgumentCompleterWithType

### MT.Comp.ArgumentCompleterWithCandidates

### MT.Comp.ArgumentCompleterWithScript

## NOTES

## RELATED LINKS

- [New-ParamCompleter](./New-ParamCompleter.md)
- [New-CommandCompleter](./New-CommandCompleter.md)
- [Register-NativeCommandCompleter](./Register-NativeCommandCompleter.md)
