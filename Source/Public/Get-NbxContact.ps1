function Get-NbxContact {

    <#
    .SYNOPSIS
        Get a contact from Netbox

    .DESCRIPTION
        Obtain a contact or contacts from Netbox by ID or query

    .PARAMETER Name
        The specific name of the Contact. Must match exactly as is defined in Netbox

    .PARAMETER Id
        The database ID of the Contact

    .EXAMPLE
        PS C:\> Get-NbxContact

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
            InvokeNbxRestMethod -URI "$($script:NbxConfig.URI)/tenancy/contacts/$($_)" -Method GET
        }
    }
    else {
        InvokeNbxRestMethod -URI "$($script:NbxConfig.URI)/tenancy/contacts?limit=9999" -Method GET
    }


}
