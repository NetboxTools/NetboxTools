---
document type: cmdlet
external help file: NetboxTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: NetboxTools
PlatyPS schema version: 2024-05-01
title: Get-NbxVirtualMachine
---

# Get-NbxVirtualMachine

## SYNOPSIS

Gets virtual machines from NetBox.

## SYNTAX

### Query (Default)

```
Get-NbxVirtualMachine [-Name <string[]>] [-Query <hashtable>] [-All] [-Limit <int>]
 [<CommonParameters>]
```

### Id

```
Get-NbxVirtualMachine -Id <ulong[]> [<CommonParameters>]
```

## ALIASES

This cmdlet has no aliases.

## DESCRIPTION

Gets virtual machines from the NetBox API endpoint 'virtualization/virtual-machines'.
Without parameters all virtual machines are returned,
the cmdlet follows the pagination of the API.

Virtual machine objects are returned as they are returned by the API, with the type name 'NetboxTools.VirtualMachine',
and can be piped to the other cmdlets of the module.

## EXAMPLES

### EXAMPLE 1

```powershell
Get-NbxVirtualMachine
```

Gets all virtual machines.

### EXAMPLE 2

```powershell
Get-NbxVirtualMachine -Id 42
```

Gets the virtual machine with ID 42.

### EXAMPLE 3

```powershell
Get-NbxVirtualMachine -Name 'example'
```

Gets virtual machines where the name is 'example'.

### EXAMPLE 4

```powershell
Get-NbxVirtualMachine -Query @{ q = 'example' } -Limit 10
```

Gets the first 10 virtual machines matching the search 'example'.

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

The ID of the virtual machine to get.
Accepts virtual machine objects from the pipeline.

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

The maximum number of virtual machines to return.
By default all matching virtual machines are returned.

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

Filters virtual machines by name.
Multiple values return virtual machines matching any of the values.

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

### NetboxTools.VirtualMachine

You can pipe virtual machine IDs or virtual machine objects to this cmdlet.

## OUTPUTS

### NetboxTools.VirtualMachine

## NOTES

## RELATED LINKS

- [New-NbxVirtualMachine](New-NbxVirtualMachine.md)
- [Set-NbxVirtualMachine](Set-NbxVirtualMachine.md)
- [Remove-NbxVirtualMachine](Remove-NbxVirtualMachine.md)
