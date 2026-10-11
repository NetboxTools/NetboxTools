function Remove-NbxTenant {
    <#
    .SYNOPSIS
        Removes tenants from NetBox.

    .DESCRIPTION
        Removes one or more tenants using the NetBox API endpoint 'tenancy/tenants'.
        You are asked for confirmation before each object is removed, unless -Force or -Confirm:$false is specified.

    .PARAMETER Id
        The ID of the tenant to remove. Accepts tenant objects from the pipeline.

    .PARAMETER Force
        Removes the object without asking for confirmation.

    .PARAMETER WhatIf
        Shows what would happen if the cmdlet runs. The cmdlet is not run.

    .PARAMETER Confirm
        Prompts you for confirmation before running the cmdlet.

    .EXAMPLE
        Remove-NbxTenant -Id 42

        Removes the tenant with ID 42 after confirmation.

    .EXAMPLE
        Get-NbxTenant -Query @{ q = 'example' } | Remove-NbxTenant -Force

        Removes all tenants matching the search 'example' without confirmation.

    .INPUTS
        System.UInt64, NetboxTools.Tenant
        You can pipe tenant IDs or tenant objects to this cmdlet.

    .OUTPUTS
        None

    .LINK
        Get-NbxTenant

    .LINK
        New-NbxTenant

    .LINK
        Set-NbxTenant
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    [OutputType([void])]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [NbxIdTransformation('tenancy/tenants')]
        [uint64[]]$Id,

        [Parameter()]
        [switch]$Force
    )

    process {
        foreach ($ObjectId in $Id) {
            if (($Force -and -not $WhatIfPreference) -or $PSCmdlet.ShouldProcess("tenant $ObjectId", 'Remove')) {
                InvokeNbxRestMethod -Endpoint "tenancy/tenants/$ObjectId/" -Method DELETE
            }
        }
    }
}
