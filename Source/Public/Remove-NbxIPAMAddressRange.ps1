function Remove-NbxIPAMAddressRange {
    <#
    .SYNOPSIS
        Removes IP ranges from NetBox.

    .DESCRIPTION
        Removes one or more IP ranges using the NetBox API endpoint 'ipam/ip-ranges'.
        You are asked for confirmation before each object is removed, unless -Force or -Confirm:$false is specified.

    .PARAMETER Id
        The ID of the IP range to remove. Accepts IP range objects from the pipeline.

    .PARAMETER Force
        Removes the object without asking for confirmation.

    .PARAMETER WhatIf
        Shows what would happen if the cmdlet runs. The cmdlet is not run.

    .PARAMETER Confirm
        Prompts you for confirmation before running the cmdlet.

    .EXAMPLE
        Remove-NbxIPAMAddressRange -Id 42

        Removes the IP range with ID 42 after confirmation.

    .EXAMPLE
        Get-NbxIPAMAddressRange -Query @{ q = 'example' } | Remove-NbxIPAMAddressRange -Force

        Removes all IP ranges matching the search 'example' without confirmation.

    .INPUTS
        System.UInt64, NetboxTools.IPAMAddressRange
        You can pipe IP range IDs or IP range objects to this cmdlet.

    .OUTPUTS
        None

    .LINK
        Get-NbxIPAMAddressRange

    .LINK
        New-NbxIPAMAddressRange

    .LINK
        Set-NbxIPAMAddressRange
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    [OutputType([void])]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [NbxIdTransformation('ipam/ip-ranges')]
        [uint64[]]$Id,

        [Parameter()]
        [switch]$Force
    )

    process {
        foreach ($ObjectId in $Id) {
            if (($Force -and -not $WhatIfPreference) -or $PSCmdlet.ShouldProcess("IP range $ObjectId", 'Remove')) {
                InvokeNbxRestMethod -Endpoint "ipam/ip-ranges/$ObjectId/" -Method DELETE
            }
        }
    }
}
