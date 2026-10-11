---
document type: cmdlet
external help file: NetboxTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: NetboxTools
PlatyPS schema version: 2024-05-01
title: Get-NbxAPIDefinition
---

# Get-NbxAPIDefinition

## SYNOPSIS

Gets the OpenAPI definition of the NetBox API.

## SYNTAX

### __AllParameterSets

```
Get-NbxAPIDefinition [[-Format] <string>] [[-Language] <string>] [<CommonParameters>]
```

## ALIASES

This cmdlet has no aliases.

## DESCRIPTION

Gets the OpenAPI schema of the connected NetBox instance from the API endpoint 'schema'.
The schema describes all endpoints, filters and fields available in the instance.

## EXAMPLES

### EXAMPLE 1

```powershell
$Definition = Get-NbxAPIDefinition
$Definition.paths.PSObject.Properties.Name
```

Lists all paths of the API.

### EXAMPLE 2

```powershell
Get-NbxAPIDefinition -Format yaml | Set-Content -Path .\netbox-openapi.yaml
```

Saves the API definition as YAML.

## PARAMETERS

### -Format

The format of the definition, json (default) or yaml.

```yaml
Type: System.String
DefaultValue: json
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Language

The language of the descriptions in the definition.
Defaults to 'en'.

```yaml
Type: System.String
DefaultValue: en
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 1
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Management.Automation.PSObject

### System.String

## NOTES

## RELATED LINKS

- [NetboxTools on GitHub](https://github.com/SebastianClaesson/NetboxTools)

