function Get-NbxTimeout {

    [CmdletBinding()]
    [OutputType([uint16])]
    param ()

    Write-Verbose "Getting Nbx Timeout"
    if ($null -eq $script:NbxConfig.Timeout) {
        Write-warning "Nbx Timeout is not set! Defaulting to 30 seconds. You may set it with Set-NbxTimeout -TimeoutSeconds [uint16]"
        return 30
    } else {
        $script:NbxConfig.Timeout
    }
}
