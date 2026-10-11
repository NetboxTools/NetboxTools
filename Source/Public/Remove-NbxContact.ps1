function Remove-NbxContact {
    <#
    .SYNOPSIS
        Removes contacts from NetBox.

    .DESCRIPTION
        Removes one or more contacts using the NetBox API endpoint 'tenancy/contacts'.
        You are asked for confirmation before each object is removed, unless -Force or -Confirm:$false is specified.

    .PARAMETER Id
        The ID of the contact to remove. Accepts contact objects from the pipeline.

    .PARAMETER Force
        Removes the object without asking for confirmation.

    .PARAMETER WhatIf
        Shows what would happen if the cmdlet runs. The cmdlet is not run.

    .PARAMETER Confirm
        Prompts you for confirmation before running the cmdlet.

    .EXAMPLE
        Remove-NbxContact -Id 42

        Removes the contact with ID 42 after confirmation.

    .EXAMPLE
        Get-NbxContact -Query @{ q = 'example' } | Remove-NbxContact -Force

        Removes all contacts matching the search 'example' without confirmation.

    .INPUTS
        System.UInt64, NetboxTools.Contact
        You can pipe contact IDs or contact objects to this cmdlet.

    .OUTPUTS
        None

    .LINK
        Get-NbxContact

    .LINK
        New-NbxContact

    .LINK
        Set-NbxContact
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    [OutputType([void])]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [NbxIdTransformation('tenancy/contacts')]
        [uint64[]]$Id,

        [Parameter()]
        [switch]$Force
    )

    process {
        foreach ($ObjectId in $Id) {
            if (($Force -and -not $WhatIfPreference) -or $PSCmdlet.ShouldProcess("contact $ObjectId", 'Remove')) {
                InvokeNbxRestMethod -Endpoint "tenancy/contacts/$ObjectId/" -Method DELETE
            }
        }
    }
}
