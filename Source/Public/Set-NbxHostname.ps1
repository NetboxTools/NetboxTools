function Set-NbxHostname {
    <#
    .SYNOPSIS
        Sets the hostname of the NetBox connection.

    .DESCRIPTION
        Sets the hostname of the NetBox instance used by the current connection. The hostname is usually set by Connect-NbxAPI.

    .PARAMETER Hostname
        The hostname.

    .PARAMETER PassThru
        Returns the new hostname. By default, this cmdlet does not generate any output.

    .PARAMETER WhatIf
        Shows what would happen if the cmdlet runs. The cmdlet is not run.

    .PARAMETER Confirm
        Prompts you for confirmation before running the cmdlet.

    .EXAMPLE
        Set-NbxHostname -Hostname 'netbox.example.com'

        Sets the hostname to 'netbox.example.com'.

    .INPUTS
        None

    .OUTPUTS
        None, string

    .LINK
        Get-NbxHostname
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    [OutputType([string])]
    param (
        [Parameter(Mandatory, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]$Hostname,

        [Parameter()]
        [switch]$PassThru
    )

    if ($PSCmdlet.ShouldProcess('NetBox connection', "Set hostname to '$Hostname'")) {
        $script:NbxConfig.Hostname = $Hostname
        UpdateNbxUri
        if ($PassThru) {
            $script:NbxConfig.Hostname
        }
    }
}
