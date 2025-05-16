function Set-NbxTimeout {

    [CmdletBinding(ConfirmImpact = 'Low',
                   SupportsShouldProcess = $true)]
    [OutputType([uint16])]
    param
    (
        [Parameter(Mandatory = $false)]
        [ValidateRange(1, 65535)]
        [uint16]$TimeoutSeconds = 30
    )

    if ($PSCmdlet.ShouldProcess('Nbx Timeout', 'Set')) {
        $script:NbxConfig.Timeout = $TimeoutSeconds
        $script:NbxConfig.Timeout
    }

}
