---
document type: cmdlet
external help file: NetboxTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: NetboxTools
PlatyPS schema version: 2024-05-01
title: Get-NbxVersion
---

# Get-NbxVersion

## SYNOPSIS

Gets the version and status of the NetBox instance.

## SYNTAX

### __AllParameterSets

```
Get-NbxVersion [<CommonParameters>]
```

## ALIASES

This cmdlet has no aliases.

## DESCRIPTION

Gets the status of the connected NetBox instance from the API endpoint 'status', including the NetBox,
Django and Python versions, installed apps and plugins and the number of running workers.

## EXAMPLES

### EXAMPLE 1

```powershell
(Get-NbxVersion).'netbox-version'
```

Gets the version of the connected NetBox instance.

## PARAMETERS

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### NetboxTools.Status

## NOTES

## RELATED LINKS

- [NetboxTools on GitHub](https://github.com/SebastianClaesson/NetboxTools)

