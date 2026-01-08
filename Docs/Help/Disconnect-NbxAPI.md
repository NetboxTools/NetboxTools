---
external help file: netboxTools-help.xml
Module Name: netboxTools
online version:
schema: 2.0.0
---

# Disconnect-NbxAPI

## SYNOPSIS
Disconnects from the Netbox API and clears the stored connection configuration

## SYNTAX

```
Disconnect-NbxAPI [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Disconnects from the currently configured Netbox API by clearing the module-level connection configuration (`$script:NbxConfig`). After running this cmdlet the module will no longer have an active connection until `Connect-NbxAPI` is invoked again.

## EXAMPLES

### EXAMPLE 1
```
Disconnect-NbxAPI
```

This example clears the active Netbox API connection and removes any stored token and configuration.

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### None

## NOTES
Running this cmdlet does not communicate with the Netbox API; it only clears the locally stored configuration and authentication token.

## RELATED LINKS
