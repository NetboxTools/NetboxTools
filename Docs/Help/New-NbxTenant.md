---
document type: cmdlet
external help file: NetboxTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: NetboxTools
PlatyPS schema version: 2024-05-01
title: New-NbxTenant
---

# New-NbxTenant

## SYNOPSIS

Creates a new tenant in NetBox.

## SYNTAX

### __AllParameterSets

```
New-NbxTenant [-Name] <string> [[-Slug] <string>] [[-Group] <ulong>] [[-Description] <string>]
 [[-Comments] <string>] [[-Tag] <ulong[]>] [[-CustomField] <hashtable>]
 [[-OptionalAttribute] <hashtable>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

This cmdlet has no aliases.

## DESCRIPTION

Creates a new tenant using the NetBox API endpoint 'tenancy/tenants' and returns the created tenant.

References to other objects, such as a site or a tenant, accept IDs or the objects returned by the Get cmdlets.
Objects with properties matching the parameter names or the NetBox field names can be piped to the cmdlet,
for example rows from Import-Csv or tenant objects returned by Get-NbxTenant.

## EXAMPLES

### EXAMPLE 1

```powershell
New-NbxTenant -Name 'Contoso'
```

Creates a new tenant.

### EXAMPLE 2

```powershell
New-NbxTenant -Name 'Contoso' -Description 'Created with NetboxTools' -OptionalAttribute @{ custom_fields = @{ owner = 'IT' } }
```

Creates a new tenant with a description and a custom field value.

### EXAMPLE 3

```powershell
Import-Csv -Path .\tenants.csv | New-NbxTenant
```

Creates a tenant for each row in a CSV file.
Columns are matched to parameters by name or NetBox field name.

## PARAMETERS

### -Comments

Comments about the tenant.
Supports Markdown.

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
  Position: 6
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Description

A short description of the tenant.

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
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Group

The tenant group.
Accepts an ID or a NetBox object.

```yaml
Type: System.Nullable`1[System.UInt64]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 2
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Name

The name of the tenant.

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
  Position: 7
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Slug

The URL-friendly unique name of the tenant.
Generated from the name when not specified.

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
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Tag

The tags of the tenant.
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
  Position: 5
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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Management.Automation.PSObject

You can pipe objects with properties matching the parameter names or NetBox field names to this cmdlet.

## OUTPUTS

### NetboxTools.Tenant

## NOTES

## RELATED LINKS

- [Get-NbxTenant](Get-NbxTenant.md)
- [Set-NbxTenant](Set-NbxTenant.md)
- [Remove-NbxTenant](Remove-NbxTenant.md)
