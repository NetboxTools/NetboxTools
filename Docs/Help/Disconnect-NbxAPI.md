---
document type: cmdlet
external help file: NetboxTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: NetboxTools
PlatyPS schema version: 2024-05-01
title: Disconnect-NbxAPI
---

# Disconnect-NbxAPI

## SYNOPSIS

Disconnects from the NetBox API.

## SYNTAX

### __AllParameterSets

```
Disconnect-NbxAPI [<CommonParameters>]
```

## ALIASES

This cmdlet has no aliases.

## DESCRIPTION

Removes the connection and API token from the session and resets the module configuration,
including the timeout and invoke parameters, to the defaults.

## EXAMPLES

### EXAMPLE 1

```powershell
Disconnect-NbxAPI
```

Disconnects from the NetBox API.

## PARAMETERS

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### None

This cmdlet does not return output.

## NOTES

## RELATED LINKS

- [Connect-NbxAPI](Connect-NbxAPI.md)
