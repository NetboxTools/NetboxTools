---
document type: cmdlet
external help file: NetboxTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: NetboxTools
PlatyPS schema version: 2024-05-01
title: Get-NbxTimeout
---

# Get-NbxTimeout

## SYNOPSIS

Gets the timeout in seconds of the NetBox connection.

## SYNTAX

### __AllParameterSets

```
Get-NbxTimeout [<CommonParameters>]
```

## ALIASES

This cmdlet has no aliases.

## DESCRIPTION

Gets the timeout in seconds used to connect to the NetBox API.
The timeout is set by Set-NbxTimeout and defaults to 30 seconds.

## EXAMPLES

### EXAMPLE 1

```powershell
Get-NbxTimeout
```

Gets the timeout in seconds.

## PARAMETERS

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### int

## NOTES

## RELATED LINKS

- [Set-NbxTimeout](Set-NbxTimeout.md)
