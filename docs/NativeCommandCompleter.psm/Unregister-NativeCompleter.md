---
document type: cmdlet
external help file: NativeCommandCompleter.dll-Help.xml
HelpUri: ''
Locale: en-US
Module Name: NativeCommandCompleter.psm
ms.date: 11/10/2025
PlatyPS schema version: 2024-05-01
title: Unregister-NativeCompleter
---

# Unregister-NativeCompleter

## SYNOPSIS

Unregister the command completer.

## SYNTAX

### __AllParameterSets

```
Unregister-NativeCompleter [-Name] <string>
```

## DESCRIPTION

Unregister the command completer.
The unregistered command will again search the directory in the `PS_COMPLETE_PATH` environment variable, and then execute the PowerShell script.

## EXAMPLES

### Example 1. Unregister grep command

```powershell
Unregister-NativeCompleter grep
```

### Example 2. Unregister all

```powershell
Unregister-NativeCompleter *
```

## PARAMETERS

### -Name

Name of command to be unregistered.
Wildcards (`*`) are supported.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: true
Aliases: []
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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Void

None of output

## NOTES

## RELATED LINKS

- [Register-NativeCompleter](./Register-NativeCompleter.md)

