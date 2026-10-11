function Remove-NbxIPAMPrefix {
    <#
    .SYNOPSIS
        Removes prefixes from NetBox.

    .DESCRIPTION
        Removes one or more prefixes using the NetBox API endpoint 'ipam/prefixes'.
        You are asked for confirmation before each object is removed, unless -Force or -Confirm:$false is specified.

    .PARAMETER Id
        The ID of the prefix to remove. Accepts prefix objects from the pipeline.

    .PARAMETER Force
        Removes the object without asking for confirmation.

    .PARAMETER WhatIf
        Shows what would happen if the cmdlet runs. The cmdlet is not run.

    .PARAMETER Confirm
        Prompts you for confirmation before running the cmdlet.

    .EXAMPLE
        Remove-NbxIPAMPrefix -Id 42

        Removes the prefix with ID 42 after confirmation.

    .EXAMPLE
        Get-NbxIPAMPrefix -Query @{ q = 'example' } | Remove-NbxIPAMPrefix -Force

        Removes all prefixes matching the search 'example' without confirmation.

    .INPUTS
        System.UInt64, NetboxTools.IPAMPrefix
        You can pipe prefix IDs or prefix objects to this cmdlet.

    .OUTPUTS
        None

    .LINK
        Get-NbxIPAMPrefix

    .LINK
        New-NbxIPAMPrefix

    .LINK
        Set-NbxIPAMPrefix
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    [OutputType([void])]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [NbxIdTransformation('ipam/prefixes')]
        [uint64[]]$Id,

        [Parameter()]
        [switch]$Force
    )

    process {
        foreach ($ObjectId in $Id) {
            if (($Force -and -not $WhatIfPreference) -or $PSCmdlet.ShouldProcess("prefix $ObjectId", 'Remove')) {
                InvokeNbxRestMethod -Endpoint "ipam/prefixes/$ObjectId/" -Method DELETE
            }
        }
    }
}
