function Set-NbxUntrustedSSL {
    <#
    .SYNOPSIS
        Skips certificate validation for the NetBox connection. Deprecated.

    .DESCRIPTION
        Skips validation of the certificate of the NetBox instance, for example when it uses a self-signed certificate.

        This cmdlet is deprecated and will be removed in a future version.
        Use Connect-NbxAPI -SkipCertificateCheck or Set-NbxInvokeParameter -InvokeParameter @{ SkipCertificateCheck = $true } instead.

    .PARAMETER WhatIf
        Shows what would happen if the cmdlet runs. The cmdlet is not run.

    .PARAMETER Confirm
        Prompts you for confirmation before running the cmdlet.

    .EXAMPLE
        Set-NbxUntrustedSSL

        Skips certificate validation for requests to the NetBox API.

    .INPUTS
        None

    .OUTPUTS
        None

    .LINK
        Connect-NbxAPI
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    [OutputType([void])]
    param ()

    Write-Warning 'Set-NbxUntrustedSSL is deprecated. Use Connect-NbxAPI -SkipCertificateCheck instead.'
    if ($PSCmdlet.ShouldProcess('NetBox connection', 'Skip certificate validation')) {
        $script:NbxConfig.InvokeParams['SkipCertificateCheck'] = $true
    }
}
