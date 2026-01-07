---
external help file: netboxTools-help.xml
Module Name: netboxTools
online version:
schema: 2.0.0
---

# Set-NbxDCIMInterface

## SYNOPSIS
{{ Fill in the Synopsis }}

## SYNTAX

```
Set-NbxDCIMInterface [-Id] <UInt64[]> [[-Device] <UInt64>] [[-Name] <String>] [[-Enabled] <Boolean>]
 [[-Form_Factor] <Object>] [[-Type] <String>] [[-MTU] <UInt16>] [[-MAC_Address] <String>]
 [[-MGMT_Only] <Boolean>] [[-LAG] <UInt64>] [[-Description] <String>] [[-Mode] <String>]
 [[-Untagged_VLAN] <UInt16>] [[-Tagged_VLANs] <UInt16[]>] [-Force] [-ProgressAction <ActionPreference>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
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

### -Description
Specifies the Description parameter.

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
Type: UInt64
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Enabled
Specifies the Enabled parameter.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Force
Specifies the Force parameter.

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

### -Form_Factor
Specifies the Form_Factor parameter.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
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

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -LAG
Specifies the LAG parameter.

```yaml
Type: UInt64
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MAC_Address
Specifies the MAC_Address parameter.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MGMT_Only
Specifies the MGMT_Only parameter.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MTU
Specifies the MTU parameter.

```yaml
Type: UInt16
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Mode
Specifies the Mode parameter.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: Access, Tagged, Tagged All, 100, 200, 300

Required: False
Position: 11
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Specifies the Name parameter.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Tagged_VLANs
Specifies the Tagged_VLANs parameter.

```yaml
Type: UInt16[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 13
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
Accepted values: virtual, bridge, lag, 100base-tx, 1000base-t, 2.5gbase-t, 5gbase-t, 10gbase-t, 10gbase-cx4, 1000base-x-gbic, 1000base-x-sfp, 10gbase-x-sfpp, 10gbase-x-xfp, 10gbase-x-xenpak, 10gbase-x-x2, 25gbase-x-sfp28, 50gbase-x-sfp56, 40gbase-x-qsfpp, 50gbase-x-sfp28, 100gbase-x-cfp, 100gbase-x-cfp2, 200gbase-x-cfp2, 100gbase-x-cfp4, 100gbase-x-cpak, 100gbase-x-qsfp28, 200gbase-x-qsfp56, 400gbase-x-qsfpdd, 400gbase-x-osfp, 1000base-kx, 10gbase-kr, 10gbase-kx4, 25gbase-kr, 40gbase-kr4, 50gbase-kr, 100gbase-kp4, 100gbase-kr2, 100gbase-kr4, ieee802.11a, ieee802.11g, ieee802.11n, ieee802.11ac, ieee802.11ad, ieee802.11ax, ieee802.11ay, ieee802.15.1, other-wireless, gsm, cdma, lte, sonet-oc3, sonet-oc12, sonet-oc48, sonet-oc192, sonet-oc768, sonet-oc1920, sonet-oc3840, 1gfc-sfp, 2gfc-sfp, 4gfc-sfp, 8gfc-sfpp, 16gfc-sfpp, 32gfc-sfp28, 64gfc-qsfpp, 128gfc-qsfp28, infiniband-sdr, infiniband-ddr, infiniband-qdr, infiniband-fdr10, infiniband-fdr, infiniband-edr, infiniband-hdr, infiniband-ndr, infiniband-xdr, t1, e1, t3, e3, xdsl, docsis, gpon, xg-pon, xgs-pon, ng-pon2, epon, 10g-epon, cisco-stackwise, cisco-stackwise-plus, cisco-flexstack, cisco-flexstack-plus, cisco-stackwise-80, cisco-stackwise-160, cisco-stackwise-320, cisco-stackwise-480, juniper-vcp, extreme-summitstack, extreme-summitstack-128, extreme-summitstack-256, extreme-summitstack-512, other

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Untagged_VLAN
Specifies the Untagged_VLAN parameter.

```yaml
Type: UInt16
Parameter Sets: (All)
Aliases:

Required: False
Position: 12
Default value: None
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



### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.UInt64[]

## OUTPUTS

### System.Management.Automation.PSObject

## NOTES

## RELATED LINKS

