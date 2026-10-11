function Set-NbxTenant {
    <#
    .SYNOPSIS
        Updates tenants in NetBox.

    .DESCRIPTION
        Updates one or more tenants using the NetBox API endpoint 'tenancy/tenants'.
        Only the specified properties are changed, all other properties keep their current values.

        References to other objects, such as a site or a tenant, accept IDs or the objects returned by the Get cmdlets.

    .PARAMETER Id
        The ID of the tenant to update. Accepts tenant objects from the pipeline.

    .PARAMETER Name
        The name of the tenant.

    .PARAMETER Slug
        The URL-friendly unique name of the tenant. Generated from the name when not specified. Specify $null to clear the value.

    .PARAMETER Group
        The tenant group. Accepts an ID or a NetBox object. Specify $null to clear the value.

    .PARAMETER Description
        A short description of the tenant. Specify $null to clear the value.

    .PARAMETER Comments
        Comments about the tenant. Supports Markdown. Specify $null to clear the value.

    .PARAMETER Tag
        The tags of the tenant. Accepts tag IDs or objects from Get-NbxTag. Replaces the current tags.

    .PARAMETER CustomField
        Custom field values as a hashtable, e.g. @{ cost_center = '1234' }.

    .PARAMETER OptionalAttribute
        Additional NetBox fields as a hashtable with the API field names as keys, for fields that do not have a parameter. Named parameters take precedence over values in the hashtable.

    .PARAMETER PassThru
        Returns the updated tenant. By default, this cmdlet does not generate any output.

    .PARAMETER Force
        Updates the object without asking for confirmation.

    .PARAMETER WhatIf
        Shows what would happen if the cmdlet runs. The cmdlet is not run.

    .PARAMETER Confirm
        Prompts you for confirmation before running the cmdlet.

    .EXAMPLE
        Set-NbxTenant -Id 42 -Description 'Updated with NetboxTools'

        Updates the description of the tenant with ID 42.

    .EXAMPLE
        Get-NbxTenant -Query @{ q = 'example' } | Set-NbxTenant -Description 'Updated' -PassThru

        Updates the description of all tenants matching the search 'example' and returns the updated tenants.

    .INPUTS
        System.UInt64, NetboxTools.Tenant
        You can pipe tenant IDs or tenant objects to this cmdlet.

    .OUTPUTS
        None, NetboxTools.Tenant
        With -PassThru the updated tenant is returned.

    .LINK
        Get-NbxTenant

    .LINK
        New-NbxTenant

    .LINK
        Remove-NbxTenant
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    [OutputType('NetboxTools.Tenant')]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [NbxIdTransformation('tenancy/tenants')]
        [uint64[]]$Id,

        [Parameter()]
        [string]$Name,

        [Parameter()]
        [string]$Slug,

        [Parameter()]
        [NbxIdTransformation('tenancy/tenant-groups')]
        [Nullable[uint64]]$Group,

        [Parameter()]
        [string]$Description,

        [Parameter()]
        [string]$Comments,

        [Parameter()]
        [Alias('tags')]
        [NbxIdTransformation('extras/tags')]
        [uint64[]]$Tag,

        [Parameter()]
        [Alias('custom_fields')]
        [NbxDictionaryTransformation()]
        [hashtable]$CustomField,

        [Parameter()]
        [hashtable]$OptionalAttribute,

        [Parameter()]
        [switch]$PassThru,

        [Parameter()]
        [switch]$Force
    )

    begin {
        $Body = ConvertToNbxBody -Command $MyInvocation.MyCommand -BoundParameters $PSBoundParameters

        if ($Body.Count -eq 0) {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new(
                    [System.ArgumentException]::new('Specify at least one property to update.'),
                    'NbxNothingToUpdate',
                    [System.Management.Automation.ErrorCategory]::InvalidArgument,
                    $null
                ))
        }
    }

    process {
        foreach ($ObjectId in $Id) {
            if (($Force -and -not $WhatIfPreference) -or $PSCmdlet.ShouldProcess("tenant $ObjectId", 'Update')) {
                $Result = InvokeNbxRestMethod -Endpoint "tenancy/tenants/$ObjectId/" -Method PATCH -Body $Body -TypeName 'NetboxTools.Tenant'
                if ($PassThru) {
                    $Result
                }
            }
        }
    }
}
