function Get-NbxCredential {

    [CmdletBinding()]
    [OutputType([pscredential])]
    param ()

    if (-not $script:NbxConfig.Token) {
        throw "Nbx Credentials not set! Please run Connect-NbxAPI with valid credentials."
    }

    $script:NbxConfig.Token

}