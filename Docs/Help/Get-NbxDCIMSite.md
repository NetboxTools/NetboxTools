---
external help file: netboxTools-help.xml
Module Name: netboxTools
online version:
schema: 2.0.0
---

# Get-NbxDCIMSite

## SYNOPSIS
{{ Fill in the Synopsis }}

## SYNTAX

### Query (Default)
```
Get-NbxDCIMSite [-Name <String>] [-Query <String>] [-Slug <String>] [-Facility <String>] [-ASN <UInt64>]
 [-Latitude <Decimal>] [-Longitude <Decimal>] [-Contact_Name <String>] [-Contact_Phone <String>]
 [-Contact_Email <String>] [-Tenant_Group_ID <UInt64>] [-Tenant_Group <String>] [-Tenant_ID <UInt64>]
 [-Tenant <String>] [-Status <String>] [-Region_ID <UInt64>] [-Region <String>] [-Limit <UInt16>]
 [-Offset <UInt16>] [-Raw] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### ByID
```
Get-NbxDCIMSite [-Id <UInt64>] [-Raw] [-ProgressAction <ActionPreference>] [<CommonParameters>]
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

### -ASN
Specifies the ASN parameter.

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

### -Contact_Email
Specifies contact email.

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

### -Contact_Name
Specifies contact name.

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

### -Contact_Phone
Specifies contact phone number.

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

### -Facility
Specifies the Facility parameter.

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

### -Id
Specifies the Site Id.

```yaml
Type: UInt64
Parameter Sets: ByID
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Latitude
Specifies the latitude coordinate.

```yaml
Type: Decimal
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

### -Longitude
Specifies the Longitude parameter.

```yaml
Type: Decimal
Parameter Sets: Query
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Specifies the Name parameter.

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

### -Region
Specifies the Region parameter.

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

### -Region_ID
Specifies the Region_ID parameter.

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

### -Slug
Specifies the Slug parameter.

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

### -Status
Specifies the Status parameter.

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

### -Tenant_Group
Specifies the Tenant_Group parameter.

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

### -Tenant_Group_ID
Specifies the Tenant_Group_ID parameter.

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

### -Tenant_ID
Specifies the Tenant_ID parameter.

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

### System.UInt64

## OUTPUTS

### System.Management.Automation.PSObject

## NOTES

## RELATED LINKS

