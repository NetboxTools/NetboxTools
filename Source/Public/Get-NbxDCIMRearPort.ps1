function Get-NbxDCIMRearPort {

    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param ()

    InvokeNbxRestMethod -URI "$($script:NbxConfig.URI)/dcim/rear-ports/?limit=9999" -Method GET
    
}
