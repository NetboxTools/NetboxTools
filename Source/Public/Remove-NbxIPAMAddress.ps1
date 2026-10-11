function Remove-NbxIPAMAddress {
    <#
    .SYNOPSIS
        Removes IP addresses from NetBox.

    .DESCRIPTION
        Removes one or more IP addresses using the NetBox API endpoint 'ipam/ip-addresses'.
        You are asked for confirmation before each object is removed, unless -Force or -Confirm:$false is specified.

    .PARAMETER Id
        The ID of the IP address to remove. Accepts IP address objects from the pipeline.

    .PARAMETER Force
        Removes the object without asking for confirmation.

    .PARAMETER WhatIf
        Shows what would happen if the cmdlet runs. The cmdlet is not run.

    .PARAMETER Confirm
        Prompts you for confirmation before running the cmdlet.

    .EXAMPLE
        Remove-NbxIPAMAddress -Id 42

        Removes the IP address with ID 42 after confirmation.

    .EXAMPLE
        Get-NbxIPAMAddress -Query @{ q = 'example' } | Remove-NbxIPAMAddress -Force

        Removes all IP addresses matching the search 'example' without confirmation.

    .INPUTS
        System.UInt64, NetboxTools.IPAMAddress
        You can pipe IP address IDs or IP address objects to this cmdlet.

    .OUTPUTS
        None

    .LINK
        Get-NbxIPAMAddress

    .LINK
        New-NbxIPAMAddress

    .LINK
        Set-NbxIPAMAddress
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    [OutputType([void])]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [NbxIdTransformation('ipam/ip-addresses')]
        [uint64[]]$Id,

        [Parameter()]
        [switch]$Force
    )

    process {
        foreach ($ObjectId in $Id) {
            if (($Force -and -not $WhatIfPreference) -or $PSCmdlet.ShouldProcess("IP address $ObjectId", 'Remove')) {
                InvokeNbxRestMethod -Endpoint "ipam/ip-addresses/$ObjectId/" -Method DELETE
            }
        }
    }
}
