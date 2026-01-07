---
external help file: netboxTools-help.xml
Module Name: netboxTools
online version:
schema: 2.0.0
---

# Connect-NbxAPI

## SYNOPSIS
Connects to the Netbox API and ensures Credential work properly

## SYNTAX

### Manual (Default)
```
Connect-NbxAPI -Hostname <String> [-Credential <PSCredential>] [-Scheme <String>] [-Port <UInt16>]
 [-SkipCertificateCheck] [-TimeoutSeconds <UInt16>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### URI
```
Connect-NbxAPI [-Credential <PSCredential>] -URI <String> [-SkipCertificateCheck] [-TimeoutSeconds <UInt16>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Connects to the Netbox API and ensures Credential work properly

## EXAMPLES

### EXAMPLE 1
```
Connect-NbxAPI -Hostname "netbox.domain.com"
```

This will prompt for Credential, then proceed to attempt a connection to Netbox

## PARAMETERS

### -Hostname
The hostname for the resource such as netbox.domain.com

```yaml
Type: String
Parameter Sets: Manual
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Credential
Credential object containing the API key in the password.
Username is not applicable

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Scheme
Scheme for the URI such as HTTP or HTTPS.
Defaults to HTTPS

```yaml
Type: String
Parameter Sets: Manual
Aliases:

Required: False
Position: Named
Default value: Https
Accept pipeline input: False
Accept wildcard characters: False
```

### -Port
Port for the resource.
Value between 1-65535

```yaml
Type: UInt16
Parameter Sets: Manual
Aliases:

Required: False
Position: Named
Default value: 443
Accept pipeline input: False
Accept wildcard characters: False
```

### -URI
The full URI for the resource such as "https://netbox.domain.com:8443"

```yaml
Type: String
Parameter Sets: URI
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SkipCertificateCheck
A description of the SkipCertificateCheck parameter.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -TimeoutSeconds
The number of seconds before the HTTP call times out.
Defaults to 30 seconds

```yaml
Type: UInt16
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 30
Accept pipeline input: False
Accept wildcard characters: False
```



### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Additional information about the function.

## RELATED LINKS

