---
document type: cmdlet
external help file: NetboxTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: NetboxTools
PlatyPS schema version: 2024-05-01
title: Get-NbxIPAMAddress
---

# Get-NbxIPAMAddress

## SYNOPSIS

Gets IP addresses from NetBox.

## SYNTAX

### Query (Default)

```
Get-NbxIPAMAddress [-Address <string[]>] [-Query <hashtable>] [-All] [-Limit <int>]
 [<CommonParameters>]
```

### Id

```
Get-NbxIPAMAddress -Id <ulong[]> [<CommonParameters>]
```

## ALIASES

This cmdlet has no aliases.

## DESCRIPTION

Gets IP addresses from the NetBox API endpoint 'ipam/ip-addresses'.
Without parameters all IP addresses are returned,
the cmdlet follows the pagination of the API.

IP address objects are returned as they are returned by the API, with the type name 'NetboxTools.IPAMAddress',
and can be piped to the other cmdlets of the module.

## EXAMPLES

### EXAMPLE 1

```powershell
Get-NbxIPAMAddress
```

Gets all IP addresses.

### EXAMPLE 2

```powershell
Get-NbxIPAMAddress -Id 42
```

Gets the IP address with ID 42.

### EXAMPLE 3

```powershell
Get-NbxIPAMAddress -Address 'example'
```

Gets IP addresses where the address is 'example'.

### EXAMPLE 4

```powershell
Get-NbxIPAMAddress -Query @{ q = 'example' } -Limit 10
```

Gets the first 10 IP addresses matching the search 'example'.

## PARAMETERS

### -Address

Filters IP addresses by address.
Multiple values return IP addresses matching any of the values.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Query
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -All

Returns all objects, which is the default.
Kept for backward compatibility.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Query
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Id

The ID of the IP address to get.
Accepts IP address objects from the pipeline.

```yaml
Type: System.UInt64[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Id
  Position: Named
  IsRequired: true
  ValueFromPipeline: true
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Limit

The maximum number of IP addresses to return.
By default all matching IP addresses are returned.

```yaml
Type: System.Int32
DefaultValue: 0
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Query
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Query

Filters supported by the NetBox API as a hashtable, e.g.
@{ q = 'search text' }.
Filters with multiple values are specified as arrays.
See the API documentation of your NetBox instance for available filters.

```yaml
Type: System.Collections.Hashtable
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Query
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

### System.UInt64

### NetboxTools.IPAMAddress

You can pipe IP address IDs or IP address objects to this cmdlet.

## OUTPUTS

### NetboxTools.IPAMAddress

## NOTES

## RELATED LINKS

- [New-NbxIPAMAddress](New-NbxIPAMAddress.md)
- [Set-NbxIPAMAddress](Set-NbxIPAMAddress.md)
- [Remove-NbxIPAMAddress](Remove-NbxIPAMAddress.md)
