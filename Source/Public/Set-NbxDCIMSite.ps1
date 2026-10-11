function Set-NbxDCIMSite {
    <#
    .SYNOPSIS
        Updates sites in NetBox.

    .DESCRIPTION
        Updates one or more sites using the NetBox API endpoint 'dcim/sites'.
        Only the specified properties are changed, all other properties keep their current values.

        References to other objects, such as a site or a tenant, accept IDs or the objects returned by the Get cmdlets.

    .PARAMETER Id
        The ID of the site to update. Accepts site objects from the pipeline.

    .PARAMETER Name
        The name of the site.

    .PARAMETER Slug
        The URL-friendly unique name of the site. Generated from the name when not specified. Specify $null to clear the value.

    .PARAMETER Status
        The status of the site. Common values are: planned, staging, active, decommissioning, retired. Specify $null to clear the value.

    .PARAMETER Region
        The region of the site. Accepts an ID or a NetBox object. Specify $null to clear the value.

    .PARAMETER Group
        The site group. Accepts an ID or a NetBox object. Specify $null to clear the value.

    .PARAMETER Tenant
        The tenant of the site. Accepts an ID or an object from Get-NbxTenant. Specify $null to clear the value.

    .PARAMETER Facility
        The local facility ID or description. Specify $null to clear the value.

    .PARAMETER TimeZone
        The time zone of the site, e.g. 'Europe/Stockholm'. Specify $null to clear the value.

    .PARAMETER PhysicalAddress
        The physical address of the site. Specify $null to clear the value.

    .PARAMETER ShippingAddress
        The shipping address of the site. Specify $null to clear the value.

    .PARAMETER Latitude
        GPS latitude in decimal format (xx.yyyyyy). Specify $null to clear the value.

    .PARAMETER Longitude
        GPS longitude in decimal format (xx.yyyyyy). Specify $null to clear the value.

    .PARAMETER Description
        A short description of the site. Specify $null to clear the value.

    .PARAMETER Comments
        Comments about the site. Supports Markdown. Specify $null to clear the value.

    .PARAMETER Tag
        The tags of the site. Accepts tag IDs or objects from Get-NbxTag. Replaces the current tags.

    .PARAMETER CustomField
        Custom field values as a hashtable, e.g. @{ cost_center = '1234' }.

    .PARAMETER OptionalAttribute
        Additional NetBox fields as a hashtable with the API field names as keys, for fields that do not have a parameter. Named parameters take precedence over values in the hashtable.

    .PARAMETER PassThru
        Returns the updated site. By default, this cmdlet does not generate any output.

    .PARAMETER Force
        Updates the object without asking for confirmation.

    .PARAMETER WhatIf
        Shows what would happen if the cmdlet runs. The cmdlet is not run.

    .PARAMETER Confirm
        Prompts you for confirmation before running the cmdlet.

    .EXAMPLE
        Set-NbxDCIMSite -Id 42 -Description 'Updated with NetboxTools'

        Updates the description of the site with ID 42.

    .EXAMPLE
        Get-NbxDCIMSite -Query @{ q = 'example' } | Set-NbxDCIMSite -Description 'Updated' -PassThru

        Updates the description of all sites matching the search 'example' and returns the updated sites.

    .INPUTS
        System.UInt64, NetboxTools.DCIMSite
        You can pipe site IDs or site objects to this cmdlet.

    .OUTPUTS
        None, NetboxTools.DCIMSite
        With -PassThru the updated site is returned.

    .LINK
        Get-NbxDCIMSite

    .LINK
        New-NbxDCIMSite

    .LINK
        Remove-NbxDCIMSite
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    [OutputType('NetboxTools.DCIMSite')]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [NbxIdTransformation('dcim/sites')]
        [uint64[]]$Id,

        [Parameter()]
        [string]$Name,

        [Parameter()]
        [string]$Slug,

        [Parameter()]
        [NbxChoiceTransformation()]
        [ArgumentCompletions('planned', 'staging', 'active', 'decommissioning', 'retired')]
        [string]$Status,

        [Parameter()]
        [NbxIdTransformation('dcim/regions')]
        [Nullable[uint64]]$Region,

        [Parameter()]
        [NbxIdTransformation('dcim/site-groups')]
        [Nullable[uint64]]$Group,

        [Parameter()]
        [NbxIdTransformation('tenancy/tenants')]
        [Nullable[uint64]]$Tenant,

        [Parameter()]
        [string]$Facility,

        [Parameter()]
        [Alias('time_zone')]
        [string]$TimeZone,

        [Parameter()]
        [Alias('physical_address')]
        [string]$PhysicalAddress,

        [Parameter()]
        [Alias('shipping_address')]
        [string]$ShippingAddress,

        [Parameter()]
        [Nullable[decimal]]$Latitude,

        [Parameter()]
        [Nullable[decimal]]$Longitude,

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
            if (($Force -and -not $WhatIfPreference) -or $PSCmdlet.ShouldProcess("site $ObjectId", 'Update')) {
                $Result = InvokeNbxRestMethod -Endpoint "dcim/sites/$ObjectId/" -Method PATCH -Body $Body -TypeName 'NetboxTools.DCIMSite'
                if ($PassThru) {
                    $Result
                }
            }
        }
    }
}
