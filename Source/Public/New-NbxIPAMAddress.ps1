function New-NbxIPAMAddress {
    <#
    .SYNOPSIS
        Creates a new IP address in NetBox.

    .DESCRIPTION
        Creates a new IP address using the NetBox API endpoint 'ipam/ip-addresses' and returns the created IP address.

        References to other objects, such as a site or a tenant, accept IDs or the objects returned by the Get cmdlets.
        Objects with properties matching the parameter names or the NetBox field names can be piped to the cmdlet,
        for example rows from Import-Csv or IP address objects returned by Get-NbxIPAMAddress.

    .PARAMETER Address
        The IPv4 or IPv6 address with mask, e.g. '192.0.2.10/24'.

    .PARAMETER Status
        The status of the IP address. Common values are: active, reserved, deprecated, dhcp, slaac.

    .PARAMETER Role
        The functional role of the IP address. Common values are: loopback, secondary, anycast, vip, vrrp, hsrp, glbp, carp.

    .PARAMETER Vrf
        The vrf of the IP address. Accepts an ID or a NetBox object.

    .PARAMETER Tenant
        The tenant of the IP address. Accepts an ID or an object from Get-NbxTenant.

    .PARAMETER AssignedObject
        The interface to assign the IP address to. Accepts objects from Get-NbxDCIMInterface or Get-NbxVirtualMachineInterface. Sets AssignedObjectType and AssignedObjectId.

    .PARAMETER AssignedObjectType
        The type of object the IP address is assigned to. Common values are: dcim.interface, virtualization.vminterface, ipam.fhrpgroup.

    .PARAMETER AssignedObjectId
        The ID of the object the IP address is assigned to.

    .PARAMETER NatInside
        The inside IP address for which this address is the outside NAT IP. Accepts an ID or an object from Get-NbxIPAMAddress.

    .PARAMETER DnsName
        The hostname or FQDN (not case-sensitive).

    .PARAMETER Description
        A short description of the IP address.

    .PARAMETER Comments
        Comments about the IP address. Supports Markdown.

    .PARAMETER Tag
        The tags of the IP address. Accepts tag IDs or objects from Get-NbxTag. Replaces the current tags.

    .PARAMETER CustomField
        Custom field values as a hashtable, e.g. @{ cost_center = '1234' }.

    .PARAMETER OptionalAttribute
        Additional NetBox fields as a hashtable with the API field names as keys, for fields that do not have a parameter. Named parameters take precedence over values in the hashtable.

    .PARAMETER WhatIf
        Shows what would happen if the cmdlet runs. The cmdlet is not run.

    .PARAMETER Confirm
        Prompts you for confirmation before running the cmdlet.

    .EXAMPLE
        New-NbxIPAMAddress -Address '192.0.2.10/24'

        Creates a new IP address.

    .EXAMPLE
        New-NbxIPAMAddress -Address '192.0.2.10/24' -Description 'Created with NetboxTools' -OptionalAttribute @{ custom_fields = @{ owner = 'IT' } }

        Creates a new IP address with a description and a custom field value.

    .EXAMPLE
        Import-Csv -Path .\ip-addresses.csv | New-NbxIPAMAddress

        Creates an IP address for each row in a CSV file. Columns are matched to parameters by name or NetBox field name.

    .INPUTS
        System.Management.Automation.PSObject
        You can pipe objects with properties matching the parameter names or NetBox field names to this cmdlet.

    .OUTPUTS
        NetboxTools.IPAMAddress

    .LINK
        Get-NbxIPAMAddress

    .LINK
        Set-NbxIPAMAddress

    .LINK
        Remove-NbxIPAMAddress
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    [OutputType('NetboxTools.IPAMAddress')]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Address,

        [Parameter(ValueFromPipelineByPropertyName)]
        [NbxChoiceTransformation()]
        [ArgumentCompletions('active', 'reserved', 'deprecated', 'dhcp', 'slaac')]
        [string]$Status,

        [Parameter(ValueFromPipelineByPropertyName)]
        [NbxChoiceTransformation()]
        [ArgumentCompletions('loopback', 'secondary', 'anycast', 'vip', 'vrrp', 'hsrp', 'glbp', 'carp')]
        [string]$Role,

        [Parameter(ValueFromPipelineByPropertyName)]
        [NbxIdTransformation('ipam/vrfs')]
        [Nullable[uint64]]$Vrf,

        [Parameter(ValueFromPipelineByPropertyName)]
        [NbxIdTransformation('tenancy/tenants')]
        [Nullable[uint64]]$Tenant,

        [Parameter()]
        [object]$AssignedObject,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('assigned_object_type')]
        [NbxChoiceTransformation()]
        [ArgumentCompletions('dcim.interface', 'virtualization.vminterface', 'ipam.fhrpgroup')]
        [string]$AssignedObjectType,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('assigned_object_id')]
        [Nullable[int]]$AssignedObjectId,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('nat_inside')]
        [NbxIdTransformation('ipam/ip-addresses')]
        [Nullable[uint64]]$NatInside,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('dns_name')]
        [string]$DnsName,

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
        $Body = ConvertToNbxBody -Command $MyInvocation.MyCommand -BoundParameters $PSBoundParameters -CommandLineParameters $CommandLineParameters -InputObject $_ -Exclude @('Id', 'Force', 'PassThru', 'OptionalAttribute', 'AssignedObject')
        try {
            if ($PSBoundParameters.ContainsKey('AssignedObject')) {
                $Reference = ConvertToNbxObjectReference -InputObject $AssignedObject
                $Body['assigned_object_type'] = $Reference.object_type
                $Body['assigned_object_id'] = $Reference.object_id
            }
        }
        catch {
            $PSCmdlet.WriteError($_)
            return
        }

        if ($PSCmdlet.ShouldProcess(($Body['address'] ?? 'new IP address'), 'Create IP address')) {
            InvokeNbxRestMethod -Endpoint 'ipam/ip-addresses/' -Method POST -Body $Body -TypeName 'NetboxTools.IPAMAddress'
        }
    }
}
