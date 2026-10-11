function Remove-NbxIPAMVLAN {
    <#
    .SYNOPSIS
        Removes VLANs from NetBox.

    .DESCRIPTION
        Removes one or more VLANs using the NetBox API endpoint 'ipam/vlans'.
        You are asked for confirmation before each object is removed, unless -Force or -Confirm:$false is specified.

    .PARAMETER Id
        The ID of the VLAN to remove. Accepts VLAN objects from the pipeline.

    .PARAMETER Force
        Removes the object without asking for confirmation.

    .PARAMETER WhatIf
        Shows what would happen if the cmdlet runs. The cmdlet is not run.

    .PARAMETER Confirm
        Prompts you for confirmation before running the cmdlet.

    .EXAMPLE
        Remove-NbxIPAMVLAN -Id 42

        Removes the VLAN with ID 42 after confirmation.

    .EXAMPLE
        Get-NbxIPAMVLAN -Query @{ q = 'example' } | Remove-NbxIPAMVLAN -Force

        Removes all VLANs matching the search 'example' without confirmation.

    .INPUTS
        System.UInt64, NetboxTools.IPAMVLAN
        You can pipe VLAN IDs or VLAN objects to this cmdlet.

    .OUTPUTS
        None

    .LINK
        Get-NbxIPAMVLAN

    .LINK
        New-NbxIPAMVLAN

    .LINK
        Set-NbxIPAMVLAN
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    [OutputType([void])]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [NbxIdTransformation('ipam/vlans')]
        [uint64[]]$Id,

        [Parameter()]
        [switch]$Force
    )

    process {
        foreach ($ObjectId in $Id) {
            if (($Force -and -not $WhatIfPreference) -or $PSCmdlet.ShouldProcess("VLAN $ObjectId", 'Remove')) {
                InvokeNbxRestMethod -Endpoint "ipam/vlans/$ObjectId/" -Method DELETE
            }
        }
    }
}
