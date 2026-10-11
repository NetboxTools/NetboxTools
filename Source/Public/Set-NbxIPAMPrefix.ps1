function Set-NbxIPAMPrefix {
    <#
    .SYNOPSIS
        Updates prefixes in NetBox.

    .DESCRIPTION
        Updates one or more prefixes using the NetBox API endpoint 'ipam/prefixes'.
        Only the specified properties are changed, all other properties keep their current values.

        References to other objects, such as a site or a tenant, accept IDs or the objects returned by the Get cmdlets.

    .PARAMETER Id
        The ID of the prefix to update. Accepts prefix objects from the pipeline.

    .PARAMETER Prefix
        The IPv4 or IPv6 network with mask, e.g. '192.0.2.0/24'.

    .PARAMETER Status
        The status of the prefix. Common values are: container, active, reserved, deprecated. Specify $null to clear the value.

    .PARAMETER Vrf
        The vrf of the prefix. Accepts an ID or a NetBox object. Specify $null to clear the value.

    .PARAMETER Scope
        The region, site group, site or location the prefix is scoped to. Accepts objects such as those from Get-NbxDCIMSite. Sets ScopeType and ScopeId.

    .PARAMETER ScopeType
        The type of the object the prefix is scoped to. Common values are: dcim.region, dcim.sitegroup, dcim.site, dcim.location. Specify $null to clear the value.

    .PARAMETER ScopeId
        The ID of the object the prefix is scoped to. Specify $null to clear the value.

    .PARAMETER Tenant
        The tenant of the prefix. Accepts an ID or an object from Get-NbxTenant. Specify $null to clear the value.

    .PARAMETER Vlan
        The vlan of the prefix. Accepts an ID or an object from Get-NbxIPAMVLAN. Specify $null to clear the value.

    .PARAMETER Role
        The IPAM role. Accepts an ID or an object from Get-NbxIPAMRole. Specify $null to clear the value.

    .PARAMETER IsPool
        All IP addresses within the prefix are considered usable.

    .PARAMETER MarkUtilized
        Treat the prefix as fully utilized.

    .PARAMETER Description
        A short description of the prefix. Specify $null to clear the value.

    .PARAMETER Comments
        Comments about the prefix. Supports Markdown. Specify $null to clear the value.

    .PARAMETER Tag
        The tags of the prefix. Accepts tag IDs or objects from Get-NbxTag. Replaces the current tags.

    .PARAMETER CustomField
        Custom field values as a hashtable, e.g. @{ cost_center = '1234' }.

    .PARAMETER OptionalAttribute
        Additional NetBox fields as a hashtable with the API field names as keys, for fields that do not have a parameter. Named parameters take precedence over values in the hashtable.

    .PARAMETER PassThru
        Returns the updated prefix. By default, this cmdlet does not generate any output.

    .PARAMETER Force
        Updates the object without asking for confirmation.

    .PARAMETER WhatIf
        Shows what would happen if the cmdlet runs. The cmdlet is not run.

    .PARAMETER Confirm
        Prompts you for confirmation before running the cmdlet.

    .EXAMPLE
        Set-NbxIPAMPrefix -Id 42 -Description 'Updated with NetboxTools'

        Updates the description of the prefix with ID 42.

    .EXAMPLE
        Get-NbxIPAMPrefix -Query @{ q = 'example' } | Set-NbxIPAMPrefix -Description 'Updated' -PassThru

        Updates the description of all prefixes matching the search 'example' and returns the updated prefixes.

    .INPUTS
        System.UInt64, NetboxTools.IPAMPrefix
        You can pipe prefix IDs or prefix objects to this cmdlet.

    .OUTPUTS
        None, NetboxTools.IPAMPrefix
        With -PassThru the updated prefix is returned.

    .LINK
        Get-NbxIPAMPrefix

    .LINK
        New-NbxIPAMPrefix

    .LINK
        Remove-NbxIPAMPrefix
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    [OutputType('NetboxTools.IPAMPrefix')]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [NbxIdTransformation('ipam/prefixes')]
        [uint64[]]$Id,

        [Parameter()]
        [string]$Prefix,

        [Parameter()]
        [NbxChoiceTransformation()]
        [ArgumentCompletions('container', 'active', 'reserved', 'deprecated')]
        [string]$Status,

        [Parameter()]
        [NbxIdTransformation('ipam/vrfs')]
        [Nullable[uint64]]$Vrf,

        [Parameter()]
        [object]$Scope,

        [Parameter()]
        [Alias('scope_type')]
        [NbxChoiceTransformation()]
        [ArgumentCompletions('dcim.region', 'dcim.sitegroup', 'dcim.site', 'dcim.location')]
        [string]$ScopeType,

        [Parameter()]
        [Alias('scope_id')]
        [Nullable[int]]$ScopeId,

        [Parameter()]
        [NbxIdTransformation('tenancy/tenants')]
        [Nullable[uint64]]$Tenant,

        [Parameter()]
        [NbxIdTransformation('ipam/vlans')]
        [Nullable[uint64]]$Vlan,

        [Parameter()]
        [NbxIdTransformation('ipam/roles')]
        [Nullable[uint64]]$Role,

        [Parameter()]
        [Alias('is_pool')]
        [NbxBoolTransformation()]
        [bool]$IsPool,

        [Parameter()]
        [Alias('mark_utilized')]
        [NbxBoolTransformation()]
        [bool]$MarkUtilized,

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
        $Body = ConvertToNbxBody -Command $MyInvocation.MyCommand -BoundParameters $PSBoundParameters -Exclude @('Id', 'Force', 'PassThru', 'OptionalAttribute', 'Scope')
        if ($PSBoundParameters.ContainsKey('Scope')) {
            $Reference = ConvertToNbxObjectReference -InputObject $Scope
            $Body['scope_type'] = $Reference.object_type
            $Body['scope_id'] = $Reference.object_id
        }

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
            if (($Force -and -not $WhatIfPreference) -or $PSCmdlet.ShouldProcess("prefix $ObjectId", 'Update')) {
                $Result = InvokeNbxRestMethod -Endpoint "ipam/prefixes/$ObjectId/" -Method PATCH -Body $Body -TypeName 'NetboxTools.IPAMPrefix'
                if ($PassThru) {
                    $Result
                }
            }
        }
    }
}
