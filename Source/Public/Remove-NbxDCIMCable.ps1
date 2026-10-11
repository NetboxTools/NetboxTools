function Remove-NbxDCIMCable {
    <#
    .SYNOPSIS
        Removes cables from NetBox.

    .DESCRIPTION
        Removes one or more cables using the NetBox API endpoint 'dcim/cables'.
        You are asked for confirmation before each object is removed, unless -Force or -Confirm:$false is specified.

    .PARAMETER Id
        The ID of the cable to remove. Accepts cable objects from the pipeline.

    .PARAMETER Force
        Removes the object without asking for confirmation.

    .PARAMETER WhatIf
        Shows what would happen if the cmdlet runs. The cmdlet is not run.

    .PARAMETER Confirm
        Prompts you for confirmation before running the cmdlet.

    .EXAMPLE
        Remove-NbxDCIMCable -Id 42

        Removes the cable with ID 42 after confirmation.

    .EXAMPLE
        Get-NbxDCIMCable -Query @{ q = 'example' } | Remove-NbxDCIMCable -Force

        Removes all cables matching the search 'example' without confirmation.

    .INPUTS
        System.UInt64, NetboxTools.DCIMCable
        You can pipe cable IDs or cable objects to this cmdlet.

    .OUTPUTS
        None

    .LINK
        Get-NbxDCIMCable

    .LINK
        New-NbxDCIMCable

    .LINK
        Set-NbxDCIMCable
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    [OutputType([void])]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [NbxIdTransformation('dcim/cables')]
        [uint64[]]$Id,

        [Parameter()]
        [switch]$Force
    )

    process {
        foreach ($ObjectId in $Id) {
            if (($Force -and -not $WhatIfPreference) -or $PSCmdlet.ShouldProcess("cable $ObjectId", 'Remove')) {
                InvokeNbxRestMethod -Endpoint "dcim/cables/$ObjectId/" -Method DELETE
            }
        }
    }
}
