---
document type: cmdlet
external help file: NetboxTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: NetboxTools
PlatyPS schema version: 2024-05-01
title: Get-NbxIPAMPrefix
---

# Get-NbxIPAMPrefix

## SYNOPSIS

Gets prefixes from NetBox.

## SYNTAX

### Query (Default)

```
Get-NbxIPAMPrefix [-Prefix <string[]>] [-Query <hashtable>] [-All] [-Limit <int>]
 [<CommonParameters>]
```

### Id

```
Get-NbxIPAMPrefix -Id <ulong[]> [<CommonParameters>]
```

## ALIASES

This cmdlet has no aliases.

## DESCRIPTION

Gets prefixes from the NetBox API endpoint 'ipam/prefixes'.
Without parameters all prefixes are returned,
the cmdlet follows the pagination of the API.

Prefix objects are returned as they are returned by the API, with the type name 'NetboxTools.IPAMPrefix',
and can be piped to the other cmdlets of the module.

## EXAMPLES

### EXAMPLE 1

```powershell
Get-NbxIPAMPrefix
```

Gets all prefixes.

### EXAMPLE 2

```powershell
Get-NbxIPAMPrefix -Id 42
```

Gets the prefix with ID 42.

### EXAMPLE 3

```powershell
Get-NbxIPAMPrefix -Prefix 'example'
```

Gets prefixes where the prefix is 'example'.

### EXAMPLE 4

```powershell
Get-NbxIPAMPrefix -Query @{ q = 'example' } -Limit 10
```

Gets the first 10 prefixes matching the search 'example'.

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

The ID of the prefix to get.
Accepts prefix objects from the pipeline.

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

The maximum number of prefixes to return.
By default all matching prefixes are returned.

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

### -Prefix

Filters prefixes by prefix.
Multiple values return prefixes matching any of the values.

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

### NetboxTools.IPAMPrefix

You can pipe prefix IDs or prefix objects to this cmdlet.

## OUTPUTS

### NetboxTools.IPAMPrefix

## NOTES

## RELATED LINKS

- [New-NbxIPAMPrefix](New-NbxIPAMPrefix.md)
- [Set-NbxIPAMPrefix](Set-NbxIPAMPrefix.md)
- [Remove-NbxIPAMPrefix](Remove-NbxIPAMPrefix.md)
