function Remove-NbxDCIMFrontPort {
    <#
    .SYNOPSIS
        Removes front ports from NetBox.

    .DESCRIPTION
        Removes one or more front ports using the NetBox API endpoint 'dcim/front-ports'.
        You are asked for confirmation before each object is removed, unless -Force or -Confirm:$false is specified.

    .PARAMETER Id
        The ID of the front port to remove. Accepts front port objects from the pipeline.

    .PARAMETER Force
        Removes the object without asking for confirmation.

    .PARAMETER WhatIf
        Shows what would happen if the cmdlet runs. The cmdlet is not run.

    .PARAMETER Confirm
        Prompts you for confirmation before running the cmdlet.

    .EXAMPLE
        Remove-NbxDCIMFrontPort -Id 42

        Removes the front port with ID 42 after confirmation.

    .EXAMPLE
        Get-NbxDCIMFrontPort -Query @{ q = 'example' } | Remove-NbxDCIMFrontPort -Force

        Removes all front ports matching the search 'example' without confirmation.

    .INPUTS
        System.UInt64, NetboxTools.DCIMFrontPort
        You can pipe front port IDs or front port objects to this cmdlet.

    .OUTPUTS
        None

    .LINK
        Get-NbxDCIMFrontPort

    .LINK
        New-NbxDCIMFrontPort

    .LINK
        Set-NbxDCIMFrontPort
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    [OutputType([void])]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [NbxIdTransformation('dcim/front-ports')]
        [uint64[]]$Id,

        [Parameter()]
        [switch]$Force
    )

    process {
        foreach ($ObjectId in $Id) {
            if (($Force -and -not $WhatIfPreference) -or $PSCmdlet.ShouldProcess("front port $ObjectId", 'Remove')) {
                InvokeNbxRestMethod -Endpoint "dcim/front-ports/$ObjectId/" -Method DELETE
            }
        }
    }
}
