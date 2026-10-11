function New-NbxIPAMVLAN {
    <#
    .SYNOPSIS
        Creates a new VLAN in NetBox.

    .DESCRIPTION
        Creates a new VLAN using the NetBox API endpoint 'ipam/vlans' and returns the created VLAN.

        References to other objects, such as a site or a tenant, accept IDs or the objects returned by the Get cmdlets.
        Objects with properties matching the parameter names or the NetBox field names can be piped to the cmdlet,
        for example rows from Import-Csv or VLAN objects returned by Get-NbxIPAMVLAN.

    .PARAMETER VID
        The numeric VLAN ID (1-4094).

    .PARAMETER Name
        The name of the VLAN.

    .PARAMETER Status
        The status of the VLAN. Common values are: active, reserved, deprecated.

    .PARAMETER Site
        The site of the VLAN. Accepts an ID or an object from Get-NbxDCIMSite.

    .PARAMETER Group
        The VLAN group. Accepts an ID or a NetBox object.

    .PARAMETER Tenant
        The tenant of the VLAN. Accepts an ID or an object from Get-NbxTenant.

    .PARAMETER Role
        The IPAM role. Accepts an ID or an object from Get-NbxIPAMRole.

    .PARAMETER QinqRole
        The Q-in-Q role of the VLAN. Common values are: svlan, cvlan.

    .PARAMETER QinqSvlan
        The Q-in-Q service VLAN. Accepts an ID or an object from Get-NbxIPAMVLAN.

    .PARAMETER Description
        A short description of the VLAN.

    .PARAMETER Comments
        Comments about the VLAN. Supports Markdown.

    .PARAMETER Tag
        The tags of the VLAN. Accepts tag IDs or objects from Get-NbxTag. Replaces the current tags.

    .PARAMETER CustomField
        Custom field values as a hashtable, e.g. @{ cost_center = '1234' }.

    .PARAMETER OptionalAttribute
        Additional NetBox fields as a hashtable with the API field names as keys, for fields that do not have a parameter. Named parameters take precedence over values in the hashtable.

    .PARAMETER WhatIf
        Shows what would happen if the cmdlet runs. The cmdlet is not run.

    .PARAMETER Confirm
        Prompts you for confirmation before running the cmdlet.

    .EXAMPLE
        New-NbxIPAMVLAN -VID 100 -Name 'Servers'

        Creates a new VLAN.

    .EXAMPLE
        New-NbxIPAMVLAN -VID 100 -Name 'Servers' -Description 'Created with NetboxTools' -OptionalAttribute @{ custom_fields = @{ owner = 'IT' } }

        Creates a new VLAN with a description and a custom field value.

    .EXAMPLE
        Import-Csv -Path .\vlans.csv | New-NbxIPAMVLAN

        Creates a VLAN for each row in a CSV file. Columns are matched to parameters by name or NetBox field name.

    .INPUTS
        System.Management.Automation.PSObject
        You can pipe objects with properties matching the parameter names or NetBox field names to this cmdlet.

    .OUTPUTS
        NetboxTools.IPAMVLAN

    .LINK
        Get-NbxIPAMVLAN

    .LINK
        Set-NbxIPAMVLAN

    .LINK
        Remove-NbxIPAMVLAN
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    [OutputType('NetboxTools.IPAMVLAN')]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Nullable[int]]$VID,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Name,

        [Parameter(ValueFromPipelineByPropertyName)]
        [NbxChoiceTransformation()]
        [ArgumentCompletions('active', 'reserved', 'deprecated')]
        [string]$Status,

        [Parameter(ValueFromPipelineByPropertyName)]
        [NbxIdTransformation('dcim/sites')]
        [Nullable[uint64]]$Site,

        [Parameter(ValueFromPipelineByPropertyName)]
        [NbxIdTransformation('ipam/vlan-groups')]
        [Nullable[uint64]]$Group,

        [Parameter(ValueFromPipelineByPropertyName)]
        [NbxIdTransformation('tenancy/tenants')]
        [Nullable[uint64]]$Tenant,

        [Parameter(ValueFromPipelineByPropertyName)]
        [NbxIdTransformation('ipam/roles')]
        [Nullable[uint64]]$Role,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('qinq_role')]
        [NbxChoiceTransformation()]
        [ArgumentCompletions('svlan', 'cvlan')]
        [string]$QinqRole,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('qinq_svlan')]
        [NbxIdTransformation('ipam/vlans')]
        [Nullable[uint64]]$QinqSvlan,

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

        if ($PSCmdlet.ShouldProcess(($Body['name'] ?? 'new VLAN'), 'Create VLAN')) {
            InvokeNbxRestMethod -Endpoint 'ipam/vlans/' -Method POST -Body $Body -TypeName 'NetboxTools.IPAMVLAN'
        }
    }
}
