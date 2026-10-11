---
document type: cmdlet
external help file: NetboxTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: NetboxTools
PlatyPS schema version: 2024-05-01
title: Set-NbxDCIMSite
---

# Set-NbxDCIMSite

## SYNOPSIS

Updates sites in NetBox.

## SYNTAX

### __AllParameterSets

```
Set-NbxDCIMSite [-Id] <ulong[]> [[-Name] <string>] [[-Slug] <string>] [[-Status] <string>]
 [[-Region] <ulong>] [[-Group] <ulong>] [[-Tenant] <ulong>] [[-Facility] <string>]
 [[-TimeZone] <string>] [[-PhysicalAddress] <string>] [[-ShippingAddress] <string>]
 [[-Latitude] <decimal>] [[-Longitude] <decimal>] [[-Description] <string>] [[-Comments] <string>]
 [[-Tag] <ulong[]>] [[-CustomField] <hashtable>] [[-OptionalAttribute] <hashtable>] [-PassThru]
 [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

This cmdlet has no aliases.

## DESCRIPTION

Updates one or more sites using the NetBox API endpoint 'dcim/sites'.
Only the specified properties are changed, all other properties keep their current values.

References to other objects, such as a site or a tenant, accept IDs or the objects returned by the Get cmdlets.

## EXAMPLES

### EXAMPLE 1

```powershell
Set-NbxDCIMSite -Id 42 -Description 'Updated with NetboxTools'
```

Updates the description of the site with ID 42.

### EXAMPLE 2

```powershell
Get-NbxDCIMSite -Query @{ q = 'example' } | Set-NbxDCIMSite -Description 'Updated' -PassThru
```

Updates the description of all sites matching the search 'example' and returns the updated sites.

## PARAMETERS

### -Comments

Comments about the site.
Supports Markdown.
Specify $null to clear the value.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 14
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
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
  Position: 16
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Description

A short description of the site.
Specify $null to clear the value.

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
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Facility

The local facility ID or description.
Specify $null to clear the value.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 7
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Force

Updates the object without asking for confirmation.

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

### -Group

The site group.
Accepts an ID or a NetBox object.
Specify $null to clear the value.

```yaml
Type: System.Nullable`1[System.UInt64]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 5
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Id

The ID of the site to update.
Accepts site objects from the pipeline.

```yaml
Type: System.UInt64[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: true
  ValueFromPipeline: true
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Latitude

GPS latitude in decimal format (xx.yyyyyy).
Specify $null to clear the value.

```yaml
Type: System.Nullable`1[System.Decimal]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 11
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Longitude

GPS longitude in decimal format (xx.yyyyyy).
Specify $null to clear the value.

```yaml
Type: System.Nullable`1[System.Decimal]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 12
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Name

The name of the site.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 1
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
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
  Position: 17
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -PassThru

Returns the updated site.
By default, this cmdlet does not generate any output.

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

### -PhysicalAddress

The physical address of the site.
Specify $null to clear the value.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- physical_address
ParameterSets:
- Name: (All)
  Position: 9
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Region

The region of the site.
Accepts an ID or a NetBox object.
Specify $null to clear the value.

```yaml
Type: System.Nullable`1[System.UInt64]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 4
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ShippingAddress

The shipping address of the site.
Specify $null to clear the value.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- shipping_address
ParameterSets:
- Name: (All)
  Position: 10
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Slug

The URL-friendly unique name of the site.
Generated from the name when not specified.
Specify $null to clear the value.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 2
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Status

The status of the site.
Common values are: planned, staging, active, decommissioning, retired.
Specify $null to clear the value.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 3
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Tag

The tags of the site.
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
  Position: 15
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Tenant

The tenant of the site.
Accepts an ID or an object from Get-NbxTenant.
Specify $null to clear the value.

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
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -TimeZone

The time zone of the site, e.g.
'Europe/Stockholm'.
Specify $null to clear the value.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- time_zone
ParameterSets:
- Name: (All)
  Position: 8
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

### System.UInt64

### NetboxTools.DCIMSite

You can pipe site IDs or site objects to this cmdlet.

## OUTPUTS

### None

### NetboxTools.DCIMSite

With -PassThru the updated site is returned.

## NOTES

## RELATED LINKS

- [Get-NbxDCIMSite](Get-NbxDCIMSite.md)
- [New-NbxDCIMSite](New-NbxDCIMSite.md)
- [Remove-NbxDCIMSite](Remove-NbxDCIMSite.md)
