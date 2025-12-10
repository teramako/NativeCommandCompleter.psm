---
document type: cmdlet
external help file: NativeCommandCompleter.dll-Help.xml
HelpUri: ''
Locale: en-US
Module Name: NativeCommandCompleter.psm
ms.date: 12/10/2025
PlatyPS schema version: 2024-05-01
title: New-ParamStyle
---

# New-ParamStyle

## SYNOPSIS

Create or get parameter style instance.

## SYNTAX

### Named (Default)

```
New-ParamStyle [-Name] <CommandParameterStyle>
```

### Custom

```
New-ParamStyle [-LongOptionPrefix <string>] [-ShortOptionPrefix <string>] [-ValueSeparator <char>]
 [-ValueStyle <ParameterValueStyle>]
```

## DESCRIPTION

The `New-ParamStyle` cmdlet allows you to create or retrieve a parameter style instance.
This can be used to define how command-line parameters are parsed, including the prefixes for long and short options, the separator for values, and the style of parameter values.

You can use predefined styles such as GNU, Windows, or UnixTraditional, or define a custom style by specifying the prefixes, separator, and value style.

## EXAMPLES

### Example 1. Get builtin `GNU` parameter style

```powershell
New-ParamStyle -Name GNU
```

### Example 2. Create `Key=Value` parameter style

```powershell
New-ParamStyle -ValueSeparator "=" -ValueStyle AllowAdjacent
```

## PARAMETERS

### -LongOptionPrefix

Specifies the prefix for long options in the custom parameter style.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Custom
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: 'Specifies the prefix for long options (e.g., "--").'
```

### -Name

Specifies the predefined parameter style to use. Valid values are GNU, Windows, and UnixTraditional.

```yaml
Type: MT.Comp.Commands.CommandParameterStyle
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Named
  Position: 0
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: [GNU, Windows, UnixTraditional]
HelpMessage: 'Specifies the predefined parameter style to use.'
```

### -ShortOptionPrefix

Specifies the prefix for short options in the custom parameter style.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Custom
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: 'Specifies the prefix for short options (e.g., "-").'
```

### -ValueSeparator

Specifies the character used to separate options from their values in the custom parameter style.

```yaml
Type: System.Char
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Custom
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: 'Specifies the character used to separate options from their values (e.g., "=").'
```

### -ValueStyle

Specifies the style of parameter values in the custom parameter style.

Valid values are `AllowAdjacent`, `AllowSeparated`, and `Both`.

```yaml
Type: MT.Comp.ParameterValueStyle
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Custom
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: [AllowAdjacent, AllowSeparated, Both]
HelpMessage: 'Specifies the style of parameter values.'
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

None.

## OUTPUTS

### MT.Comp.ParameterStyle

Returns an instance of the `ParameterStyle` class representing the created or retrieved parameter style.

## NOTES

## RELATED LINKS

- [New-ParamCompleter](./New-ParamCompleter.md)
