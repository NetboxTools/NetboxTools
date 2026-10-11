---
document type: cmdlet
external help file: NetboxTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: NetboxTools
PlatyPS schema version: 2024-05-01
title: Get-NbxHostname
---

# Get-NbxHostname

## SYNOPSIS

Gets the hostname of the NetBox connection.

## SYNTAX

### __AllParameterSets

```
Get-NbxHostname [<CommonParameters>]
```

## ALIASES

This cmdlet has no aliases.

## DESCRIPTION

Gets the hostname used to connect to the NetBox API.
The hostname is set by Connect-NbxAPI or Set-NbxHostname.

## EXAMPLES

### EXAMPLE 1

```powershell
Get-NbxHostname
```

Gets the hostname.

## PARAMETERS

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### string

## NOTES

## RELATED LINKS

- [Set-NbxHostname](Set-NbxHostname.md)
