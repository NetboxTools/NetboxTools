function Remove-NbxDCIMRearPort {
    <#
    .SYNOPSIS
        Removes rear ports from NetBox.

    .DESCRIPTION
        Removes one or more rear ports using the NetBox API endpoint 'dcim/rear-ports'.
        You are asked for confirmation before each object is removed, unless -Force or -Confirm:$false is specified.

    .PARAMETER Id
        The ID of the rear port to remove. Accepts rear port objects from the pipeline.

    .PARAMETER Force
        Removes the object without asking for confirmation.

    .PARAMETER WhatIf
        Shows what would happen if the cmdlet runs. The cmdlet is not run.

    .PARAMETER Confirm
        Prompts you for confirmation before running the cmdlet.

    .EXAMPLE
        Remove-NbxDCIMRearPort -Id 42

        Removes the rear port with ID 42 after confirmation.

    .EXAMPLE
        Get-NbxDCIMRearPort -Query @{ q = 'example' } | Remove-NbxDCIMRearPort -Force

        Removes all rear ports matching the search 'example' without confirmation.

    .INPUTS
        System.UInt64, NetboxTools.DCIMRearPort
        You can pipe rear port IDs or rear port objects to this cmdlet.

    .OUTPUTS
        None

    .LINK
        Get-NbxDCIMRearPort

    .LINK
        New-NbxDCIMRearPort

    .LINK
        Set-NbxDCIMRearPort
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    [OutputType([void])]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [NbxIdTransformation('dcim/rear-ports')]
        [uint64[]]$Id,

        [Parameter()]
        [switch]$Force
    )

    process {
        foreach ($ObjectId in $Id) {
            if (($Force -and -not $WhatIfPreference) -or $PSCmdlet.ShouldProcess("rear port $ObjectId", 'Remove')) {
                InvokeNbxRestMethod -Endpoint "dcim/rear-ports/$ObjectId/" -Method DELETE
            }
        }
    }
}
