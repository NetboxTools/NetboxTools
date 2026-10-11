function Get-NbxAPIDefinition {
    <#
    .SYNOPSIS
        Gets the OpenAPI definition of the NetBox API.

    .DESCRIPTION
        Gets the OpenAPI schema of the connected NetBox instance from the API endpoint 'schema'.
        The schema describes all endpoints, filters and fields available in the instance.

    .PARAMETER Format
        The format of the definition, json (default) or yaml.

    .PARAMETER Language
        The language of the descriptions in the definition. Defaults to 'en'.

    .EXAMPLE
        $Definition = Get-NbxAPIDefinition
        $Definition.paths.PSObject.Properties.Name

        Lists all paths of the API.

    .EXAMPLE
        Get-NbxAPIDefinition -Format yaml | Set-Content -Path .\netbox-openapi.yaml

        Saves the API definition as YAML.

    .INPUTS
        None

    .OUTPUTS
        System.Management.Automation.PSObject, System.String
    #>
    [CmdletBinding()]
    [OutputType([psobject], [string])]
    param (
        [Parameter()]
        [ValidateSet('json', 'yaml')]
        [string]$Format = 'json',

        [Parameter()]
        [string]$Language = 'en'
    )

    InvokeNbxRestMethod -Endpoint 'schema/' -Query ([ordered]@{ format = $Format; lang = $Language })
}
