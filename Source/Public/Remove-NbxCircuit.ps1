function Remove-NbxCircuit {
    <#
    .SYNOPSIS
        Removes circuits from NetBox.

    .DESCRIPTION
        Removes one or more circuits using the NetBox API endpoint 'circuits/circuits'.
        You are asked for confirmation before each object is removed, unless -Force or -Confirm:$false is specified.

    .PARAMETER Id
        The ID of the circuit to remove. Accepts circuit objects from the pipeline.

    .PARAMETER Force
        Removes the object without asking for confirmation.

    .PARAMETER WhatIf
        Shows what would happen if the cmdlet runs. The cmdlet is not run.

    .PARAMETER Confirm
        Prompts you for confirmation before running the cmdlet.

    .EXAMPLE
        Remove-NbxCircuit -Id 42

        Removes the circuit with ID 42 after confirmation.

    .EXAMPLE
        Get-NbxCircuit -Query @{ q = 'example' } | Remove-NbxCircuit -Force

        Removes all circuits matching the search 'example' without confirmation.

    .INPUTS
        System.UInt64, NetboxTools.Circuit
        You can pipe circuit IDs or circuit objects to this cmdlet.

    .OUTPUTS
        None

    .LINK
        Get-NbxCircuit

    .LINK
        New-NbxCircuit

    .LINK
        Set-NbxCircuit
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    [OutputType([void])]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [NbxIdTransformation('circuits/circuits')]
        [uint64[]]$Id,

        [Parameter()]
        [switch]$Force
    )

    process {
        foreach ($ObjectId in $Id) {
            if (($Force -and -not $WhatIfPreference) -or $PSCmdlet.ShouldProcess("circuit $ObjectId", 'Remove')) {
                InvokeNbxRestMethod -Endpoint "circuits/circuits/$ObjectId/" -Method DELETE
            }
        }
    }
}
