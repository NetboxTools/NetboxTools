function Set-NbxIPAMVLAN {
    <#
    .SYNOPSIS
        Updates VLANs in NetBox.

    .DESCRIPTION
        Updates one or more VLANs using the NetBox API endpoint 'ipam/vlans'.
        Only the specified properties are changed, all other properties keep their current values.

        References to other objects, such as a site or a tenant, accept IDs or the objects returned by the Get cmdlets.

    .PARAMETER Id
        The ID of the VLAN to update. Accepts VLAN objects from the pipeline.

    .PARAMETER VID
        The numeric VLAN ID (1-4094).

    .PARAMETER Name
        The name of the VLAN.

    .PARAMETER Status
        The status of the VLAN. Common values are: active, reserved, deprecated. Specify $null to clear the value.

    .PARAMETER Site
        The site of the VLAN. Accepts an ID or an object from Get-NbxDCIMSite. Specify $null to clear the value.

    .PARAMETER Group
        The VLAN group. Accepts an ID or a NetBox object. Specify $null to clear the value.

    .PARAMETER Tenant
        The tenant of the VLAN. Accepts an ID or an object from Get-NbxTenant. Specify $null to clear the value.

    .PARAMETER Role
        The IPAM role. Accepts an ID or an object from Get-NbxIPAMRole. Specify $null to clear the value.

    .PARAMETER QinqRole
        The Q-in-Q role of the VLAN. Common values are: svlan, cvlan. Specify $null to clear the value.

    .PARAMETER QinqSvlan
        The Q-in-Q service VLAN. Accepts an ID or an object from Get-NbxIPAMVLAN. Specify $null to clear the value.

    .PARAMETER Description
        A short description of the VLAN. Specify $null to clear the value.

    .PARAMETER Comments
        Comments about the VLAN. Supports Markdown. Specify $null to clear the value.

    .PARAMETER Tag
        The tags of the VLAN. Accepts tag IDs or objects from Get-NbxTag. Replaces the current tags.

    .PARAMETER CustomField
        Custom field values as a hashtable, e.g. @{ cost_center = '1234' }.

    .PARAMETER OptionalAttribute
        Additional NetBox fields as a hashtable with the API field names as keys, for fields that do not have a parameter. Named parameters take precedence over values in the hashtable.

    .PARAMETER PassThru
        Returns the updated VLAN. By default, this cmdlet does not generate any output.

    .PARAMETER Force
        Updates the object without asking for confirmation.

    .PARAMETER WhatIf
        Shows what would happen if the cmdlet runs. The cmdlet is not run.

    .PARAMETER Confirm
        Prompts you for confirmation before running the cmdlet.

    .EXAMPLE
        Set-NbxIPAMVLAN -Id 42 -Description 'Updated with NetboxTools'

        Updates the description of the VLAN with ID 42.

    .EXAMPLE
        Get-NbxIPAMVLAN -Query @{ q = 'example' } | Set-NbxIPAMVLAN -Description 'Updated' -PassThru

        Updates the description of all VLANs matching the search 'example' and returns the updated VLANs.

    .INPUTS
        System.UInt64, NetboxTools.IPAMVLAN
        You can pipe VLAN IDs or VLAN objects to this cmdlet.

    .OUTPUTS
        None, NetboxTools.IPAMVLAN
        With -PassThru the updated VLAN is returned.

    .LINK
        Get-NbxIPAMVLAN

    .LINK
        New-NbxIPAMVLAN

    .LINK
        Remove-NbxIPAMVLAN
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    [OutputType('NetboxTools.IPAMVLAN')]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [NbxIdTransformation('ipam/vlans')]
        [uint64[]]$Id,

        [Parameter()]
        [Nullable[int]]$VID,

        [Parameter()]
        [string]$Name,

        [Parameter()]
        [NbxChoiceTransformation()]
        [ArgumentCompletions('active', 'reserved', 'deprecated')]
        [string]$Status,

        [Parameter()]
        [NbxIdTransformation('dcim/sites')]
        [Nullable[uint64]]$Site,

        [Parameter()]
        [NbxIdTransformation('ipam/vlan-groups')]
        [Nullable[uint64]]$Group,

        [Parameter()]
        [NbxIdTransformation('tenancy/tenants')]
        [Nullable[uint64]]$Tenant,

        [Parameter()]
        [NbxIdTransformation('ipam/roles')]
        [Nullable[uint64]]$Role,

        [Parameter()]
        [Alias('qinq_role')]
        [NbxChoiceTransformation()]
        [ArgumentCompletions('svlan', 'cvlan')]
        [string]$QinqRole,

        [Parameter()]
        [Alias('qinq_svlan')]
        [NbxIdTransformation('ipam/vlans')]
        [Nullable[uint64]]$QinqSvlan,

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
            if (($Force -and -not $WhatIfPreference) -or $PSCmdlet.ShouldProcess("VLAN $ObjectId", 'Update')) {
                $Result = InvokeNbxRestMethod -Endpoint "ipam/vlans/$ObjectId/" -Method PATCH -Body $Body -TypeName 'NetboxTools.IPAMVLAN'
                if ($PassThru) {
                    $Result
                }
            }
        }
    }
}
