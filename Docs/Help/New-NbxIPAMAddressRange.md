---
external help file: netboxTools-help.xml
Module Name: netboxTools
online version:
schema: 2.0.0
---

# New-NbxIPAMAddressRange

## SYNOPSIS
Create a new IP address range to Netbox

## SYNTAX

```
New-NbxIPAMAddressRange [-Start_Address] <String> [-End_Address] <String> [[-Status] <Object>]
 [[-Tenant] <UInt64>] [[-VRF] <UInt64>] [[-Role] <Object>] [[-Custom_Fields] <Hashtable>]
 [[-Description] <String>] [[-Comments] <String>] [[-Tags] <Object[]>] [-Mark_Utilized] [-Raw]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Create a new IP address range to Netbox with a status of Active by default.
The maximum supported
size of an IP range is 2^32 - 1.

## EXAMPLES

### EXAMPLE 1
```
New-NbxIPAMAddressRange -Start_Address 192.0.2.20/24 -End_Address 192.0.2.20/24
```

Add new IP Address range from 192.0.2.20/24 to 192.0.2.20/24 with status active

## PARAMETERS

### -Start_Address
Starting IPv4 or IPv6 address (with mask).
The maximum supported size of an IP range is 2^32 - 1.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -End_Address
Ending IPv4 or IPv6 address (with mask).
The maximum supported size of an IP range is 2^32 - 1.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Status
Operational status of this range.
Defaults to Active

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: Active
Accept pipeline input: False
Accept wildcard characters: False
```

### -Tenant
Tenant ID

```yaml
Type: UInt64
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -VRF
VRF ID

```yaml
Type: UInt64
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Role
Role such as backup, customer, development, etc...
Defaults to nothing

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Custom_Fields
Custom field hash table.
Will be validated by the API service

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
Description of IP address range

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

### -Comments
Extra comments (markdown supported).

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

### -Tags
One or more tags.

```yaml
Type: Object[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Mark_Utilized
Treat as 100% utilized

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Raw
Return raw results from API service

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```



### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Management.Automation.PSObject
## NOTES
https://Nbx.neonet.org/static/docs/models/ipam/iprange/

## RELATED LINKS

