function Remove-NbxVirtualMachineInterface {
    <#
    .SYNOPSIS
        Removes virtual machine interfaces from NetBox.

    .DESCRIPTION
        Removes one or more virtual machine interfaces using the NetBox API endpoint 'virtualization/interfaces'.
        You are asked for confirmation before each object is removed, unless -Force or -Confirm:$false is specified.

    .PARAMETER Id
        The ID of the virtual machine interface to remove. Accepts virtual machine interface objects from the pipeline.

    .PARAMETER Force
        Removes the object without asking for confirmation.

    .PARAMETER WhatIf
        Shows what would happen if the cmdlet runs. The cmdlet is not run.

    .PARAMETER Confirm
        Prompts you for confirmation before running the cmdlet.

    .EXAMPLE
        Remove-NbxVirtualMachineInterface -Id 42

        Removes the virtual machine interface with ID 42 after confirmation.

    .EXAMPLE
        Get-NbxVirtualMachineInterface -Query @{ q = 'example' } | Remove-NbxVirtualMachineInterface -Force

        Removes all virtual machine interfaces matching the search 'example' without confirmation.

    .INPUTS
        System.UInt64, NetboxTools.VirtualMachineInterface
        You can pipe virtual machine interface IDs or virtual machine interface objects to this cmdlet.

    .OUTPUTS
        None

    .LINK
        Get-NbxVirtualMachineInterface

    .LINK
        New-NbxVirtualMachineInterface

    .LINK
        Set-NbxVirtualMachineInterface
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    [OutputType([void])]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [NbxIdTransformation('virtualization/interfaces')]
        [uint64[]]$Id,

        [Parameter()]
        [switch]$Force
    )

    process {
        foreach ($ObjectId in $Id) {
            if (($Force -and -not $WhatIfPreference) -or $PSCmdlet.ShouldProcess("virtual machine interface $ObjectId", 'Remove')) {
                InvokeNbxRestMethod -Endpoint "virtualization/interfaces/$ObjectId/" -Method DELETE
            }
        }
    }
}
