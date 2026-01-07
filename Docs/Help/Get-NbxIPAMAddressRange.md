---
external help file: netboxTools-help.xml
Module Name: netboxTools
online version:
schema: 2.0.0
---

# Get-NbxIPAMAddressRange

## SYNOPSIS
{{ Fill in the Synopsis }}

## SYNTAX

### Query (Default)
```
Get-NbxIPAMAddressRange [[-Range] <String>] [-Query <String>] [-Family <Object>] [-VRF <String>]
 [-VRF_Id <UInt32>] [-Tenant <String>] [-Tenant_Id <UInt32>] [-Status <Object>] [-Role <Object>]
 [-Limit <UInt16>] [-Offset <UInt16>] [-Raw] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### ByID
```
Get-NbxIPAMAddressRange [-Id <UInt64[]>] [-Raw] [-ProgressAction <ActionPreference>] [<CommonParameters>]
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

### -Query
Specifies a Query string to filter results.

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

### -Range
Specifies the Range parameter.

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
Type: UInt32
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
Type: UInt32
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

