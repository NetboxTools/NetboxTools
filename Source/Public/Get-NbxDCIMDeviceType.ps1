function Get-NbxDCIMDeviceType {

    [CmdletBinding()]
    param ()

    InvokeNbxRestMethod -URI "$($script:NbxConfig.URI)/dcim/device-types/?limit=9999" -Method GET

}
