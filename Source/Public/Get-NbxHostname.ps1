function Get-NbxHostname {
    <#
    .SYNOPSIS
        Gets the hostname of the NetBox connection.

    .DESCRIPTION
        Gets the hostname used to connect to the NetBox API. The hostname is set by Connect-NbxAPI or Set-NbxHostname.

    .EXAMPLE
        Get-NbxHostname

        Gets the hostname.

    .INPUTS
        None

    .OUTPUTS
        string

    .LINK
        Set-NbxHostname
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param ()

    if ([string]::IsNullOrEmpty($script:NbxConfig.Hostname)) {
        $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new(
                [System.InvalidOperationException]::new('The NetBox hostname is not set. Run Connect-NbxAPI first.'),
                'NbxNotConnected',
                [System.Management.Automation.ErrorCategory]::ConnectionError,
                $null
            ))
    }

    $script:NbxConfig.Hostname
}
