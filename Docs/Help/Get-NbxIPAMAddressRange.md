---
document type: cmdlet
external help file: NetboxTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: NetboxTools
PlatyPS schema version: 2024-05-01
title: Get-NbxIPAMAddressRange
---

# Get-NbxIPAMAddressRange

## SYNOPSIS

Gets IP ranges from NetBox.

## SYNTAX

### Query (Default)

```
Get-NbxIPAMAddressRange [-Query <hashtable>] [-All] [-Limit <int>] [<CommonParameters>]
```

### Id

```
Get-NbxIPAMAddressRange -Id <ulong[]> [<CommonParameters>]
```

## ALIASES

This cmdlet has no aliases.

## DESCRIPTION

Gets IP ranges from the NetBox API endpoint 'ipam/ip-ranges'.
Without parameters all IP ranges are returned,
the cmdlet follows the pagination of the API.

IP range objects are returned as they are returned by the API, with the type name 'NetboxTools.IPAMAddressRange',
and can be piped to the other cmdlets of the module.

## EXAMPLES

### EXAMPLE 1

```powershell
Get-NbxIPAMAddressRange
```

Gets all IP ranges.

### EXAMPLE 2

```powershell
Get-NbxIPAMAddressRange -Id 42
```

Gets the IP range with ID 42.

### EXAMPLE 3

```powershell
Get-NbxIPAMAddressRange -Query @{ q = 'example' } -Limit 10
```

Gets the first 10 IP ranges matching the search 'example'.

## PARAMETERS

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

The ID of the IP range to get.
Accepts IP range objects from the pipeline.

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

The maximum number of IP ranges to return.
By default all matching IP ranges are returned.

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

### NetboxTools.IPAMAddressRange

You can pipe IP range IDs or IP range objects to this cmdlet.

## OUTPUTS

### NetboxTools.IPAMAddressRange

## NOTES

## RELATED LINKS

- [New-NbxIPAMAddressRange](New-NbxIPAMAddressRange.md)
- [Set-NbxIPAMAddressRange](Set-NbxIPAMAddressRange.md)
- [Remove-NbxIPAMAddressRange](Remove-NbxIPAMAddressRange.md)
