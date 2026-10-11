---
document type: cmdlet
external help file: NetboxTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: NetboxTools
PlatyPS schema version: 2024-05-01
title: Get-NbxHostScheme
---

# Get-NbxHostScheme

## SYNOPSIS

Gets the scheme of the NetBox connection.

## SYNTAX

### __AllParameterSets

```
Get-NbxHostScheme [<CommonParameters>]
```

## ALIASES

This cmdlet has no aliases.

## DESCRIPTION

Gets the scheme used to connect to the NetBox API.
The scheme is set by Connect-NbxAPI or Set-NbxHostScheme and defaults to 'https'.

## EXAMPLES

### EXAMPLE 1

```powershell
Get-NbxHostScheme
```

Gets the scheme.

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

- [Set-NbxHostScheme](Set-NbxHostScheme.md)
