function Remove-NbxVirtualMachine {
    <#
    .SYNOPSIS
        Removes virtual machines from NetBox.

    .DESCRIPTION
        Removes one or more virtual machines using the NetBox API endpoint 'virtualization/virtual-machines'.
        You are asked for confirmation before each object is removed, unless -Force or -Confirm:$false is specified.

    .PARAMETER Id
        The ID of the virtual machine to remove. Accepts virtual machine objects from the pipeline.

    .PARAMETER Force
        Removes the object without asking for confirmation.

    .PARAMETER WhatIf
        Shows what would happen if the cmdlet runs. The cmdlet is not run.

    .PARAMETER Confirm
        Prompts you for confirmation before running the cmdlet.

    .EXAMPLE
        Remove-NbxVirtualMachine -Id 42

        Removes the virtual machine with ID 42 after confirmation.

    .EXAMPLE
        Get-NbxVirtualMachine -Query @{ q = 'example' } | Remove-NbxVirtualMachine -Force

        Removes all virtual machines matching the search 'example' without confirmation.

    .INPUTS
        System.UInt64, NetboxTools.VirtualMachine
        You can pipe virtual machine IDs or virtual machine objects to this cmdlet.

    .OUTPUTS
        None

    .LINK
        Get-NbxVirtualMachine

    .LINK
        New-NbxVirtualMachine

    .LINK
        Set-NbxVirtualMachine
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    [OutputType([void])]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [NbxIdTransformation('virtualization/virtual-machines')]
        [uint64[]]$Id,

        [Parameter()]
        [switch]$Force
    )

    process {
        foreach ($ObjectId in $Id) {
            if (($Force -and -not $WhatIfPreference) -or $PSCmdlet.ShouldProcess("virtual machine $ObjectId", 'Remove')) {
                InvokeNbxRestMethod -Endpoint "virtualization/virtual-machines/$ObjectId/" -Method DELETE
            }
        }
    }
}
