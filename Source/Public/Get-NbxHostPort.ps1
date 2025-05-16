function Get-NbxHostPort {

    [CmdletBinding()]
    param ()

    Write-Verbose "Getting Nbx host port"
    if ($null -eq $script:NbxConfig.HostPort) {
        throw "Nbx host port is not set! You may set it with Set-NbxHostPort -Port 'https'"
    }

    $script:NbxConfig.HostPort

}
