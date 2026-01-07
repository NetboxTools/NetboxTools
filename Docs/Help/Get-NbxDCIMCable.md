---
external help file: netboxTools-help.xml
Module Name: netboxTools
online version:
schema: 2.0.0
---

# Get-NbxDCIMCable

## SYNOPSIS
{{ Fill in the Synopsis }}

## SYNTAX

```
Get-NbxDCIMCable [[-Limit] <UInt16>] [[-Offset] <UInt16>] [[-Id] <UInt64[]>] [[-Label] <String>]
 [[-Termination_A_Type] <String>] [[-Termination_A_ID] <UInt64>] [[-Termination_B_Type] <String>]
 [[-Termination_B_ID] <UInt64>] [[-Type] <String>] [[-Status] <String>] [[-Color] <String>]
 [[-Device_ID] <UInt64>] [[-Device] <String>] [[-Rack_Id] <UInt64>] [[-Rack] <String>]
 [[-Location_ID] <UInt64>] [[-Location] <String>] [-Raw] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Specifies the in the parameter.

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -Color
Specifies the Color parameter.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Device
Specifies the Device parameter.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 12
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Device_ID
Specifies the Device_ID parameter.

```yaml
Type: UInt64
Parameter Sets: (All)
Aliases:

Required: False
Position: 11
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id
Specifies the Id parameter.

```yaml
Type: UInt64[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Label
Specifies the Label parameter.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Limit
Specifies the Limit parameter.

```yaml
Type: UInt16
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Location
Specifies the Location parameter.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 16
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Location_ID
Specifies the Location_ID parameter.

```yaml
Type: UInt64
Parameter Sets: (All)
Aliases:

Required: False
Position: 15
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Offset
Specifies the Offset parameter.

```yaml
Type: UInt16
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Rack
Specifies the Rack parameter.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 14
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Rack_Id
Specifies the Rack_Id parameter.

```yaml
Type: UInt64
Parameter Sets: (All)
Aliases:

Required: False
Position: 13
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Raw
When set, returns raw API data.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Status
Specifies the Status parameter.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Termination_A_ID
Specifies Termination_A_ID.

```yaml
Type: UInt64
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Termination_A_Type
Specifies Termination_A_Type.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Termination_B_ID
Specifies Termination_B_ID.

```yaml
Type: UInt64
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Termination_B_Type
Specifies Termination_B_Type.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Type
Specifies the Type parameter.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```



### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.UInt64[]

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS

