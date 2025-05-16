function Set-NbxHostPort {

    [CmdletBinding(ConfirmImpact = 'Low',
                   SupportsShouldProcess = $true)]
    [OutputType([string])]
    param
    (
        [Parameter(Mandatory = $true)]
        [uint16]$Port
    )

    if ($PSCmdlet.ShouldProcess('Nbx Port', 'Set')) {
        $script:NbxConfig.HostPort = $Port
        $script:NbxConfig.HostPort
    }

}
