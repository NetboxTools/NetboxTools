---
external help file: netboxTools-help.xml
Module Name: netboxTools
online version:
schema: 2.0.0
---

# Get-NbxIPAMAvailablePrefix

## SYNOPSIS
A convenience method for returning available range within a prefix

## SYNTAX

```
Get-NbxIPAMAvailablePrefix [-Prefix_ID] <UInt64> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
By default, the number of IPs returned will be equivalent to PAGINATE_COUNT.
An arbitrary limit
(up to MAX_PAGE_SIZE, if set) may be passed, however results will not be paginated

## EXAMPLES

### EXAMPLE 1
```
Get-NbxIPAMAvailableIP -Prefix_ID (Get-NbxIPAMPrefix -Prefix 192.0.2.0/24).id
```

Get (Next) Available IP on the Prefix 192.0.2.0/24

### EXAMPLE 2
```
Get-NbxIPAMAvailableIP -Prefix_ID 2 -NumberOfIPs 3
```

Get 3 (Next) Available IP on the Prefix 192.0.2.0/24

## PARAMETERS

### -Prefix_ID
A description of the Prefix_ID parameter.

```yaml
Type: UInt64
Parameter Sets: (All)
Aliases: Id

Required: True
Position: 1
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```



### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Additional information about the function.

## RELATED LINKS
