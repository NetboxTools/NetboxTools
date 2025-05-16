function Set-NbxHostName {

    [CmdletBinding(ConfirmImpact = 'Low',
        SupportsShouldProcess = $true)]
    [OutputType([string])]
    param
    (
        [Parameter(Mandatory = $true)]
        [string]$Hostname
    )

    if ($PSCmdlet.ShouldProcess('Nbx Hostname', 'Set')) {
        $script:NbxConfig.Hostname = $Hostname.Trim()
        $script:NbxConfig.Hostname
    }

}
