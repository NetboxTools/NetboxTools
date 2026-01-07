---
external help file: netboxTools-help.xml
Module Name: netboxTools
online version:
schema: 2.0.0
---

# Get-NbxContentType

## SYNOPSIS
Get a content type definition from Netbox

## SYNTAX

### Query (Default)
```
Get-NbxContentType [[-Model] <String>] [-App_Label <String>] [-Query <String>] [-Limit <UInt16>]
 [-Offset <UInt16>] [-Raw] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### ByID
```
Get-NbxContentType [-Id <UInt64[]>] [-Raw] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
A detailed description of the Get-NbxContentType function.

## EXAMPLES

### EXAMPLE 1
```
Get-NbxContentType
```

## PARAMETERS

### -Model
A description of the Model parameter.

```yaml
Type: String
Parameter Sets: Query
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id
The database ID of the contact role

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

### -App_Label
A description of the App_Label parameter.

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
A standard search query that will match one or more contact roles.

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
Limit the number of results to this number

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
Start the search at this index in results

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
Return the unparsed data from the HTTP request

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

