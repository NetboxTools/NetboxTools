---
document type: cmdlet
external help file: NetboxTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: NetboxTools
PlatyPS schema version: 2024-05-01
title: Set-NbxUntrustedSSL
---

# Set-NbxUntrustedSSL

## SYNOPSIS

Skips certificate validation for the NetBox connection. Deprecated.

## SYNTAX

### __AllParameterSets

```
Set-NbxUntrustedSSL [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

This cmdlet has no aliases.

## DESCRIPTION

Skips validation of the certificate of the NetBox instance, for example when it uses a self-signed certificate.

This cmdlet is deprecated and will be removed in a future version.
Use Connect-NbxAPI -SkipCertificateCheck or Set-NbxInvokeParameter -InvokeParameter @{ SkipCertificateCheck = $true } instead.

## EXAMPLES

### EXAMPLE 1

```powershell
Set-NbxUntrustedSSL
```

Skips certificate validation for requests to the NetBox API.

## PARAMETERS

### -Confirm

Prompts you for confirmation before running the cmdlet.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- cf
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

### -WhatIf

Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- wi
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
