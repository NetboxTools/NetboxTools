---
document type: cmdlet
external help file: NetboxTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: NetboxTools
PlatyPS schema version: 2024-05-01
title: Get-NbxIPAMVLAN
---

# Get-NbxIPAMVLAN

## SYNOPSIS

Gets VLANs from NetBox.

## SYNTAX

### Query (Default)

```
Get-NbxIPAMVLAN [-Name <string[]>] [-Query <hashtable>] [-All] [-Limit <int>] [<CommonParameters>]
```

### Id

```
Get-NbxIPAMVLAN -Id <ulong[]> [<CommonParameters>]
```

## ALIASES

This cmdlet has no aliases.

## DESCRIPTION

Gets VLANs from the NetBox API endpoint 'ipam/vlans'.
Without parameters all VLANs are returned,
the cmdlet follows the pagination of the API.

VLAN objects are returned as they are returned by the API, with the type name 'NetboxTools.IPAMVLAN',
and can be piped to the other cmdlets of the module.

## EXAMPLES

### EXAMPLE 1

```powershell
Get-NbxIPAMVLAN
```

Gets all VLANs.

### EXAMPLE 2

```powershell
Get-NbxIPAMVLAN -Id 42
```

Gets the VLAN with ID 42.

### EXAMPLE 3

```powershell
Get-NbxIPAMVLAN -Name 'example'
```

Gets VLANs where the name is 'example'.

### EXAMPLE 4

```powershell
Get-NbxIPAMVLAN -Query @{ q = 'example' } -Limit 10
```

Gets the first 10 VLANs matching the search 'example'.

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

The ID of the VLAN to get.
Accepts VLAN objects from the pipeline.

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

The maximum number of VLANs to return.
By default all matching VLANs are returned.

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

### -Name

Filters VLANs by name.
Multiple values return VLANs matching any of the values.

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

### NetboxTools.IPAMVLAN

You can pipe VLAN IDs or VLAN objects to this cmdlet.

## OUTPUTS

### NetboxTools.IPAMVLAN

## NOTES

## RELATED LINKS

- [New-NbxIPAMVLAN](New-NbxIPAMVLAN.md)
- [Set-NbxIPAMVLAN](Set-NbxIPAMVLAN.md)
- [Remove-NbxIPAMVLAN](Remove-NbxIPAMVLAN.md)
