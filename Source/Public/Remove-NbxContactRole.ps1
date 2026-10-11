function Remove-NbxContactRole {
    <#
    .SYNOPSIS
        Removes contact roles from NetBox.

    .DESCRIPTION
        Removes one or more contact roles using the NetBox API endpoint 'tenancy/contact-roles'.
        You are asked for confirmation before each object is removed, unless -Force or -Confirm:$false is specified.

    .PARAMETER Id
        The ID of the contact role to remove. Accepts contact role objects from the pipeline.

    .PARAMETER Force
        Removes the object without asking for confirmation.

    .PARAMETER WhatIf
        Shows what would happen if the cmdlet runs. The cmdlet is not run.

    .PARAMETER Confirm
        Prompts you for confirmation before running the cmdlet.

    .EXAMPLE
        Remove-NbxContactRole -Id 42

        Removes the contact role with ID 42 after confirmation.

    .EXAMPLE
        Get-NbxContactRole -Query @{ q = 'example' } | Remove-NbxContactRole -Force

        Removes all contact roles matching the search 'example' without confirmation.

    .INPUTS
        System.UInt64, NetboxTools.ContactRole
        You can pipe contact role IDs or contact role objects to this cmdlet.

    .OUTPUTS
        None

    .LINK
        Get-NbxContactRole

    .LINK
        New-NbxContactRole

    .LINK
        Set-NbxContactRole
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    [OutputType([void])]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [NbxIdTransformation('tenancy/contact-roles')]
        [uint64[]]$Id,

        [Parameter()]
        [switch]$Force
    )

    process {
        foreach ($ObjectId in $Id) {
            if (($Force -and -not $WhatIfPreference) -or $PSCmdlet.ShouldProcess("contact role $ObjectId", 'Remove')) {
                InvokeNbxRestMethod -Endpoint "tenancy/contact-roles/$ObjectId/" -Method DELETE
            }
        }
    }
}
