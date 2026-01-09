function Get-NbxCircuit {

    <#
    .SYNOPSIS
        Gets one or more circuits

    .DESCRIPTION
        A detailed description of the Get-NbxCircuit function.

    .PARAMETER Id
        Database ID of circuit. This will query for exactly the IDs provided

    .EXAMPLE
        PS C:\> Get-NbxCircuit

    .NOTES
        Additional information about the function.
#>

    [CmdletBinding()]
    param
    (
        [uint64[]]$Id
    )

    if ($Id) {
        $Id | ForEach-Object {
            InvokeNbxRestMethod -URI "$($script:NbxConfig.URI)/circuits/circuits/$($_)/" -Method GET
        }
    }
    else {
        InvokeNbxRestMethod -URI "$($script:NbxConfig.URI)/circuits/circuits/?limit=9999" -Method GET
    }
}

