---
external help file: netboxTools-help.xml
Module Name: netboxTools
online version:
schema: 2.0.0
---

# Get-NbxVirtualizationCluster

## SYNOPSIS
Obtains virtualization clusters from Netbox.

## SYNTAX

```
Get-NbxVirtualizationCluster [[-Name] <String>] [[-Query] <String>] [[-Id] <UInt64[]>] [[-Group] <String>]
 [[-Group_Id] <UInt64>] [[-Type] <String>] [[-Type_Id] <UInt64>] [[-Site] <String>] [[-Site_Id] <UInt64>]
 [[-Limit] <UInt16>] [[-Offset] <UInt16>] [-Raw] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Obtains one or more virtualization clusters based on provided filters.

## EXAMPLES

### EXAMPLE 1
```
Get-NbxVirtualizationCluster
```

## PARAMETERS

### -Name
Name of the cluster

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Query
A general query used to search for a cluster

```yaml
Type: String
Parameter Sets: (All)
Aliases: q

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id
Database ID(s) of the cluster

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

### -Group
String value of the cluster group.

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

### -Group_Id
Database ID of the cluster group.

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

### -Type
String value of the Cluster type.

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

### -Type_Id
Database ID of the cluster type.

```yaml
Type: UInt64
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
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
Position: 8
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
Position: 9
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
Position: 10
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
Position: 11
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

