function Get-NbxHostScheme {
    <#
    .SYNOPSIS
        Gets the scheme of the NetBox connection.

    .DESCRIPTION
        Gets the scheme used to connect to the NetBox API. The scheme is set by Connect-NbxAPI or Set-NbxHostScheme and defaults to 'https'.

    .EXAMPLE
        Get-NbxHostScheme

        Gets the scheme.

    .INPUTS
        None

    .OUTPUTS
        string

    .LINK
        Set-NbxHostScheme
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param ()

    $script:NbxConfig.Scheme
}
