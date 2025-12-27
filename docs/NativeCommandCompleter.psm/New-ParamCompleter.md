---
document type: cmdlet
external help file: NativeCommandCompleter.dll-Help.xml
HelpUri: ''
Locale: en-US
Module Name: NativeCommandCompleter.psm
ms.date: 12/27/2025
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
 [-Description <string>] [-Type <ArgumentType>] [-VariableName <string>] [-Style <ParameterStyle>]
```

### WithArguments

```
New-ParamCompleter -Arguments <string[]> [-StandardName <string[]>] [-LongName <string[]>]
 [-ShortName <char[]>] [-Description <string>] [-Type <ArgumentType>] [-VariableName <string>]
 [-Style <ParameterStyle>]
```

### WithArgumentCompleter

```
New-ParamCompleter -ArgumentCompleter <scriptblock> [-StandardName <string[]>]
 [-LongName <string[]>] [-ShortName <char[]>] [-Description <string>] [-Type <ArgumentType>]
 [-VariableName <string>] [-Style <ParameterStyle>]
```

## ALIASES

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
$colorParam = New-ParamCompleter -LongName color -Type FlagOrValue -Arguments 'auto','always','never'
```

Syntax will be: `--color[={auto|always|never}]`

### Example 4. Create a parameter that requires a file path as an argument

```powershell
$fileParam = New-ParamCompleter -LongName file -Type File
```

## PARAMETERS

### -ArgumentCompleter

Specifies a script (`ScriptBlock`) to complete the argument.

For more details, see [About ArgumentCompleter](../about_ArgumentCompleter.md).

```yaml
Type: System.Management.Automation.ScriptBlock
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: WithArgumentCompleter
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Arguments

The parameter's arguments to be completed.
This is more convenient than using `-ArgumentCompleter` if the required argument values are fixed.

If a tab character (`\t`) or a newline character (`\n`,`\r`) is inserted in a string, the left side is the completion string and the right side is its description.

For example:
```powershell
-Arguments @("textA`tDescription A", "textB`tDescription B")
```

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases:
- a
ParameterSets:
- Name: WithArguments
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

### -Type

Parametesr's type for completion.

- **`Flag`**: The argument is an unnecessary.
          This is default value if neither `-Arguments` nor `-ArgumentCompleter` is specified.

- **`FlagOrValue`**: In GNU-style long parameter, like `-xFoo`, and in GNU-style short parameter, like `--color=auto`,
                 which indicates that the argument is accepted only if the parameter and the argument are combined.
                 Otherwise, it is a parameter that acts as a flag.

- **`Required`**: The argument is required.
              This is default value if either `-Arguments` or `-ArgumentCompleter` is specified.

- **`File`**: Performs a file or directory path completion.
          (ignored when either `-Arguments` or `-ArgumentCompleter` is specified.)

- **`Directory`**: Performs directory path completion.
               (ignored when either `-Arguments` or `-ArgumentCompleter` is specified.)

- **`List`**: Comma-separated value(s) are accepted.

```yaml
Type: MT.Comp.ArgumentType
DefaultValue: ''
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

### -VariableName

Name of this parameter's argument variable.

This parameter value does not affect the operation. It is only used to display the candidate completion list.

```yaml
Type: System.String
DefaultValue: Val
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
