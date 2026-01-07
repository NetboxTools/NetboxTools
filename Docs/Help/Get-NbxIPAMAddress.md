---
external help file: netboxTools-help.xml
Module Name: netboxTools
online version:
schema: 2.0.0
---

# Get-NbxIPAMAddress

## SYNOPSIS
{{ Fill in the Synopsis }}

## SYNTAX

### Query (Default)
```
Get-NbxIPAMAddress [[-Address] <String>] [-Query <String>] [-Family <Object>] [-Parent <String>]
 [-Mask_Length <Byte>] [-VRF <String>] [-VRF_Id <UInt64>] [-Tenant <String>] [-Tenant_Id <UInt64>]
 [-Device <String>] [-Device_ID <UInt64>] [-Virtual_Machine <String>] [-Virtual_Machine_Id <UInt64>]
 [-Interface_Id <UInt64>] [-Status <Object>] [-Role <Object>] [-Limit <UInt16>] [-Offset <UInt16>] [-Raw]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### ByID
```
Get-NbxIPAMAddress [-Id <UInt64[]>] [-Raw] [-ProgressAction <ActionPreference>] [<CommonParameters>]
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

### -Address
Specifies the Address parameter.

```yaml
Type: String
Parameter Sets: Query
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Device
Specifies the Device to filter addresses.

```yaml
Type: String
Parameter Sets: Query
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Device_ID
Specifies the Device_ID parameter.

```yaml
Type: UInt64
Parameter Sets: Query
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Family
Specifies the Family parameter.

```yaml
Type: Object
Parameter Sets: Query
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id
Specifies the Id parameter.

```yaml
Type: UInt64[]
Parameter Sets: ByID
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Interface_Id
Specifies the Interface_Id parameter.

```yaml
Type: UInt64
Parameter Sets: Query
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Limit
Specifies the Limit parameter.

```yaml
Type: UInt16
Parameter Sets: Query
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Mask_Length
Specifies the Mask_Length parameter.

```yaml
Type: Byte
Parameter Sets: Query
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Offset
Specifies the Offset parameter.

```yaml
Type: UInt16
Parameter Sets: Query
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Parent
Specifies the Parent parameter.

```yaml
Type: String
Parameter Sets: Query
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Query
Specifies the Query parameter.

```yaml
Type: String
Parameter Sets: Query
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Raw
Specifies the Raw parameter.

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

### -Role
Specifies the Role parameter.

```yaml
Type: Object
Parameter Sets: Query
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
Type: Object
Parameter Sets: Query
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Tenant
Specifies the Tenant parameter.

```yaml
Type: String
Parameter Sets: Query
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Tenant_Id
Specifies the Tenant_Id parameter.

```yaml
Type: UInt64
Parameter Sets: Query
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -VRF
Specifies the VRF parameter.

```yaml
Type: String
Parameter Sets: Query
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -VRF_Id
Specifies the VRF_Id parameter.

```yaml
Type: UInt64
Parameter Sets: Query
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Virtual_Machine
Specifies the Virtual_Machine parameter.

```yaml
Type: String
Parameter Sets: Query
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Virtual_Machine_Id
Specifies the Virtual_Machine_Id parameter.

```yaml
Type: UInt64
Parameter Sets: Query
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```



### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS

