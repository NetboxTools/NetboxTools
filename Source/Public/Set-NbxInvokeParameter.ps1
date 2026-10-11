function Set-NbxInvokeParameter {
    <#
    .SYNOPSIS
        Sets the invoke parameters of the NetBox connection.

    .DESCRIPTION
        Sets additional parameters for Invoke-RestMethod used for all requests to the NetBox API, such as @{ SkipCertificateCheck = $true } or @{ Proxy = 'http://proxy:8080' }.
        Replaces the parameters set before. SkipCertificateCheck keeps the value of the connection unless it is specified,
        and Headers are added to the headers of the module without replacing the Authorization header.

    .PARAMETER InvokeParameter
        The invoke parameters.

    .PARAMETER PassThru
        Returns the new invoke parameters. By default, this cmdlet does not generate any output.

    .PARAMETER WhatIf
        Shows what would happen if the cmdlet runs. The cmdlet is not run.

    .PARAMETER Confirm
        Prompts you for confirmation before running the cmdlet.

    .EXAMPLE
        Set-NbxInvokeParameter -InvokeParameter @{ SkipCertificateCheck = $true }

        Sets the invoke parameters to @{ SkipCertificateCheck = $true }.

    .INPUTS
        None

    .OUTPUTS
        None, hashtable

    .LINK
        Connect-NbxAPI
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    [OutputType([hashtable])]
    param (
        [Parameter(Mandatory, Position = 0)]
        [Alias('InvokeParams')]
        [hashtable]$InvokeParameter,

        [Parameter()]
        [switch]$PassThru
    )

    if ($PSCmdlet.ShouldProcess('NetBox connection', "Set invoke parameters to '$(($InvokeParameter.GetEnumerator() | ForEach-Object { "$($_.Key)=$($_.Value)" }) -join '; ')'")) {
        # Store a copy so later changes to the caller's hashtable do not change the configuration, and keep the
        # certificate validation of the connection unless it is specified
        $NewInvokeParams = @{} + $InvokeParameter
        if (-not $NewInvokeParams.ContainsKey('SkipCertificateCheck')) {
            $NewInvokeParams['SkipCertificateCheck'] = [bool]$script:NbxConfig.InvokeParams['SkipCertificateCheck']
        }
        $script:NbxConfig.InvokeParams = $NewInvokeParams
        if ($PassThru) {
            $script:NbxConfig.InvokeParams
        }
    }
}
