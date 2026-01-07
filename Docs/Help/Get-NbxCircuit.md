---
external help file: netboxTools-help.xml
Module Name: netboxTools
online version:
schema: 2.0.0
---

# Get-NbxCircuit

## SYNOPSIS
Gets one or more circuits

## SYNTAX

### Query (Default)
```
Get-NbxCircuit [-CID <String>] [-InstallDate <DateTime>] [-CommitRate <UInt64>] [-Query <String>]
 [-Provider <Object>] [-Type <Object>] [-Site <String>] [-Tenant <String>] [-Limit <UInt16>] [-Offset <UInt16>]
 [-Raw] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### ById
```
Get-NbxCircuit [-Id <UInt64[]>] [-Raw] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
A detailed description of the Get-NbxCircuit function.

## EXAMPLES

### EXAMPLE 1
```
Get-NbxCircuit
```

## PARAMETERS

### -Id
Database ID of circuit.
This will query for exactly the IDs provided

```yaml
Type: UInt64[]
Parameter Sets: ById
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CID
Circuit ID

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

### -InstallDate
Date of installation

```yaml
Type: DateTime
Parameter Sets: Query
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CommitRate
Committed rate in Kbps

```yaml
Type: UInt64
Parameter Sets: Query
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Query
A raw search query...
As if you were searching the web site

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

### -Provider
The name or ID of the provider.
Provide either \[string\] or \[uint64\].
String will search provider names, integer will search database IDs

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

### -Type
Type of circuit.
Provide either \[string\] or \[uint64\].
String will search provider type names, integer will search database IDs

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

### -Site
Location/site of circuit.
Provide either \[string\] or \[uint64\].
String will search site names, integer will search database IDs

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
Tenant assigned to circuit.
Provide either \[string\] or \[uint64\].
String will search tenant names, integer will search database IDs

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

### -Limit
A description of the Limit parameter.

```yaml
Type: UInt16
Parameter Sets: Query
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Offset
A description of the Offset parameter.

```yaml
Type: UInt16
Parameter Sets: Query
Aliases:

Required: False
Position: Named
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

