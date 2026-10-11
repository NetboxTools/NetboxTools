function Remove-NbxDCIMInterface {
    <#
    .SYNOPSIS
        Removes interfaces from NetBox.

    .DESCRIPTION
        Removes one or more interfaces using the NetBox API endpoint 'dcim/interfaces'.
        You are asked for confirmation before each object is removed, unless -Force or -Confirm:$false is specified.

    .PARAMETER Id
        The ID of the interface to remove. Accepts interface objects from the pipeline.

    .PARAMETER Force
        Removes the object without asking for confirmation.

    .PARAMETER WhatIf
        Shows what would happen if the cmdlet runs. The cmdlet is not run.

    .PARAMETER Confirm
        Prompts you for confirmation before running the cmdlet.

    .EXAMPLE
        Remove-NbxDCIMInterface -Id 42

        Removes the interface with ID 42 after confirmation.

    .EXAMPLE
        Get-NbxDCIMInterface -Query @{ q = 'example' } | Remove-NbxDCIMInterface -Force

        Removes all interfaces matching the search 'example' without confirmation.

    .INPUTS
        System.UInt64, NetboxTools.DCIMInterface
        You can pipe interface IDs or interface objects to this cmdlet.

    .OUTPUTS
        None

    .LINK
        Get-NbxDCIMInterface

    .LINK
        New-NbxDCIMInterface

    .LINK
        Set-NbxDCIMInterface
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    [OutputType([void])]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [NbxIdTransformation('dcim/interfaces')]
        [uint64[]]$Id,

        [Parameter()]
        [switch]$Force
    )

    process {
        foreach ($ObjectId in $Id) {
            if (($Force -and -not $WhatIfPreference) -or $PSCmdlet.ShouldProcess("interface $ObjectId", 'Remove')) {
                InvokeNbxRestMethod -Endpoint "dcim/interfaces/$ObjectId/" -Method DELETE
            }
        }
    }
}
