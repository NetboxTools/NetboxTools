---
external help file: netboxTools-help.xml
Module Name: netboxTools
online version:
schema: 2.0.0
---

# New-NbxIPAMAddress

## SYNOPSIS
Create a new IP address to Netbox

## SYNTAX

```
New-NbxIPAMAddress [-Address] <String> [[-Status] <Object>] [[-Tenant] <UInt64>] [[-VRF] <UInt64>]
 [[-Role] <Object>] [[-NAT_Inside] <UInt64>] [[-Custom_Fields] <Hashtable>] [[-Interface] <UInt64>]
 [[-Description] <String>] [[-Dns_name] <String>] [[-Assigned_Object_Type] <String>]
 [[-Assigned_Object_Id] <UInt64>] [-Raw] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Create a new IP address to Netbox with a status of Active by default.

## EXAMPLES

### EXAMPLE 1
```
New-NbxIPAMAddress -Address 192.0.2.1/32
```

Add new IP Address 192.0.2.1/32 with status active

## PARAMETERS

### -Address
IP address in CIDR notation: 192.168.1.1/24

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Status
Status of the IP.
Defaults to Active

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
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
Position: 3
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
Position: 4
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Role
Role such as anycast, loopback, etc...
Defaults to nothing

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NAT_Inside
ID of IP for NAT

```yaml
Type: UInt64
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: 0
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

### -Interface
ID of interface to apply IP

```yaml
Type: UInt64
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
Description of IP address

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

### -Dns_name
DNS Name of IP address (example : netbox.example.com)

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

### -Assigned_Object_Type
Assigned Object Type dcim.interface or virtualization.vminterface

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 11
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Assigned_Object_Id
Assigned Object ID

```yaml
Type: UInt64
Parameter Sets: (All)
Aliases:

Required: False
Position: 12
Default value: 0
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
Additional information about the function.

## RELATED LINKS

