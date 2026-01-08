function Remove-NbxIPAMAddressRange {

    <#
    .SYNOPSIS
        Remove an IP address range from Netbox

    .DESCRIPTION
        Removes/deletes an IP address range from Netbox by ID

    .PARAMETER Id
        Database ID of the IP address range object.

    .PARAMETER Force
        Do not confirm.

    .EXAMPLE
        PS C:\> Remove-NbxIPAMAddressRange -Id 1234

    .NOTES
        Additional information about the function.
#>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [uint64[]]$Id
    )


    $Id | ForEach-Object {
        InvokeNbxRestMethod -URI "$($script:NbxConfig.URI)/ipam/ip-ranges/$($_)" -Method DELETE
    }
    
}
