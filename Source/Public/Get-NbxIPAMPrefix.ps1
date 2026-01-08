function Get-NbxIPAMPrefix {

    <#
    .SYNOPSIS
        A brief description of the Get-NbxIPAMPrefix function.

    .DESCRIPTION
        A detailed description of the Get-NbxIPAMPrefix function.

    .PARAMETER Id
        A description of the Id parameter.
    .EXAMPLE
        PS C:\> Get-NbxIPAMPrefix

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
            InvokeNbxRestMethod -URI "$($script:NbxConfig.URI)/ipam/prefixes/$($_)" -Method GET
        }
    }
    else {
        InvokeNbxRestMethod -URI "$($script:NbxConfig.URI)/ipam/prefixes?limit=9999" -Method GET
    }

}
