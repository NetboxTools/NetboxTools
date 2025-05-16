function Get-NbxTimeout {

    [CmdletBinding()]
    [OutputType([uint16])]
    param ()

    Write-Verbose "Getting Nbx Timeout"
    if ($null -eq $script:NbxConfig.Timeout) {
        throw "Nbx Timeout is not set! You may set it with Set-NbxTimeout -TimeoutSeconds [uint16]"
    }

    $script:NbxConfig.Timeout

}
