---
external help file: netboxTools-help.xml
Module Name: netboxTools
online version:
schema: 2.0.0
---

# Connect-NbxAPI

## SYNOPSIS
Connects to the Netbox API and stores the connection configuration for subsequent cmdlets. Supports authenticated (token) and anonymous modes.

## SYNTAX

### Authorized
```
Connect-NbxAPI -Hostname <String> -Token <String> [-Scheme <String>] [-Port <UInt16>] [-SkipVerification] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Anonymous
```
Connect-NbxAPI -Hostname <String> [-Scheme <String>] [-Port <UInt16>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Connects to a Netbox instance and creates the module-level `$script:NbxConfig` hashtable containing Hostname, Scheme, Port, URI, and (when provided) the Token. When run in the `Authorized` parameter set, the cmdlet will attempt to validate the provided token by calling the Netbox `/api/users/config/` endpoint unless `-SkipVerification` is supplied.

## EXAMPLES

### EXAMPLE 1: Authorized connection
```powershell
Connect-NbxAPI -Hostname "netbox.example.com" -Token "<api-token>"
```
Connects to Netbox using the provided token and validates access.

### EXAMPLE 2: Anonymous connection
```powershell
Connect-NbxAPI -Hostname "netbox.example.com" -Scheme https -Port 8443
```
Sets the connection in anonymous mode (no token). Useful for endpoints that allow anonymous access.

### EXAMPLE 3: Skip verification
```powershell
Connect-NbxAPI -Hostname "netbox.example.com" -Token "<api-token>" -SkipVerification
```
Stores the token without making a verification call to the API.

## PARAMETERS

### -Hostname
The hostname for the Netbox instance (e.g., `netbox.example.com`).

```yaml
Type: String
Parameter Sets: Authorized, Anonymous
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Token
The API token used for authenticated requests.

```yaml
Type: String
Parameter Sets: Authorized
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Scheme-
The URI scheme to use (`http` or `https`). Defaults to `https`.

```yaml
Type: String
Parameter Sets: Authorized, Anonymous
Aliases:

Required: False
Position: Named
Default value: https
Accept pipeline input: False
Accept wildcard characters: False
```

### -Port
The port on which Netbox is listening. Must be between 1 and 65535. Defaults to `443`.

```yaml
Type: UInt16
Parameter Sets: Authorized, Anonymous
Aliases:

Required: False
Position: Named
Default value: 443
Accept pipeline input: False
Accept wildcard characters: False
```

### -SkipVerification
When supplied with the `-Token`, skips the verification call to the Netbox `/api/users/config/` endpoint. Use when token verification is not desired.

```yaml
Type: SwitchParameter
Parameter Sets: Authorized
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### None

## NOTES
- The cmdlet sets `$script:NbxConfig` with a `URI` property that other cmdlets use to build API requests.
- No network call is made for anonymous mode.

## RELATED LINKS

