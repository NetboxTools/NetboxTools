function Get-NbxHostname {

    [CmdletBinding()]
    param ()

    Write-Verbose "Getting Nbx hostname"
    if ($null -eq $script:NbxConfig.Hostname) {
        throw "Nbx Hostname is not set! You may set it with Set-NbxHostname -Hostname 'hostname.domain.tld'"
    }

    $script:NbxConfig.Hostname

}
