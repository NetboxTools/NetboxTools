---
document type: cmdlet
external help file: NetboxTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: NetboxTools
PlatyPS schema version: 2024-05-01
title: Get-NbxContactAssignment
---

# Get-NbxContactAssignment

## SYNOPSIS

Gets contact assignments from NetBox.

## SYNTAX

### Query (Default)

```
Get-NbxContactAssignment [-Query <hashtable>] [-All] [-Limit <int>] [<CommonParameters>]
```

### Id

```
Get-NbxContactAssignment -Id <ulong[]> [<CommonParameters>]
```

## ALIASES

This cmdlet has no aliases.

## DESCRIPTION

Gets contact assignments from the NetBox API endpoint 'tenancy/contact-assignments'.
Without parameters all contact assignments are returned,
the cmdlet follows the pagination of the API.

Contact assignment objects are returned as they are returned by the API, with the type name 'NetboxTools.ContactAssignment',
and can be piped to the other cmdlets of the module.

## EXAMPLES

### EXAMPLE 1

```powershell
Get-NbxContactAssignment
```

Gets all contact assignments.

### EXAMPLE 2

```powershell
Get-NbxContactAssignment -Id 42
```

Gets the contact assignment with ID 42.

### EXAMPLE 3

```powershell
Get-NbxContactAssignment -Query @{ q = 'example' } -Limit 10
```

Gets the first 10 contact assignments matching the search 'example'.

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

The ID of the contact assignment to get.
Accepts contact assignment objects from the pipeline.

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

The maximum number of contact assignments to return.
By default all matching contact assignments are returned.

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

### NetboxTools.ContactAssignment

You can pipe contact assignment IDs or contact assignment objects to this cmdlet.

## OUTPUTS

### NetboxTools.ContactAssignment

## NOTES

## RELATED LINKS

- [New-NbxContactAssignment](New-NbxContactAssignment.md)
- [Set-NbxContactAssignment](Set-NbxContactAssignment.md)
- [Remove-NbxContactAssignment](Remove-NbxContactAssignment.md)
