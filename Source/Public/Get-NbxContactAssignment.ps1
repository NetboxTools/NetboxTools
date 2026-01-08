function Get-NbxContactAssignment {

    <#
    .SYNOPSIS
        Get a contact Assignment from Netbox

    .DESCRIPTION
        A detailed description of the Get-NbxContactAssignment function.

    .PARAMETER Name
        The specific name of the contact Assignment. Must match exactly as is defined in Netbox

    .PARAMETER Id
        The database ID of the contact Assignment

    .PARAMETER Content_Type_Id
        A description of the Content_Type_Id parameter.

    .PARAMETER Content_Type
        A description of the Content_Type parameter.

    .PARAMETER Object_Id
        A description of the Object_Id parameter.

    .PARAMETER Contact_Id
        A description of the Contact_Id parameter.

    .PARAMETER Role_Id
        A description of the Role_Id parameter.

    .PARAMETER Limit
        Limit the number of results to this number

    .PARAMETER Offset
        Start the search at this index in results

    .PARAMETER Raw
        Return the unparsed data from the HTTP request

    .EXAMPLE
        PS C:\> Get-NbxContactAssignment

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
            InvokeNbxRestMethod -URI "$($script:NbxConfig.URI)/tenancy/contact-assignments/$($_)" -Method GET
        }
    }
    else {
        InvokeNbxRestMethod -URI "$($script:NbxConfig.URI)/tenancy/contact-assignments?limit=9999" -Method GET
    }

}
