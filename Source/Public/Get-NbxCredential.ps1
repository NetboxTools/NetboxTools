function Get-NbxCredential {

    [CmdletBinding()]
    [OutputType([pscredential])]
    param ()

    if (-not $script:NbxConfig.Credential) {
        throw "Nbx Credentials not set! You may set with Set-Nbxcredential"
    }

    $script:NbxConfig.Credential

}
