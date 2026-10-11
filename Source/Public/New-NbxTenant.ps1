function New-NbxTenant {
    <#
    .SYNOPSIS
        Creates a new tenant in NetBox.

    .DESCRIPTION
        Creates a new tenant using the NetBox API endpoint 'tenancy/tenants' and returns the created tenant.

        References to other objects, such as a site or a tenant, accept IDs or the objects returned by the Get cmdlets.
        Objects with properties matching the parameter names or the NetBox field names can be piped to the cmdlet,
        for example rows from Import-Csv or tenant objects returned by Get-NbxTenant.

    .PARAMETER Name
        The name of the tenant.

    .PARAMETER Slug
        The URL-friendly unique name of the tenant. Generated from the name when not specified.

    .PARAMETER Group
        The tenant group. Accepts an ID or a NetBox object.

    .PARAMETER Description
        A short description of the tenant.

    .PARAMETER Comments
        Comments about the tenant. Supports Markdown.

    .PARAMETER Tag
        The tags of the tenant. Accepts tag IDs or objects from Get-NbxTag. Replaces the current tags.

    .PARAMETER CustomField
        Custom field values as a hashtable, e.g. @{ cost_center = '1234' }.

    .PARAMETER OptionalAttribute
        Additional NetBox fields as a hashtable with the API field names as keys, for fields that do not have a parameter. Named parameters take precedence over values in the hashtable.

    .PARAMETER WhatIf
        Shows what would happen if the cmdlet runs. The cmdlet is not run.

    .PARAMETER Confirm
        Prompts you for confirmation before running the cmdlet.

    .EXAMPLE
        New-NbxTenant -Name 'Contoso'

        Creates a new tenant.

    .EXAMPLE
        New-NbxTenant -Name 'Contoso' -Description 'Created with NetboxTools' -OptionalAttribute @{ custom_fields = @{ owner = 'IT' } }

        Creates a new tenant with a description and a custom field value.

    .EXAMPLE
        Import-Csv -Path .\tenants.csv | New-NbxTenant

        Creates a tenant for each row in a CSV file. Columns are matched to parameters by name or NetBox field name.

    .INPUTS
        System.Management.Automation.PSObject
        You can pipe objects with properties matching the parameter names or NetBox field names to this cmdlet.

    .OUTPUTS
        NetboxTools.Tenant

    .LINK
        Get-NbxTenant

    .LINK
        Set-NbxTenant

    .LINK
        Remove-NbxTenant
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    [OutputType('NetboxTools.Tenant')]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Name,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$Slug,

        [Parameter(ValueFromPipelineByPropertyName)]
        [NbxIdTransformation('tenancy/tenant-groups')]
        [Nullable[uint64]]$Group,

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

        if ($PSCmdlet.ShouldProcess(($Body['name'] ?? 'new tenant'), 'Create tenant')) {
            InvokeNbxRestMethod -Endpoint 'tenancy/tenants/' -Method POST -Body $Body -TypeName 'NetboxTools.Tenant'
        }
    }
}
