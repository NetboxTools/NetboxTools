function Set-NbxIPAMAddress {
    <#
    .SYNOPSIS
        Updates IP addresses in NetBox.

    .DESCRIPTION
        Updates one or more IP addresses using the NetBox API endpoint 'ipam/ip-addresses'.
        Only the specified properties are changed, all other properties keep their current values.

        References to other objects, such as a site or a tenant, accept IDs or the objects returned by the Get cmdlets.

    .PARAMETER Id
        The ID of the IP address to update. Accepts IP address objects from the pipeline.

    .PARAMETER Address
        The IPv4 or IPv6 address with mask, e.g. '192.0.2.10/24'.

    .PARAMETER Status
        The status of the IP address. Common values are: active, reserved, deprecated, dhcp, slaac. Specify $null to clear the value.

    .PARAMETER Role
        The functional role of the IP address. Common values are: loopback, secondary, anycast, vip, vrrp, hsrp, glbp, carp. Specify $null to clear the value.

    .PARAMETER Vrf
        The vrf of the IP address. Accepts an ID or a NetBox object. Specify $null to clear the value.

    .PARAMETER Tenant
        The tenant of the IP address. Accepts an ID or an object from Get-NbxTenant. Specify $null to clear the value.

    .PARAMETER AssignedObject
        The interface to assign the IP address to. Accepts objects from Get-NbxDCIMInterface or Get-NbxVirtualMachineInterface. Sets AssignedObjectType and AssignedObjectId.

    .PARAMETER AssignedObjectType
        The type of object the IP address is assigned to. Common values are: dcim.interface, virtualization.vminterface, ipam.fhrpgroup. Specify $null to clear the value.

    .PARAMETER AssignedObjectId
        The ID of the object the IP address is assigned to. Specify $null to clear the value.

    .PARAMETER NatInside
        The inside IP address for which this address is the outside NAT IP. Accepts an ID or an object from Get-NbxIPAMAddress. Specify $null to clear the value.

    .PARAMETER DnsName
        The hostname or FQDN (not case-sensitive). Specify $null to clear the value.

    .PARAMETER Description
        A short description of the IP address. Specify $null to clear the value.

    .PARAMETER Comments
        Comments about the IP address. Supports Markdown. Specify $null to clear the value.

    .PARAMETER Tag
        The tags of the IP address. Accepts tag IDs or objects from Get-NbxTag. Replaces the current tags.

    .PARAMETER CustomField
        Custom field values as a hashtable, e.g. @{ cost_center = '1234' }.

    .PARAMETER OptionalAttribute
        Additional NetBox fields as a hashtable with the API field names as keys, for fields that do not have a parameter. Named parameters take precedence over values in the hashtable.

    .PARAMETER PassThru
        Returns the updated IP address. By default, this cmdlet does not generate any output.

    .PARAMETER Force
        Updates the object without asking for confirmation.

    .PARAMETER WhatIf
        Shows what would happen if the cmdlet runs. The cmdlet is not run.

    .PARAMETER Confirm
        Prompts you for confirmation before running the cmdlet.

    .EXAMPLE
        Set-NbxIPAMAddress -Id 42 -Description 'Updated with NetboxTools'

        Updates the description of the IP address with ID 42.

    .EXAMPLE
        Get-NbxIPAMAddress -Query @{ q = 'example' } | Set-NbxIPAMAddress -Description 'Updated' -PassThru

        Updates the description of all IP addresses matching the search 'example' and returns the updated IP addresses.

    .INPUTS
        System.UInt64, NetboxTools.IPAMAddress
        You can pipe IP address IDs or IP address objects to this cmdlet.

    .OUTPUTS
        None, NetboxTools.IPAMAddress
        With -PassThru the updated IP address is returned.

    .LINK
        Get-NbxIPAMAddress

    .LINK
        New-NbxIPAMAddress

    .LINK
        Remove-NbxIPAMAddress
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    [OutputType('NetboxTools.IPAMAddress')]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [NbxIdTransformation('ipam/ip-addresses')]
        [uint64[]]$Id,

        [Parameter()]
        [string]$Address,

        [Parameter()]
        [NbxChoiceTransformation()]
        [ArgumentCompletions('active', 'reserved', 'deprecated', 'dhcp', 'slaac')]
        [string]$Status,

        [Parameter()]
        [NbxChoiceTransformation()]
        [ArgumentCompletions('loopback', 'secondary', 'anycast', 'vip', 'vrrp', 'hsrp', 'glbp', 'carp')]
        [string]$Role,

        [Parameter()]
        [NbxIdTransformation('ipam/vrfs')]
        [Nullable[uint64]]$Vrf,

        [Parameter()]
        [NbxIdTransformation('tenancy/tenants')]
        [Nullable[uint64]]$Tenant,

        [Parameter()]
        [object]$AssignedObject,

        [Parameter()]
        [Alias('assigned_object_type')]
        [NbxChoiceTransformation()]
        [ArgumentCompletions('dcim.interface', 'virtualization.vminterface', 'ipam.fhrpgroup')]
        [string]$AssignedObjectType,

        [Parameter()]
        [Alias('assigned_object_id')]
        [Nullable[int]]$AssignedObjectId,

        [Parameter()]
        [Alias('nat_inside')]
        [NbxIdTransformation('ipam/ip-addresses')]
        [Nullable[uint64]]$NatInside,

        [Parameter()]
        [Alias('dns_name')]
        [string]$DnsName,

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
        $Body = ConvertToNbxBody -Command $MyInvocation.MyCommand -BoundParameters $PSBoundParameters -Exclude @('Id', 'Force', 'PassThru', 'OptionalAttribute', 'AssignedObject')
        if ($PSBoundParameters.ContainsKey('AssignedObject')) {
            $Reference = ConvertToNbxObjectReference -InputObject $AssignedObject
            $Body['assigned_object_type'] = $Reference.object_type
            $Body['assigned_object_id'] = $Reference.object_id
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
            if (($Force -and -not $WhatIfPreference) -or $PSCmdlet.ShouldProcess("IP address $ObjectId", 'Update')) {
                $Result = InvokeNbxRestMethod -Endpoint "ipam/ip-addresses/$ObjectId/" -Method PATCH -Body $Body -TypeName 'NetboxTools.IPAMAddress'
                if ($PassThru) {
                    $Result
                }
            }
        }
    }
}
