---
external help file: netboxTools-help.xml
Module Name: netboxTools
online version:
schema: 2.0.0
---

# Add-NbxDCIMInterfaceConnection

## SYNOPSIS
Create a new connection between two interfaces

## SYNTAX

```
Add-NbxDCIMInterfaceConnection [[-Connection_Status] <Object>] [-Interface_A] <UInt64> [-Interface_B] <UInt64>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Create a new connection between two interfaces

## EXAMPLES

### EXAMPLE 1
```
Add-NbxDCIMInterfaceConnection -Interface_A $value1 -Interface_B $value2
```

## PARAMETERS

### -Connection_Status
Is it connected or planned?

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Interface_A
Database ID of interface A

```yaml
Type: UInt64
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Interface_B
Database ID of interface B

```yaml
Type: UInt64
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Management.Automation.PSObject
## NOTES
Additional information about the function.

## RELATED LINKS

