function Set-NbxHostScheme {

    [CmdletBinding(ConfirmImpact = 'Low',
                   SupportsShouldProcess = $true)]
    [OutputType([string])]
    param
    (
        [Parameter(Mandatory = $false)]
        [ValidateSet('https', 'http', IgnoreCase = $true)]
        [string]$Scheme = 'https'
    )

    if ($PSCmdlet.ShouldProcess('Nbx Host Scheme', 'Set')) {
        if ($Scheme -eq 'http') {
            Write-Warning "Connecting via non-secure HTTP is not-recommended"
        }

        $script:NbxConfig.HostScheme = $Scheme
        $script:NbxConfig.HostScheme
    }

}
