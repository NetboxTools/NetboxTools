---
document type: cmdlet
external help file: NetboxTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: NetboxTools
PlatyPS schema version: 2024-05-01
title: Get-NbxHostPort
---

# Get-NbxHostPort

## SYNOPSIS

Gets the port of the NetBox connection.

## SYNTAX

### __AllParameterSets

```
Get-NbxHostPort [<CommonParameters>]
```

## ALIASES

This cmdlet has no aliases.

## DESCRIPTION

Gets the port used to connect to the NetBox API.
The port is set by Connect-NbxAPI or Set-NbxHostPort and defaults to 443.

## EXAMPLES

### EXAMPLE 1

```powershell
Get-NbxHostPort
```

Gets the port.

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

- [Set-NbxHostPort](Set-NbxHostPort.md)
