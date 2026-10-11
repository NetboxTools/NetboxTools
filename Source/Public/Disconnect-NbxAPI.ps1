function Disconnect-NbxAPI {
    <#
    .SYNOPSIS
        Disconnects from the NetBox API.

    .DESCRIPTION
        Removes the connection and API token from the session and resets the module configuration,
        including the timeout and invoke parameters, to the defaults.

    .EXAMPLE
        Disconnect-NbxAPI

        Disconnects from the NetBox API.

    .INPUTS
        None

    .OUTPUTS
        None

    .LINK
        Connect-NbxAPI
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param ()

    $script:NbxConfig = NewNbxConfig
    Write-Verbose 'Disconnected from NetBox.'
}
