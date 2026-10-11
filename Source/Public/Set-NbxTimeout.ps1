function Set-NbxTimeout {
    <#
    .SYNOPSIS
        Sets the timeout in seconds of the NetBox connection.

    .DESCRIPTION
        Sets the number of seconds to wait for a response from the NetBox API before the request fails. The default is 30 seconds.

    .PARAMETER TimeoutSeconds
        The timeout in seconds.

    .PARAMETER PassThru
        Returns the new timeout in seconds. By default, this cmdlet does not generate any output.

    .PARAMETER WhatIf
        Shows what would happen if the cmdlet runs. The cmdlet is not run.

    .PARAMETER Confirm
        Prompts you for confirmation before running the cmdlet.

    .EXAMPLE
        Set-NbxTimeout -TimeoutSeconds 60

        Sets the timeout in seconds to 60.

    .INPUTS
        None

    .OUTPUTS
        None, int

    .LINK
        Get-NbxTimeout
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    [OutputType([int])]
    param (
        [Parameter(Mandatory, Position = 0)]
        [ValidateRange(1, 3600)]
        [int]$TimeoutSeconds,

        [Parameter()]
        [switch]$PassThru
    )

    if ($PSCmdlet.ShouldProcess('NetBox connection', "Set timeout in seconds to '$TimeoutSeconds'")) {
        $script:NbxConfig.Timeout = $TimeoutSeconds
        if ($PassThru) {
            $script:NbxConfig.Timeout
        }
    }
}
