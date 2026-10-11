function New-NbxIPAMPrefix {
    <#
    .SYNOPSIS
        Creates a new prefix in NetBox.

    .DESCRIPTION
        Creates a new prefix using the NetBox API endpoint 'ipam/prefixes' and returns the created prefix.

        References to other objects, such as a site or a tenant, accept IDs or the objects returned by the Get cmdlets.
        Objects with properties matching the parameter names or the NetBox field names can be piped to the cmdlet,
        for example rows from Import-Csv or prefix objects returned by Get-NbxIPAMPrefix.

    .PARAMETER Prefix
        The IPv4 or IPv6 network with mask, e.g. '192.0.2.0/24'.

    .PARAMETER Status
        The status of the prefix. Common values are: container, active, reserved, deprecated.

    .PARAMETER Vrf
        The vrf of the prefix. Accepts an ID or a NetBox object.

    .PARAMETER Scope
        The region, site group, site or location the prefix is scoped to. Accepts objects such as those from Get-NbxDCIMSite. Sets ScopeType and ScopeId.

    .PARAMETER ScopeType
        The type of the object the prefix is scoped to. Common values are: dcim.region, dcim.sitegroup, dcim.site, dcim.location.

    .PARAMETER ScopeId
        The ID of the object the prefix is scoped to.

    .PARAMETER Tenant
        The tenant of the prefix. Accepts an ID or an object from Get-NbxTenant.

    .PARAMETER Vlan
        The vlan of the prefix. Accepts an ID or an object from Get-NbxIPAMVLAN.

    .PARAMETER Role
        The IPAM role. Accepts an ID or an object from Get-NbxIPAMRole.

    .PARAMETER IsPool
        All IP addresses within the prefix are considered usable.

    .PARAMETER MarkUtilized
        Treat the prefix as fully utilized.

    .PARAMETER Description
        A short description of the prefix.

    .PARAMETER Comments
        Comments about the prefix. Supports Markdown.

    .PARAMETER Tag
        The tags of the prefix. Accepts tag IDs or objects from Get-NbxTag. Replaces the current tags.

    .PARAMETER CustomField
        Custom field values as a hashtable, e.g. @{ cost_center = '1234' }.

    .PARAMETER OptionalAttribute
        Additional NetBox fields as a hashtable with the API field names as keys, for fields that do not have a parameter. Named parameters take precedence over values in the hashtable.

    .PARAMETER WhatIf
        Shows what would happen if the cmdlet runs. The cmdlet is not run.

    .PARAMETER Confirm
        Prompts you for confirmation before running the cmdlet.

    .EXAMPLE
        New-NbxIPAMPrefix -Prefix '192.0.2.0/24'

        Creates a new prefix.

    .EXAMPLE
        New-NbxIPAMPrefix -Prefix '192.0.2.0/24' -Description 'Created with NetboxTools' -OptionalAttribute @{ custom_fields = @{ owner = 'IT' } }

        Creates a new prefix with a description and a custom field value.

    .EXAMPLE
        Import-Csv -Path .\prefixes.csv | New-NbxIPAMPrefix

        Creates a prefix for each row in a CSV file. Columns are matched to parameters by name or NetBox field name.

    .INPUTS
        System.Management.Automation.PSObject
        You can pipe objects with properties matching the parameter names or NetBox field names to this cmdlet.

    .OUTPUTS
        NetboxTools.IPAMPrefix

    .LINK
        Get-NbxIPAMPrefix

    .LINK
        Set-NbxIPAMPrefix

    .LINK
        Remove-NbxIPAMPrefix
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    [OutputType('NetboxTools.IPAMPrefix')]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Prefix,

        [Parameter(ValueFromPipelineByPropertyName)]
        [NbxChoiceTransformation()]
        [ArgumentCompletions('container', 'active', 'reserved', 'deprecated')]
        [string]$Status,

        [Parameter(ValueFromPipelineByPropertyName)]
        [NbxIdTransformation('ipam/vrfs')]
        [Nullable[uint64]]$Vrf,

        [Parameter()]
        [object]$Scope,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('scope_type')]
        [NbxChoiceTransformation()]
        [ArgumentCompletions('dcim.region', 'dcim.sitegroup', 'dcim.site', 'dcim.location')]
        [string]$ScopeType,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('scope_id')]
        [Nullable[int]]$ScopeId,

        [Parameter(ValueFromPipelineByPropertyName)]
        [NbxIdTransformation('tenancy/tenants')]
        [Nullable[uint64]]$Tenant,

        [Parameter(ValueFromPipelineByPropertyName)]
        [NbxIdTransformation('ipam/vlans')]
        [Nullable[uint64]]$Vlan,

        [Parameter(ValueFromPipelineByPropertyName)]
        [NbxIdTransformation('ipam/roles')]
        [Nullable[uint64]]$Role,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('is_pool')]
        [NbxBoolTransformation()]
        [bool]$IsPool,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('mark_utilized')]
        [NbxBoolTransformation()]
        [bool]$MarkUtilized,

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
        $Body = ConvertToNbxBody -Command $MyInvocation.MyCommand -BoundParameters $PSBoundParameters -CommandLineParameters $CommandLineParameters -InputObject $_ -Exclude @('Id', 'Force', 'PassThru', 'OptionalAttribute', 'Scope')
        try {
            if ($PSBoundParameters.ContainsKey('Scope')) {
                $Reference = ConvertToNbxObjectReference -InputObject $Scope
                $Body['scope_type'] = $Reference.object_type
                $Body['scope_id'] = $Reference.object_id
            }
        }
        catch {
            $PSCmdlet.WriteError($_)
            return
        }

        if ($PSCmdlet.ShouldProcess(($Body['prefix'] ?? 'new prefix'), 'Create prefix')) {
            InvokeNbxRestMethod -Endpoint 'ipam/prefixes/' -Method POST -Body $Body -TypeName 'NetboxTools.IPAMPrefix'
        }
    }
}
