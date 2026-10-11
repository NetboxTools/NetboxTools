function New-NbxDCIMSite {
    <#
    .SYNOPSIS
        Creates a new site in NetBox.

    .DESCRIPTION
        Creates a new site using the NetBox API endpoint 'dcim/sites' and returns the created site.

        References to other objects, such as a site or a tenant, accept IDs or the objects returned by the Get cmdlets.
        Objects with properties matching the parameter names or the NetBox field names can be piped to the cmdlet,
        for example rows from Import-Csv or site objects returned by Get-NbxDCIMSite.

    .PARAMETER Name
        The name of the site.

    .PARAMETER Slug
        The URL-friendly unique name of the site. Generated from the name when not specified.

    .PARAMETER Status
        The status of the site. Common values are: planned, staging, active, decommissioning, retired.

    .PARAMETER Region
        The region of the site. Accepts an ID or a NetBox object.

    .PARAMETER Group
        The site group. Accepts an ID or a NetBox object.

    .PARAMETER Tenant
        The tenant of the site. Accepts an ID or an object from Get-NbxTenant.

    .PARAMETER Facility
        The local facility ID or description.

    .PARAMETER TimeZone
        The time zone of the site, e.g. 'Europe/Stockholm'.

    .PARAMETER PhysicalAddress
        The physical address of the site.

    .PARAMETER ShippingAddress
        The shipping address of the site.

    .PARAMETER Latitude
        GPS latitude in decimal format (xx.yyyyyy).

    .PARAMETER Longitude
        GPS longitude in decimal format (xx.yyyyyy).

    .PARAMETER Description
        A short description of the site.

    .PARAMETER Comments
        Comments about the site. Supports Markdown.

    .PARAMETER Tag
        The tags of the site. Accepts tag IDs or objects from Get-NbxTag. Replaces the current tags.

    .PARAMETER CustomField
        Custom field values as a hashtable, e.g. @{ cost_center = '1234' }.

    .PARAMETER OptionalAttribute
        Additional NetBox fields as a hashtable with the API field names as keys, for fields that do not have a parameter. Named parameters take precedence over values in the hashtable.

    .PARAMETER WhatIf
        Shows what would happen if the cmdlet runs. The cmdlet is not run.

    .PARAMETER Confirm
        Prompts you for confirmation before running the cmdlet.

    .EXAMPLE
        New-NbxDCIMSite -Name 'Stockholm'

        Creates a new site.

    .EXAMPLE
        New-NbxDCIMSite -Name 'Stockholm' -Description 'Created with NetboxTools' -OptionalAttribute @{ custom_fields = @{ owner = 'IT' } }

        Creates a new site with a description and a custom field value.

    .EXAMPLE
        Import-Csv -Path .\sites.csv | New-NbxDCIMSite

        Creates a site for each row in a CSV file. Columns are matched to parameters by name or NetBox field name.

    .INPUTS
        System.Management.Automation.PSObject
        You can pipe objects with properties matching the parameter names or NetBox field names to this cmdlet.

    .OUTPUTS
        NetboxTools.DCIMSite

    .LINK
        Get-NbxDCIMSite

    .LINK
        Set-NbxDCIMSite

    .LINK
        Remove-NbxDCIMSite
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    [OutputType('NetboxTools.DCIMSite')]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Name,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$Slug,

        [Parameter(ValueFromPipelineByPropertyName)]
        [NbxChoiceTransformation()]
        [ArgumentCompletions('planned', 'staging', 'active', 'decommissioning', 'retired')]
        [string]$Status,

        [Parameter(ValueFromPipelineByPropertyName)]
        [NbxIdTransformation('dcim/regions')]
        [Nullable[uint64]]$Region,

        [Parameter(ValueFromPipelineByPropertyName)]
        [NbxIdTransformation('dcim/site-groups')]
        [Nullable[uint64]]$Group,

        [Parameter(ValueFromPipelineByPropertyName)]
        [NbxIdTransformation('tenancy/tenants')]
        [Nullable[uint64]]$Tenant,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$Facility,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('time_zone')]
        [string]$TimeZone,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('physical_address')]
        [string]$PhysicalAddress,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('shipping_address')]
        [string]$ShippingAddress,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Nullable[decimal]]$Latitude,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Nullable[decimal]]$Longitude,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$Description,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$Comments,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('tags')]
        [NbxIdTransformation('extras/tags')]
        [uint64[]]$Tag,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('custom_fields')]
        [NbxDictionaryTransformation()]
        [hashtable]$CustomField,

        [Parameter()]
        [hashtable]$OptionalAttribute
    )

    begin {
        $CommandLineParameters = @($PSBoundParameters.Keys)
    }

    process {
        $Body = ConvertToNbxBody -Command $MyInvocation.MyCommand -BoundParameters $PSBoundParameters -CommandLineParameters $CommandLineParameters -InputObject $_
        if (-not $Body.ContainsKey('slug') -and $Body['name']) {
            $Body['slug'] = ConvertToNbxSlug -Name $Body['name']
        }

        if ($PSCmdlet.ShouldProcess(($Body['name'] ?? 'new site'), 'Create site')) {
            InvokeNbxRestMethod -Endpoint 'dcim/sites/' -Method POST -Body $Body -TypeName 'NetboxTools.DCIMSite'
        }
    }
}
