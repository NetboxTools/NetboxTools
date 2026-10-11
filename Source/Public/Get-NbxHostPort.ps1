function Get-NbxHostPort {
    <#
    .SYNOPSIS
        Gets the port of the NetBox connection.

    .DESCRIPTION
        Gets the port used to connect to the NetBox API. The port is set by Connect-NbxAPI or Set-NbxHostPort and defaults to 443.

    .EXAMPLE
        Get-NbxHostPort

        Gets the port.

    .INPUTS
        None

    .OUTPUTS
        int

    .LINK
        Set-NbxHostPort
    #>
    [CmdletBinding()]
    [OutputType([int])]
    param ()

    $script:NbxConfig.Port
}
