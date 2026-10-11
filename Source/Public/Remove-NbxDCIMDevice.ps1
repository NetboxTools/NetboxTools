function Remove-NbxDCIMDevice {
    <#
    .SYNOPSIS
        Removes devices from NetBox.

    .DESCRIPTION
        Removes one or more devices using the NetBox API endpoint 'dcim/devices'.
        You are asked for confirmation before each object is removed, unless -Force or -Confirm:$false is specified.

    .PARAMETER Id
        The ID of the device to remove. Accepts device objects from the pipeline.

    .PARAMETER Force
        Removes the object without asking for confirmation.

    .PARAMETER WhatIf
        Shows what would happen if the cmdlet runs. The cmdlet is not run.

    .PARAMETER Confirm
        Prompts you for confirmation before running the cmdlet.

    .EXAMPLE
        Remove-NbxDCIMDevice -Id 42

        Removes the device with ID 42 after confirmation.

    .EXAMPLE
        Get-NbxDCIMDevice -Query @{ q = 'example' } | Remove-NbxDCIMDevice -Force

        Removes all devices matching the search 'example' without confirmation.

    .INPUTS
        System.UInt64, NetboxTools.DCIMDevice
        You can pipe device IDs or device objects to this cmdlet.

    .OUTPUTS
        None

    .LINK
        Get-NbxDCIMDevice

    .LINK
        New-NbxDCIMDevice

    .LINK
        Set-NbxDCIMDevice
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    [OutputType([void])]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [NbxIdTransformation('dcim/devices')]
        [uint64[]]$Id,

        [Parameter()]
        [switch]$Force
    )

    process {
        foreach ($ObjectId in $Id) {
            if (($Force -and -not $WhatIfPreference) -or $PSCmdlet.ShouldProcess("device $ObjectId", 'Remove')) {
                InvokeNbxRestMethod -Endpoint "dcim/devices/$ObjectId/" -Method DELETE
            }
        }
    }
}
