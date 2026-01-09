function Get-NbxDCIMSite {

    [CmdletBinding()]
    param
    (
        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [uint64]$Id
    )

    if ($Id) {
        $Id | ForEach-Object {
            InvokeNbxRestMethod -URI "$($script:NbxConfig.URI)/dcim/sites/$($_)/" -Method GET
        }
    }
    else {
        InvokeNbxRestMethod -URI "$($script:NbxConfig.URI)/dcim/sites/?limit=9999" -Method GET
    }

}
