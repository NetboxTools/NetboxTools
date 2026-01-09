function Get-NbxDCIMInterface {

    [CmdletBinding()]
    param ()

    InvokeNbxRestMethod -URI "$($script:NbxConfig.URI)/dcim/interfaces/?limit=9999" -Method GET

}
