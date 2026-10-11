function Get-NbxTimeout {
    <#
    .SYNOPSIS
        Gets the timeout in seconds of the NetBox connection.

    .DESCRIPTION
        Gets the timeout in seconds used to connect to the NetBox API. The timeout is set by Set-NbxTimeout and defaults to 30 seconds.

    .EXAMPLE
        Get-NbxTimeout

        Gets the timeout in seconds.

    .INPUTS
        None

    .OUTPUTS
        int

    .LINK
        Set-NbxTimeout
    #>
    [CmdletBinding()]
    [OutputType([int])]
    param ()

    $script:NbxConfig.Timeout
}
