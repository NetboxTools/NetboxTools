function Get-NbxDCIMCable {

    [CmdletBinding()]
    #region Parameters
    param
    (
        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [uint64[]]$Id

    )

    if ($Id) {
        $Id | ForEach-Object {
            InvokeNbxRestMethod -URI "$($script:NbxConfig.URI)/dcim/cables/$($_)" -Method GET
        }
    }
    else {
        InvokeNbxRestMethod -URI "$($script:NbxConfig.URI)/dcim/cables?limit=9999" -Method GET
    }

}
