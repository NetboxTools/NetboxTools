---
external help file: netboxTools-help.xml
Module Name: netboxTools
online version:
schema: 2.0.0
---

# Get-NbxContactAssignment

## SYNOPSIS
Get a contact Assignment from Netbox

## SYNTAX

### Query (Default)
```
Get-NbxContactAssignment [[-Name] <String>] [-Content_Type_Id <UInt64>] [-Content_Type <String>]
 [-Object_Id <UInt64>] [-Contact_Id <UInt64>] [-Role_Id <UInt64>] [-Limit <UInt16>] [-Offset <UInt16>] [-Raw]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### ByID
```
Get-NbxContactAssignment [-Id <UInt64[]>] [-Raw] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
A detailed description of the Get-NbxContactAssignment function.

## EXAMPLES

### EXAMPLE 1
```
Get-NbxContactAssignment
```

## PARAMETERS

### -Name
The specific name of the contact Assignment.
Must match exactly as is defined in Netbox

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
The database ID of the contact Assignment

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

### -Content_Type_Id
A description of the Content_Type_Id parameter.

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

### -Content_Type
A description of the Content_Type parameter.

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

### -Object_Id
A description of the Object_Id parameter.

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

### -Contact_Id
A description of the Contact_Id parameter.

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

### -Role_Id
A description of the Role_Id parameter.

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

