---
document type: cmdlet
external help file: NetboxTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: NetboxTools
PlatyPS schema version: 2024-05-01
title: Get-NbxDCIMInterface
---

# Get-NbxDCIMInterface

## SYNOPSIS

Gets interfaces from NetBox.

## SYNTAX

### Query (Default)

```
Get-NbxDCIMInterface [-Name <string[]>] [-Query <hashtable>] [-All] [-Limit <int>]
 [<CommonParameters>]
```

### Id

```
Get-NbxDCIMInterface -Id <ulong[]> [<CommonParameters>]
```

## ALIASES

This cmdlet has no aliases.

## DESCRIPTION

Gets interfaces from the NetBox API endpoint 'dcim/interfaces'.
Without parameters all interfaces are returned,
the cmdlet follows the pagination of the API.

Interface objects are returned as they are returned by the API, with the type name 'NetboxTools.DCIMInterface',
and can be piped to the other cmdlets of the module.

## EXAMPLES

### EXAMPLE 1

```powershell
Get-NbxDCIMInterface
```

Gets all interfaces.

### EXAMPLE 2

```powershell
Get-NbxDCIMInterface -Id 42
```

Gets the interface with ID 42.

### EXAMPLE 3

```powershell
Get-NbxDCIMInterface -Name 'example'
```

Gets interfaces where the name is 'example'.

### EXAMPLE 4

```powershell
Get-NbxDCIMInterface -Query @{ q = 'example' } -Limit 10
```

Gets the first 10 interfaces matching the search 'example'.

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

The ID of the interface to get.
Accepts interface objects from the pipeline.

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

The maximum number of interfaces to return.
By default all matching interfaces are returned.

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

Filters interfaces by name.
Multiple values return interfaces matching any of the values.

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

### NetboxTools.DCIMInterface

You can pipe interface IDs or interface objects to this cmdlet.

## OUTPUTS

### NetboxTools.DCIMInterface

## NOTES

## RELATED LINKS

- [New-NbxDCIMInterface](New-NbxDCIMInterface.md)
- [Set-NbxDCIMInterface](Set-NbxDCIMInterface.md)
- [Remove-NbxDCIMInterface](Remove-NbxDCIMInterface.md)
