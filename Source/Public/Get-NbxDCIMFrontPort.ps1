function Get-NbxDCIMFrontPort {

    [CmdletBinding()]
    param ()

    InvokeNbxRestMethod -URI "$($script:NbxConfig.URI)/dcim/front-ports/?limit=9999" -Method GET

}
