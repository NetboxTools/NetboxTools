---
document type: cmdlet
external help file: NetboxTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: NetboxTools
PlatyPS schema version: 2024-05-01
title: Get-NbxCircuitProvider
---

# Get-NbxCircuitProvider

## SYNOPSIS

Gets circuit providers from NetBox.

## SYNTAX

### Query (Default)

```
Get-NbxCircuitProvider [-Name <string[]>] [-Query <hashtable>] [-All] [-Limit <int>]
 [<CommonParameters>]
```

### Id

```
Get-NbxCircuitProvider -Id <ulong[]> [<CommonParameters>]
```

## ALIASES

This cmdlet has no aliases.

## DESCRIPTION

Gets circuit providers from the NetBox API endpoint 'circuits/providers'.
Without parameters all circuit providers are returned,
the cmdlet follows the pagination of the API.

Circuit provider objects are returned as they are returned by the API, with the type name 'NetboxTools.CircuitProvider',
and can be piped to the other cmdlets of the module.

## EXAMPLES

### EXAMPLE 1

```powershell
Get-NbxCircuitProvider
```

Gets all circuit providers.

### EXAMPLE 2

```powershell
Get-NbxCircuitProvider -Id 42
```

Gets the circuit provider with ID 42.

### EXAMPLE 3

```powershell
Get-NbxCircuitProvider -Name 'example'
```

Gets circuit providers where the name is 'example'.

### EXAMPLE 4

```powershell
Get-NbxCircuitProvider -Query @{ q = 'example' } -Limit 10
```

Gets the first 10 circuit providers matching the search 'example'.

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

The ID of the circuit provider to get.
Accepts circuit provider objects from the pipeline.

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

The maximum number of circuit providers to return.
By default all matching circuit providers are returned.

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

Filters circuit providers by name.
Multiple values return circuit providers matching any of the values.

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

### NetboxTools.CircuitProvider

You can pipe circuit provider IDs or circuit provider objects to this cmdlet.

## OUTPUTS

### NetboxTools.CircuitProvider

## NOTES

## RELATED LINKS

- [NetboxTools on GitHub](https://github.com/SebastianClaesson/NetboxTools)

