function CheckNbxIsConnected {

    [CmdletBinding()]
    param ()

    Write-Verbose "Checking connection status"
    if (-not $script:NbxConfig.Connected) {
        throw "Not connected to a Nbx API! Please run 'Connect-NbxAPI'"
    }

}
