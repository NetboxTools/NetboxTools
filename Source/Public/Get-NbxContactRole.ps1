function Get-NbxContactRole {

<#
    .SYNOPSIS
        Get a contact role from Netbox

    .DESCRIPTION
        A detailed description of the Get-NbxContactRole function.

    .PARAMETER Name
        The specific name of the contact role. Must match exactly as is defined in Netbox

    .PARAMETER Id
        The database ID of the contact role

    .EXAMPLE
        PS C:\> Get-NbxContactRole

    .NOTES
        Additional information about the function.
#>

    [CmdletBinding()]
    param
    (
        [Parameter()]
        [uint64[]]$Id
    )

    if ($Id) {
        $Id | ForEach-Object {
            InvokeNbxRestMethod -URI "$($script:NbxConfig.URI)/tenancy/contact-roles/$($_)/" -Method GET
        }
    }
    else {
        InvokeNbxRestMethod -URI "$($script:NbxConfig.URI)/tenancy/contact-roles/?limit=9999" -Method GET
    }

}
