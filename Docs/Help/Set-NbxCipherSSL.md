---
document type: cmdlet
external help file: NetboxTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: NetboxTools
PlatyPS schema version: 2024-05-01
title: Set-NbxCipherSSL
---

# Set-NbxCipherSSL

## SYNOPSIS

Enables TLS 1.1 and 1.2 for the NetBox connection. Deprecated.

## SYNTAX

### __AllParameterSets

```
Set-NbxCipherSSL [<CommonParameters>]
```

## ALIASES

This cmdlet has no aliases.

## DESCRIPTION

This cmdlet is deprecated, has no effect and will be removed in a future version.

It configured System.Net.ServicePointManager, which is not used by Invoke-RestMethod in PowerShell 7.
PowerShell 7 uses the TLS versions supported by the operating system, including TLS 1.2 and 1.3.
To select TLS versions, use Set-NbxInvokeParameter -InvokeParameter @{ SslProtocol = 'Tls12' }.

## EXAMPLES

### EXAMPLE 1

```powershell
Set-NbxInvokeParameter -InvokeParameter @{ SslProtocol = 'Tls12' }
```

Use this instead of Set-NbxCipherSSL to restrict the TLS version.

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

- [Set-NbxInvokeParameter](Set-NbxInvokeParameter.md)
