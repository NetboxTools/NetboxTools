function Get-NbxVersion {
    <#
    .SYNOPSIS
        Gets the version and status of the NetBox instance.

    .DESCRIPTION
        Gets the status of the connected NetBox instance from the API endpoint 'status', including the NetBox,
        Django and Python versions, installed apps and plugins and the number of running workers.

    .EXAMPLE
        (Get-NbxVersion).'netbox-version'

        Gets the version of the connected NetBox instance.

    .INPUTS
        None

    .OUTPUTS
        NetboxTools.Status
    #>
    [CmdletBinding()]
    [OutputType('NetboxTools.Status')]
    param ()

    InvokeNbxRestMethod -Endpoint 'status/' -TypeName 'NetboxTools.Status'
}
