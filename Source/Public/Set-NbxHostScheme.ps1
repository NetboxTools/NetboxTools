function Set-NbxHostScheme {
    <#
    .SYNOPSIS
        Sets the scheme of the NetBox connection.

    .DESCRIPTION
        Sets the scheme of the NetBox API used by the current connection. The scheme is usually set by Connect-NbxAPI.
        When the port is the default port of the current scheme (443 for https, 80 for http), the port is changed
        to the default port of the new scheme.

    .PARAMETER Scheme
        The scheme.

    .PARAMETER PassThru
        Returns the new scheme. By default, this cmdlet does not generate any output.

    .PARAMETER WhatIf
        Shows what would happen if the cmdlet runs. The cmdlet is not run.

    .PARAMETER Confirm
        Prompts you for confirmation before running the cmdlet.

    .EXAMPLE
        Set-NbxHostScheme -Scheme 'https'

        Sets the scheme to 'https'.

    .INPUTS
        None

    .OUTPUTS
        None, string

    .LINK
        Get-NbxHostScheme
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    [OutputType([string])]
    param (
        [Parameter(Mandatory, Position = 0)]
        [ValidateSet('https', 'http')]
        [string]$Scheme,

        [Parameter()]
        [switch]$PassThru
    )

    if ($PSCmdlet.ShouldProcess('NetBox connection', "Set scheme to '$Scheme'")) {
        if ($Scheme -eq 'http') {
            Write-Warning 'Connecting to NetBox over http, the API token is sent unencrypted.'
        }
        # Follow the scheme with the port when the port is the default port of the previous scheme
        $DefaultPorts = @{ 'https' = 443; 'http' = 80 }
        if ($script:NbxConfig.Port -eq $DefaultPorts[$script:NbxConfig.Scheme]) {
            $script:NbxConfig.Port = $DefaultPorts[$Scheme]
        }
        $script:NbxConfig.Scheme = $Scheme
        UpdateNbxUri
        if ($PassThru) {
            $script:NbxConfig.Scheme
        }
    }
}
