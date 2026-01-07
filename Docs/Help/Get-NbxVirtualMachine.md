---
external help file: netboxTools-help.xml
Module Name: netboxTools
online version:
schema: 2.0.0
---

# Get-NbxVirtualMachine

## SYNOPSIS
Obtains virtual machines from Netbox.

## SYNTAX

```
Get-NbxVirtualMachine [[-Query] <String>] [[-Name] <String>] [[-Id] <UInt64[]>] [[-Status] <Object>]
 [[-Tenant] <String>] [[-Tenant_ID] <UInt64>] [[-Platform] <String>] [[-Platform_ID] <UInt64>]
 [[-Cluster_Group] <String>] [[-Cluster_Group_Id] <UInt64>] [[-Cluster_Type] <String>]
 [[-Cluster_Type_Id] <UInt64>] [[-Cluster_Id] <UInt64>] [[-Site] <String>] [[-Site_Id] <UInt64>]
 [[-Role] <String>] [[-Role_Id] <UInt64>] [[-Limit] <UInt16>] [[-Offset] <UInt16>] [-Raw]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Obtains one or more virtual machines based on provided filters.

## EXAMPLES

### EXAMPLE 1
```
Get-NbxVirtualMachine
```

## PARAMETERS

### -Query
A general query used to search for a VM

```yaml
Type: String
Parameter Sets: (All)
Aliases: q

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Name of the VM

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

### -Id
Database ID of the VM

```yaml
Type: UInt64[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Status
Status of the VM

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

### -Tenant
String value of tenant

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Tenant_ID
Database ID of the tenant.

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

### -Platform
String value of the platform

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

### -Platform_ID
Database ID of the platform

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

### -Cluster_Group
String value of the cluster group.

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

### -Cluster_Group_Id
Database ID of the cluster group.

```yaml
Type: UInt64
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Cluster_Type
String value of the Cluster type.

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

### -Cluster_Type_Id
Database ID of the cluster type.

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

### -Cluster_Id
Database ID of the cluster.

```yaml
Type: UInt64
Parameter Sets: (All)
Aliases:

Required: False
Position: 13
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Site
String value of the site.

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

### -Site_Id
Database ID of the site.

```yaml
Type: UInt64
Parameter Sets: (All)
Aliases:

Required: False
Position: 15
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Role
String value of the role.

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

### -Role_Id
Database ID of the role.

```yaml
Type: UInt64
Parameter Sets: (All)
Aliases:

Required: False
Position: 17
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Limit
Number of results to return per page

```yaml
Type: UInt16
Parameter Sets: (All)
Aliases:

Required: False
Position: 18
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Offset
The initial index from which to return the results

```yaml
Type: UInt16
Parameter Sets: (All)
Aliases:

Required: False
Position: 19
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Raw
A description of the Raw parameter.

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



### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Additional information about the function.

## RELATED LINKS

