function Set-NbxInvokeParams {

    [CmdletBinding(ConfirmImpact = 'Low',
        SupportsShouldProcess = $true)]
    [OutputType([string])]
    param(
        [Parameter(Mandatory = $true)]
        [array]$InvokeParams
    )

    if ($PSCmdlet.ShouldProcess('Nbx Invoke Params', 'Set')) {
        $script:NbxConfig.InvokeParams = $InvokeParams
        $script:NbxConfig.InvokeParams
    }

}
