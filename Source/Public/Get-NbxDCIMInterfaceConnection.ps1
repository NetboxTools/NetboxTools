function Get-NbxDCIMInterfaceConnection {

    [CmdletBinding()]
    param ()

    InvokeNbxRestMethod -URI "$($script:NbxConfig.URI)/dcim/interface-connections/?limit=9999" -Method GET

}
