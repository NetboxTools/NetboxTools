---
document type: cmdlet
external help file: NetboxTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: NetboxTools
PlatyPS schema version: 2024-05-01
title: Remove-NbxVirtualMachine
---

# Remove-NbxVirtualMachine

## SYNOPSIS

Removes virtual machines from NetBox.

## SYNTAX

### __AllParameterSets

```
Remove-NbxVirtualMachine [-Id] <ulong[]> [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

This cmdlet has no aliases.

## DESCRIPTION

Removes one or more virtual machines using the NetBox API endpoint 'virtualization/virtual-machines'.
You are asked for confirmation before each object is removed, unless -Force or -Confirm:$false is specified.

## EXAMPLES

### EXAMPLE 1

```powershell
Remove-NbxVirtualMachine -Id 42
```

Removes the virtual machine with ID 42 after confirmation.

### EXAMPLE 2

```powershell
Get-NbxVirtualMachine -Query @{ q = 'example' } | Remove-NbxVirtualMachine -Force
```

Removes all virtual machines matching the search 'example' without confirmation.

## PARAMETERS

### -Confirm

Prompts you for confirmation before running the cmdlet.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- cf
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Force

Removes the object without asking for confirmation.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
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

The ID of the virtual machine to remove.
Accepts virtual machine objects from the pipeline.

```yaml
Type: System.UInt64[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
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

### -WhatIf

Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- wi
ParameterSets:
- Name: (All)
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

### None

This cmdlet does not return output.

## NOTES

## RELATED LINKS

- [Get-NbxVirtualMachine](Get-NbxVirtualMachine.md)
- [New-NbxVirtualMachine](New-NbxVirtualMachine.md)
- [Set-NbxVirtualMachine](Set-NbxVirtualMachine.md)
