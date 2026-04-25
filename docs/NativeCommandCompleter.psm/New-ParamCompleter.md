---
document type: cmdlet
external help file: NativeCommandCompleter.dll-Help.xml
HelpUri: ''
Locale: en-US
Module Name: NativeCommandCompleter.psm
ms.date: 04/22/2026
PlatyPS schema version: 2024-05-01
title: New-ParamCompleter
---

# New-ParamCompleter

## SYNOPSIS

Create a parameter's completer.

## SYNTAX

### Default (Default)

```
New-ParamCompleter [-StandardName <string[]>] [-LongName <string[]>] [-ShortName <char[]>]
 [-Description <string>] [-Arguments <ArgumentCompleterCollection>] [-Style <ParameterStyle>]
 [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Create an object for parameter completion.
The created object can be specified in `-Parameters` of `New-CommandCompleter` or `Register-NativeCompleter`.


## DESCRIPTION

Create an object for parameter completion.
The created object can be specified in `-Parameters` of `New-CommandCompleter` or `Register-NativeCompleter`.

## EXAMPLES

### Example 1. Create a flag parameter

```powershell
$helpParam = New-ParamCompleter -ShortName h -LongName help -Description 'Display help'
```

### Example 2. Multiple long parameter names

```powershell
$slientParam = New-ParamCompleter -LongName quiet, slient -Description 'Suppress outputs'
```

### Example 3. Create Flag or WithValue parameter

```powershell
$colorParam = New-ParamCompleter -LongName color -Arguments @{ Nargs = '?'; Candidates = 'auto','always','never' }
```

Syntax will be: `--color[={auto|always|never}]`

### Example 4. Create a parameter that requires a file path as an argument

```powershell
$fileParam = New-ParamCompleter -LongName file -Arguments @{ Name = 'PATH'; Type = 'File'; }
```

Syntax will be: `--file[ =]PATH`
And file name completion will then be enabled.

## PARAMETERS

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
New-ParamCompleter -LongName file -Arguments @{ Name = 'path'; Type = 'File'; }

# Perform autocompletion from a statically defined list
New-ParamCompleter -Name favorit -Arguments @{ Name = 'animal'; Candidates = "dog", "cat"; }

# Define flag-or-value's parameter
New-ParamCompleter -LongName color -Arguments @{ Name = 'WHEN'; Nargs = '?'; Candidates = "auto","always","never" }

# Define separate completers for two arguments
New-ParamCompleter -LongName pair -Arguments @{
  Name = '1st'; Candidates = "A", "B", "C";
}, @{
  Name = '2nd'; Candidates = "X", "Y", "Z"
}

# Use a script block for dynamic autocompletion
New-ParamCompleter -Name favorit -Arguments @{
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

For more details, see [Arguments specification](../about_Arguments_spec.md).

```yaml
Type: MT.Comp.ArgumentCompleterCollection
DefaultValue: ''
SupportsWildcards: false
Aliases:
- a
- ArgumentCompleter
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

Parameter description.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- d
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

### -LongName

GNU-style's long parameter names.

Unless you apply a special `Style`, specify the name without the prefix (`--`).
If the parameter is `--verbose`, specify `verbose`.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases:
- l
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

### -ShortName

GNU-style's short parameter names.

```yaml
Type: System.Char[]
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

### -StandardName

Standard parameter names.

Unless you apply a special `Style`, specify the name without the prefix (`-` or `/`).
If the parameter is `-name`, specify `name`.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Name
- n
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

Specify Parameter style.
If ommited, inhertes from the parent CommandCompleter's style.

```yaml
Type: MT.Comp.ParameterStyle
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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### MT.Comp.ParamCompleter

Created a parameter completer object.

## NOTES

## RELATED LINKS

- [Register-NativeCompleter](Register-NativeCompleter.md)
- [New-CommandCompleter](New-CommandCompleter.md)
