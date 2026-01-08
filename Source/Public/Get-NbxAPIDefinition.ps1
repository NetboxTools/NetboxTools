function Get-NbxAPIDefinition {

    [CmdletBinding()]
    param
    (
        [ValidateSet('json', 'yaml', IgnoreCase = $true)]
        [string]$Format = 'json'
    )

    InvokeNbxRestMethod -URI "$($script:NbxConfig.URI)/schema/?format=$Format" -Method GET

}