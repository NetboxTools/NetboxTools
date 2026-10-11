---
document type: cmdlet
external help file: NetboxTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: NetboxTools
PlatyPS schema version: 2024-05-01
title: Get-NbxDCIMFrontPort
---

# Get-NbxDCIMFrontPort

## SYNOPSIS

Gets front ports from NetBox.

## SYNTAX

### Query (Default)

```
Get-NbxDCIMFrontPort [-Name <string[]>] [-Query <hashtable>] [-All] [-Limit <int>]
 [<CommonParameters>]
```

### Id

```
Get-NbxDCIMFrontPort -Id <ulong[]> [<CommonParameters>]
```

## ALIASES

This cmdlet has no aliases.

## DESCRIPTION

Gets front ports from the NetBox API endpoint 'dcim/front-ports'.
Without parameters all front ports are returned,
the cmdlet follows the pagination of the API.

Front port objects are returned as they are returned by the API, with the type name 'NetboxTools.DCIMFrontPort',
and can be piped to the other cmdlets of the module.

## EXAMPLES

### EXAMPLE 1

```powershell
Get-NbxDCIMFrontPort
```

Gets all front ports.

### EXAMPLE 2

```powershell
Get-NbxDCIMFrontPort -Id 42
```

Gets the front port with ID 42.

### EXAMPLE 3

```powershell
Get-NbxDCIMFrontPort -Name 'example'
```

Gets front ports where the name is 'example'.

### EXAMPLE 4

```powershell
Get-NbxDCIMFrontPort -Query @{ q = 'example' } -Limit 10
```

Gets the first 10 front ports matching the search 'example'.

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

The ID of the front port to get.
Accepts front port objects from the pipeline.

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

The maximum number of front ports to return.
By default all matching front ports are returned.

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

Filters front ports by name.
Multiple values return front ports matching any of the values.

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

### NetboxTools.DCIMFrontPort

You can pipe front port IDs or front port objects to this cmdlet.

## OUTPUTS

### NetboxTools.DCIMFrontPort

## NOTES

## RELATED LINKS

- [New-NbxDCIMFrontPort](New-NbxDCIMFrontPort.md)
- [Set-NbxDCIMFrontPort](Set-NbxDCIMFrontPort.md)
- [Remove-NbxDCIMFrontPort](Remove-NbxDCIMFrontPort.md)
