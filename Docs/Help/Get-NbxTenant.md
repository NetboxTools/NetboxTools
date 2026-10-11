---
document type: cmdlet
external help file: NetboxTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: NetboxTools
PlatyPS schema version: 2024-05-01
title: Get-NbxTenant
---

# Get-NbxTenant

## SYNOPSIS

Gets tenants from NetBox.

## SYNTAX

### Query (Default)

```
Get-NbxTenant [-Name <string[]>] [-Query <hashtable>] [-All] [-Limit <int>] [<CommonParameters>]
```

### Id

```
Get-NbxTenant -Id <ulong[]> [<CommonParameters>]
```

## ALIASES

This cmdlet has no aliases.

## DESCRIPTION

Gets tenants from the NetBox API endpoint 'tenancy/tenants'.
Without parameters all tenants are returned,
the cmdlet follows the pagination of the API.

Tenant objects are returned as they are returned by the API, with the type name 'NetboxTools.Tenant',
and can be piped to the other cmdlets of the module.

## EXAMPLES

### EXAMPLE 1

```powershell
Get-NbxTenant
```

Gets all tenants.

### EXAMPLE 2

```powershell
Get-NbxTenant -Id 42
```

Gets the tenant with ID 42.

### EXAMPLE 3

```powershell
Get-NbxTenant -Name 'example'
```

Gets tenants where the name is 'example'.

### EXAMPLE 4

```powershell
Get-NbxTenant -Query @{ q = 'example' } -Limit 10
```

Gets the first 10 tenants matching the search 'example'.

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

The ID of the tenant to get.
Accepts tenant objects from the pipeline.

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

The maximum number of tenants to return.
By default all matching tenants are returned.

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

Filters tenants by name.
Multiple values return tenants matching any of the values.

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

### NetboxTools.Tenant

You can pipe tenant IDs or tenant objects to this cmdlet.

## OUTPUTS

### NetboxTools.Tenant

## NOTES

## RELATED LINKS

- [New-NbxTenant](New-NbxTenant.md)
- [Set-NbxTenant](Set-NbxTenant.md)
- [Remove-NbxTenant](Remove-NbxTenant.md)
