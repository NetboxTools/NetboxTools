---
document type: cmdlet
external help file: NetboxTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: NetboxTools
PlatyPS schema version: 2024-05-01
title: New-NbxDCIMInterface
---

# New-NbxDCIMInterface

## SYNOPSIS

Creates a new interface in NetBox.

## SYNTAX

### __AllParameterSets

```
New-NbxDCIMInterface [-Device] <ulong> [-Name] <string> [-Type] <string> [[-Module] <ulong>]
 [[-Label] <string>] [[-Enabled] <bool>] [[-Parent] <ulong>] [[-Bridge] <ulong>] [[-Lag] <ulong>]
 [[-Mtu] <int>] [[-MacAddress] <string>] [[-Speed] <int>] [[-Duplex] <string>] [[-Wwn] <string>]
 [[-MgmtOnly] <bool>] [[-Mode] <string>] [[-UntaggedVlan] <ulong>] [[-TaggedVlan] <ulong[]>]
 [[-Vrf] <ulong>] [[-MarkConnected] <bool>] [[-Description] <string>] [[-Tag] <ulong[]>]
 [[-CustomField] <hashtable>] [[-OptionalAttribute] <hashtable>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:

- Add-NbxDCIMInterface

## DESCRIPTION

Creates a new interface using the NetBox API endpoint 'dcim/interfaces' and returns the created interface.

References to other objects, such as a site or a tenant, accept IDs or the objects returned by the Get cmdlets.
Objects with properties matching the parameter names or the NetBox field names can be piped to the cmdlet,
for example rows from Import-Csv or interface objects returned by Get-NbxDCIMInterface.

## EXAMPLES

### EXAMPLE 1

```powershell
New-NbxDCIMInterface -Device 1 -Name 'eth0' -Type 'virtual'
```

Creates a new interface.

### EXAMPLE 2

```powershell
New-NbxDCIMInterface -Device 1 -Name 'eth0' -Type 'virtual' -Description 'Created with NetboxTools' -OptionalAttribute @{ custom_fields = @{ owner = 'IT' } }
```

Creates a new interface with a description and a custom field value.

### EXAMPLE 3

```powershell
Import-Csv -Path .\interfaces.csv | New-NbxDCIMInterface
```

Creates an interface for each row in a CSV file.
Columns are matched to parameters by name or NetBox field name.

## PARAMETERS

### -Bridge

The bridge interface.
Accepts an ID or an object from Get-NbxDCIMInterface.

```yaml
Type: System.Nullable`1[System.UInt64]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 7
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

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

### -CustomField

Custom field values as a hashtable, e.g.
@{ cost_center = '1234' }.

```yaml
Type: System.Collections.Hashtable
DefaultValue: ''
SupportsWildcards: false
Aliases:
- custom_fields
ParameterSets:
- Name: (All)
  Position: 22
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Description

A short description of the interface.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 20
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Device

The device of the interface.
Accepts an ID or an object from Get-NbxDCIMDevice.

```yaml
Type: System.Nullable`1[System.UInt64]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Duplex

The duplex of the interface.
Common values are: half, full, auto.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 12
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Enabled

Whether the interface is enabled.

```yaml
Type: System.Boolean
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 5
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Label

A physical label.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 4
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Lag

The parent LAG interface.
Accepts an ID or an object from Get-NbxDCIMInterface.

```yaml
Type: System.Nullable`1[System.UInt64]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 8
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -MacAddress

The primary MAC address of the interface.
Requires NetBox 4.7 or later, earlier versions ignore the value.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- mac_address
ParameterSets:
- Name: (All)
  Position: 10
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -MarkConnected

Treat the interface as if a cable is connected.

```yaml
Type: System.Boolean
DefaultValue: False
SupportsWildcards: false
Aliases:
- mark_connected
ParameterSets:
- Name: (All)
  Position: 19
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -MgmtOnly

Whether the interface is used for out-of-band management only.

```yaml
Type: System.Boolean
DefaultValue: False
SupportsWildcards: false
Aliases:
- mgmt_only
ParameterSets:
- Name: (All)
  Position: 14
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Mode

The 802.1Q mode.
Common values are: access, tagged, tagged-all, q-in-q.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 15
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Module

The module of the interface.
Accepts an ID or a NetBox object.

```yaml
Type: System.Nullable`1[System.UInt64]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 3
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Mtu

The maximum transmission unit.

```yaml
Type: System.Nullable`1[System.Int32]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 9
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Name

The name of the interface.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 1
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -OptionalAttribute

Additional NetBox fields as a hashtable with the API field names as keys, for fields that do not have a parameter.
Named parameters take precedence over values in the hashtable.

```yaml
Type: System.Collections.Hashtable
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 23
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Parent

The parent interface.
Accepts an ID or an object from Get-NbxDCIMInterface.

```yaml
Type: System.Nullable`1[System.UInt64]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 6
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Speed

The speed in Kbps.

```yaml
Type: System.Nullable`1[System.Int32]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 11
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Tag

The tags of the interface.
Accepts tag IDs or objects from Get-NbxTag.
Replaces the current tags.

```yaml
Type: System.UInt64[]
DefaultValue: ''
SupportsWildcards: false
Aliases:
- tags
ParameterSets:
- Name: (All)
  Position: 21
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -TaggedVlan

The tagged VLANs (VLAN objects or their IDs, not the VLAN numbers).
Accepts IDs or objects from Get-NbxIPAMVLAN.

```yaml
Type: System.UInt64[]
DefaultValue: ''
SupportsWildcards: false
Aliases:
- tagged_vlans
ParameterSets:
- Name: (All)
  Position: 17
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Type

The interface type, e.g.
'1000base-t' or 'virtual'.
Common values are: virtual, bridge, lag, 100base-tx, 1000base-t, 2.5gbase-t, 5gbase-t, 10gbase-t, 1000base-x-sfp, 10gbase-x-sfpp, 25gbase-x-sfp28, 40gbase-x-qsfpp, 50gbase-x-sfp56, 100gbase-x-qsfp28, 200gbase-x-qsfp56, 400gbase-x-qsfpdd, 400gbase-x-osfp, 800gbase-x-qsfpdd, ieee802.11ac, ieee802.11ax, other.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 2
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -UntaggedVlan

The untagged VLAN (the VLAN object or its ID, not the VLAN number).
Accepts an ID or an object from Get-NbxIPAMVLAN.

```yaml
Type: System.Nullable`1[System.UInt64]
DefaultValue: ''
SupportsWildcards: false
Aliases:
- untagged_vlan
ParameterSets:
- Name: (All)
  Position: 16
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Vrf

The vrf of the interface.
Accepts an ID or a NetBox object.

```yaml
Type: System.Nullable`1[System.UInt64]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 18
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
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

### -Wwn

The 64-bit World Wide Name.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 13
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
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

### System.Management.Automation.PSObject

You can pipe objects with properties matching the parameter names or NetBox field names to this cmdlet.

## OUTPUTS

### NetboxTools.DCIMInterface

## NOTES

## RELATED LINKS

- [Get-NbxDCIMInterface](Get-NbxDCIMInterface.md)
- [Set-NbxDCIMInterface](Set-NbxDCIMInterface.md)
- [Remove-NbxDCIMInterface](Remove-NbxDCIMInterface.md)
