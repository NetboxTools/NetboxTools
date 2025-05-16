function Clear-NbxCredential {

    [CmdletBinding(ConfirmImpact = 'Medium', SupportsShouldProcess = $true)]
    param
    (
        [switch]$Force
    )

    if ($Force -or ($PSCmdlet.ShouldProcess('Nbx Credentials', 'Clear'))) {
        $script:NbxConfig.Credential = $null
    }

}
