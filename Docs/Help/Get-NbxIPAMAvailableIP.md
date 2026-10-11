---
document type: cmdlet
external help file: NetboxTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: NetboxTools
PlatyPS schema version: 2024-05-01
title: Get-NbxIPAMAvailableIP
---

# Get-NbxIPAMAvailableIP

## SYNOPSIS

Gets available IP addresses within a prefix.

## SYNTAX

### __AllParameterSets

```
Get-NbxIPAMAvailableIP [-Prefix] <ulong[]> [[-Query] <hashtable>] [[-Limit] <int>]
 [<CommonParameters>]
```

## ALIASES

This cmdlet has no aliases.

## DESCRIPTION

Gets the IP addresses within a prefix that are not in use, from the NetBox API endpoint 'ipam/prefixes/{id}/available-ips'.

## EXAMPLES

### EXAMPLE 1

```powershell
Get-NbxIPAMPrefix -Prefix '192.0.2.0/24' | Get-NbxIPAMAvailableIP -Limit 1
```

Gets the next available IP address in the prefix 192.0.2.0/24.

## PARAMETERS

### -Limit

The maximum number of IP addresses to return for each prefix.

```yaml
Type: System.Int32
DefaultValue: 0
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

### -Prefix

The ID of the prefix.
Accepts prefix objects from Get-NbxIPAMPrefix, also from the pipeline.

```yaml
Type: System.UInt64[]
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Id
- Prefix_ID
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

### -Query

Filters supported by the NetBox API as a hashtable, e.g.
@{ vrf_id = 2 }.

```yaml
Type: System.Collections.Hashtable
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

### System.Management.Automation.PSObject

## NOTES

## RELATED LINKS

- [Get-NbxIPAMPrefix](Get-NbxIPAMPrefix.md)
