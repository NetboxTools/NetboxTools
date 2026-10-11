---
document type: cmdlet
external help file: NetboxTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: NetboxTools
PlatyPS schema version: 2024-05-01
title: Connect-NbxAPI
---

# Connect-NbxAPI

## SYNOPSIS

Connects to the NetBox API.

## SYNTAX

### Token (Default)

```
Connect-NbxAPI [-Hostname] <string> -Token <string> [-Scheme <string>] [-Port <int>]
 [-SkipCertificateCheck] [-SkipVerification] [<CommonParameters>]
```

### Credential

```
Connect-NbxAPI [-Hostname] <string> -Credential <pscredential> [-Scheme <string>] [-Port <int>]
 [-SkipCertificateCheck] [-SkipVerification] [<CommonParameters>]
```

### Anonymous

```
Connect-NbxAPI [-Hostname] <string> -Anonymous [-Scheme <string>] [-Port <int>]
 [-SkipCertificateCheck] [-SkipVerification] [<CommonParameters>]
```

## ALIASES

This cmdlet has no aliases.

## DESCRIPTION

Connects to the NetBox API of a NetBox instance.
The connection is used by all other cmdlets in the module
until Disconnect-NbxAPI is run or the module is removed.

Authenticate with an API token, either as a string with -Token or as the password of a credential with
-Credential.
Both NetBox v1 tokens and v2 tokens (prefixed 'nbt_') are supported.
Use -Anonymous to connect
without authentication to NetBox instances that allow anonymous read access.

The connection is verified with a request to the API, unless -SkipVerification is specified.

## EXAMPLES

### EXAMPLE 1

```powershell
Connect-NbxAPI -Hostname 'netbox.example.com' -Token $Token
```

Connects to https://netbox.example.com/api with an API token.

### EXAMPLE 2

```powershell
Connect-NbxAPI -Hostname 'netbox.example.com' -Credential (Get-Credential -UserName 'token' -Message 'NetBox API token')
```

Connects with an API token entered as the password of a credential.

### EXAMPLE 3

```powershell
Connect-NbxAPI -Hostname 'http://netbox.lab:8000' -Anonymous
```

Connects anonymously to a NetBox instance on http port 8000.

## PARAMETERS

### -Anonymous

Connects without authentication.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Anonymous
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Credential

A credential with the API token as password.
The user name is not used.

```yaml
Type: System.Management.Automation.PSCredential
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Credential
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Hostname

The hostname of the NetBox instance, such as 'netbox.example.com'.
A URL such as
'https://netbox.example.com:8443' is also accepted, the scheme and port are then taken from the URL.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
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

### -Port

The port of the API.
Defaults to 443 for https and 80 for http.

```yaml
Type: System.Int32
DefaultValue: 0
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Scheme

The scheme of the API, https (default) or http.

```yaml
Type: System.String
DefaultValue: https
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -SkipCertificateCheck

Skips validation of the certificate of the NetBox instance, for example when it uses a self-signed certificate.
Applies to this connection only, each Connect-NbxAPI validates certificates unless this is specified.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -SkipVerification

Does not verify the connection with a request to the API.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Token

The API token to authenticate with.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Token
  Position: Named
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

### None

This cmdlet does not return output.

## NOTES

## RELATED LINKS

- [Disconnect-NbxAPI](Disconnect-NbxAPI.md)
