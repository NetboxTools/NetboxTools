function Get-NbxContentType {

    <#
    .SYNOPSIS
        Get a content type definition from Netbox

    .DESCRIPTION
        A detailed description of the Get-NbxContentType function.

    .PARAMETER Id
        The database ID of the Content type

    .EXAMPLE
        PS C:\> Get-NbxContentType

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
            InvokeNbxRestMethod -URI "$($script:NbxConfig.URI)/extras/object-types/$($_)/" -Method GET
        }
    }
    else {
        InvokeNbxRestMethod -URI "$($script:NbxConfig.URI)/extras/object-types/?limit=9999" -Method GET
    }


}
