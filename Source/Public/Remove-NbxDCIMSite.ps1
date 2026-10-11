function Remove-NbxDCIMSite {
    <#
    .SYNOPSIS
        Removes sites from NetBox.

    .DESCRIPTION
        Removes one or more sites using the NetBox API endpoint 'dcim/sites'.
        You are asked for confirmation before each object is removed, unless -Force or -Confirm:$false is specified.

    .PARAMETER Id
        The ID of the site to remove. Accepts site objects from the pipeline.

    .PARAMETER Force
        Removes the object without asking for confirmation.

    .PARAMETER WhatIf
        Shows what would happen if the cmdlet runs. The cmdlet is not run.

    .PARAMETER Confirm
        Prompts you for confirmation before running the cmdlet.

    .EXAMPLE
        Remove-NbxDCIMSite -Id 42

        Removes the site with ID 42 after confirmation.

    .EXAMPLE
        Get-NbxDCIMSite -Query @{ q = 'example' } | Remove-NbxDCIMSite -Force

        Removes all sites matching the search 'example' without confirmation.

    .INPUTS
        System.UInt64, NetboxTools.DCIMSite
        You can pipe site IDs or site objects to this cmdlet.

    .OUTPUTS
        None

    .LINK
        Get-NbxDCIMSite

    .LINK
        New-NbxDCIMSite

    .LINK
        Set-NbxDCIMSite
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    [OutputType([void])]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [NbxIdTransformation('dcim/sites')]
        [uint64[]]$Id,

        [Parameter()]
        [switch]$Force
    )

    process {
        foreach ($ObjectId in $Id) {
            if (($Force -and -not $WhatIfPreference) -or $PSCmdlet.ShouldProcess("site $ObjectId", 'Remove')) {
                InvokeNbxRestMethod -Endpoint "dcim/sites/$ObjectId/" -Method DELETE
            }
        }
    }
}
