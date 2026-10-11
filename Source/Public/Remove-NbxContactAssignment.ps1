function Remove-NbxContactAssignment {
    <#
    .SYNOPSIS
        Removes contact assignments from NetBox.

    .DESCRIPTION
        Removes one or more contact assignments using the NetBox API endpoint 'tenancy/contact-assignments'.
        You are asked for confirmation before each object is removed, unless -Force or -Confirm:$false is specified.

    .PARAMETER Id
        The ID of the contact assignment to remove. Accepts contact assignment objects from the pipeline.

    .PARAMETER Force
        Removes the object without asking for confirmation.

    .PARAMETER WhatIf
        Shows what would happen if the cmdlet runs. The cmdlet is not run.

    .PARAMETER Confirm
        Prompts you for confirmation before running the cmdlet.

    .EXAMPLE
        Remove-NbxContactAssignment -Id 42

        Removes the contact assignment with ID 42 after confirmation.

    .EXAMPLE
        Get-NbxContactAssignment -Query @{ q = 'example' } | Remove-NbxContactAssignment -Force

        Removes all contact assignments matching the search 'example' without confirmation.

    .INPUTS
        System.UInt64, NetboxTools.ContactAssignment
        You can pipe contact assignment IDs or contact assignment objects to this cmdlet.

    .OUTPUTS
        None

    .LINK
        Get-NbxContactAssignment

    .LINK
        New-NbxContactAssignment

    .LINK
        Set-NbxContactAssignment
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    [OutputType([void])]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [NbxIdTransformation('tenancy/contact-assignments')]
        [uint64[]]$Id,

        [Parameter()]
        [switch]$Force
    )

    process {
        foreach ($ObjectId in $Id) {
            if (($Force -and -not $WhatIfPreference) -or $PSCmdlet.ShouldProcess("contact assignment $ObjectId", 'Remove')) {
                InvokeNbxRestMethod -Endpoint "tenancy/contact-assignments/$ObjectId/" -Method DELETE
            }
        }
    }
}
