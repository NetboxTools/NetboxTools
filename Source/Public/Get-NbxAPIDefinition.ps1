function Get-NbxAPIDefinition {

    [CmdletBinding()]
    param
    (
        [ValidateSet('json', 'yaml', IgnoreCase = $true)]
        [string]$Format = 'json'
    )

    InvokeNbxRestMethod -URI "$($script:NbxConfig.URI)/api/schema" -Method GET

}