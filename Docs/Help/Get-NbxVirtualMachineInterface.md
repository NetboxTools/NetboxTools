---
document type: cmdlet
external help file: NetboxTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: NetboxTools
PlatyPS schema version: 2024-05-01
title: Get-NbxVirtualMachineInterface
---

# Get-NbxVirtualMachineInterface

## SYNOPSIS

Gets virtual machine interfaces from NetBox.

## SYNTAX

### Query (Default)

```
Get-NbxVirtualMachineInterface [-Name <string[]>] [-Query <hashtable>] [-All] [-Limit <int>]
 [<CommonParameters>]
```

### Id

```
Get-NbxVirtualMachineInterface -Id <ulong[]> [<CommonParameters>]
```

## ALIASES

This cmdlet has no aliases.

## DESCRIPTION

Gets virtual machine interfaces from the NetBox API endpoint 'virtualization/interfaces'.
Without parameters all virtual machine interfaces are returned,
the cmdlet follows the pagination of the API.

Virtual machine interface objects are returned as they are returned by the API, with the type name 'NetboxTools.VirtualMachineInterface',
and can be piped to the other cmdlets of the module.

## EXAMPLES

### EXAMPLE 1

```powershell
Get-NbxVirtualMachineInterface
```

Gets all virtual machine interfaces.

### EXAMPLE 2

```powershell
Get-NbxVirtualMachineInterface -Id 42
```

Gets the virtual machine interface with ID 42.

### EXAMPLE 3

```powershell
Get-NbxVirtualMachineInterface -Name 'example'
```

Gets virtual machine interfaces where the name is 'example'.

### EXAMPLE 4

```powershell
Get-NbxVirtualMachineInterface -Query @{ q = 'example' } -Limit 10
```

Gets the first 10 virtual machine interfaces matching the search 'example'.

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

The ID of the virtual machine interface to get.
Accepts virtual machine interface objects from the pipeline.

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

The maximum number of virtual machine interfaces to return.
By default all matching virtual machine interfaces are returned.

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

Filters virtual machine interfaces by name.
Multiple values return virtual machine interfaces matching any of the values.

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

### NetboxTools.VirtualMachineInterface

You can pipe virtual machine interface IDs or virtual machine interface objects to this cmdlet.

## OUTPUTS

### NetboxTools.VirtualMachineInterface

## NOTES

## RELATED LINKS

- [New-NbxVirtualMachineInterface](New-NbxVirtualMachineInterface.md)
- [Set-NbxVirtualMachineInterface](Set-NbxVirtualMachineInterface.md)
- [Remove-NbxVirtualMachineInterface](Remove-NbxVirtualMachineInterface.md)
