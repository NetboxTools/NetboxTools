function Set-NbxHostPort {
    <#
    .SYNOPSIS
        Sets the port of the NetBox connection.

    .DESCRIPTION
        Sets the port of the NetBox API used by the current connection. The port is usually set by Connect-NbxAPI.

    .PARAMETER Port
        The port.

    .PARAMETER PassThru
        Returns the new port. By default, this cmdlet does not generate any output.

    .PARAMETER WhatIf
        Shows what would happen if the cmdlet runs. The cmdlet is not run.

    .PARAMETER Confirm
        Prompts you for confirmation before running the cmdlet.

    .EXAMPLE
        Set-NbxHostPort -Port 8443

        Sets the port to 8443.

    .INPUTS
        None

    .OUTPUTS
        None, int

    .LINK
        Get-NbxHostPort
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    [OutputType([int])]
    param (
        [Parameter(Mandatory, Position = 0)]
        [ValidateRange(1, 65535)]
        [int]$Port,

        [Parameter()]
        [switch]$PassThru
    )

    if ($PSCmdlet.ShouldProcess('NetBox connection', "Set port to '$Port'")) {
        $script:NbxConfig.Port = $Port
        UpdateNbxUri
        if ($PassThru) {
            $script:NbxConfig.Port
        }
    }
}
