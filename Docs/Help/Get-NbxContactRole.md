---
document type: cmdlet
external help file: NetboxTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: NetboxTools
PlatyPS schema version: 2024-05-01
title: Get-NbxContactRole
---

# Get-NbxContactRole

## SYNOPSIS

Gets contact roles from NetBox.

## SYNTAX

### Query (Default)

```
Get-NbxContactRole [-Name <string[]>] [-Query <hashtable>] [-All] [-Limit <int>]
 [<CommonParameters>]
```

### Id

```
Get-NbxContactRole -Id <ulong[]> [<CommonParameters>]
```

## ALIASES

This cmdlet has no aliases.

## DESCRIPTION

Gets contact roles from the NetBox API endpoint 'tenancy/contact-roles'.
Without parameters all contact roles are returned,
the cmdlet follows the pagination of the API.

Contact role objects are returned as they are returned by the API, with the type name 'NetboxTools.ContactRole',
and can be piped to the other cmdlets of the module.

## EXAMPLES

### EXAMPLE 1

```powershell
Get-NbxContactRole
```

Gets all contact roles.

### EXAMPLE 2

```powershell
Get-NbxContactRole -Id 42
```

Gets the contact role with ID 42.

### EXAMPLE 3

```powershell
Get-NbxContactRole -Name 'example'
```

Gets contact roles where the name is 'example'.

### EXAMPLE 4

```powershell
Get-NbxContactRole -Query @{ q = 'example' } -Limit 10
```

Gets the first 10 contact roles matching the search 'example'.

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

The ID of the contact role to get.
Accepts contact role objects from the pipeline.

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

The maximum number of contact roles to return.
By default all matching contact roles are returned.

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

Filters contact roles by name.
Multiple values return contact roles matching any of the values.

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

### NetboxTools.ContactRole

You can pipe contact role IDs or contact role objects to this cmdlet.

## OUTPUTS

### NetboxTools.ContactRole

## NOTES

## RELATED LINKS

- [New-NbxContactRole](New-NbxContactRole.md)
- [Set-NbxContactRole](Set-NbxContactRole.md)
- [Remove-NbxContactRole](Remove-NbxContactRole.md)
