function New-NbxDCIMInterface {
    <#
    .SYNOPSIS
        Creates a new interface in NetBox.

    .DESCRIPTION
        Creates a new interface using the NetBox API endpoint 'dcim/interfaces' and returns the created interface.

        References to other objects, such as a site or a tenant, accept IDs or the objects returned by the Get cmdlets.
        Objects with properties matching the parameter names or the NetBox field names can be piped to the cmdlet,
        for example rows from Import-Csv or interface objects returned by Get-NbxDCIMInterface.

    .PARAMETER Device
        The device of the interface. Accepts an ID or an object from Get-NbxDCIMDevice.

    .PARAMETER Name
        The name of the interface.

    .PARAMETER Type
        The interface type, e.g. '1000base-t' or 'virtual'. Common values are: virtual, bridge, lag, 100base-tx, 1000base-t, 2.5gbase-t, 5gbase-t, 10gbase-t, 1000base-x-sfp, 10gbase-x-sfpp, 25gbase-x-sfp28, 40gbase-x-qsfpp, 50gbase-x-sfp56, 100gbase-x-qsfp28, 200gbase-x-qsfp56, 400gbase-x-qsfpdd, 400gbase-x-osfp, 800gbase-x-qsfpdd, ieee802.11ac, ieee802.11ax, other.

    .PARAMETER Module
        The module of the interface. Accepts an ID or a NetBox object.

    .PARAMETER Label
        A physical label.

    .PARAMETER Enabled
        Whether the interface is enabled.

    .PARAMETER Parent
        The parent interface. Accepts an ID or an object from Get-NbxDCIMInterface.

    .PARAMETER Bridge
        The bridge interface. Accepts an ID or an object from Get-NbxDCIMInterface.

    .PARAMETER Lag
        The parent LAG interface. Accepts an ID or an object from Get-NbxDCIMInterface.

    .PARAMETER Mtu
        The maximum transmission unit.

    .PARAMETER MacAddress
        The primary MAC address of the interface. Requires NetBox 4.7 or later, earlier versions ignore the value.

    .PARAMETER Speed
        The speed in Kbps.

    .PARAMETER Duplex
        The duplex of the interface. Common values are: half, full, auto.

    .PARAMETER Wwn
        The 64-bit World Wide Name.

    .PARAMETER MgmtOnly
        Whether the interface is used for out-of-band management only.

    .PARAMETER Mode
        The 802.1Q mode. Common values are: access, tagged, tagged-all, q-in-q.

    .PARAMETER UntaggedVlan
        The untagged VLAN (the VLAN object or its ID, not the VLAN number). Accepts an ID or an object from Get-NbxIPAMVLAN.

    .PARAMETER TaggedVlan
        The tagged VLANs (VLAN objects or their IDs, not the VLAN numbers). Accepts IDs or objects from Get-NbxIPAMVLAN.

    .PARAMETER Vrf
        The vrf of the interface. Accepts an ID or a NetBox object.

    .PARAMETER MarkConnected
        Treat the interface as if a cable is connected.

    .PARAMETER Description
        A short description of the interface.

    .PARAMETER Tag
        The tags of the interface. Accepts tag IDs or objects from Get-NbxTag. Replaces the current tags.

    .PARAMETER CustomField
        Custom field values as a hashtable, e.g. @{ cost_center = '1234' }.

    .PARAMETER OptionalAttribute
        Additional NetBox fields as a hashtable with the API field names as keys, for fields that do not have a parameter. Named parameters take precedence over values in the hashtable.

    .PARAMETER WhatIf
        Shows what would happen if the cmdlet runs. The cmdlet is not run.

    .PARAMETER Confirm
        Prompts you for confirmation before running the cmdlet.

    .EXAMPLE
        New-NbxDCIMInterface -Device 1 -Name 'eth0' -Type 'virtual'

        Creates a new interface.

    .EXAMPLE
        New-NbxDCIMInterface -Device 1 -Name 'eth0' -Type 'virtual' -Description 'Created with NetboxTools' -OptionalAttribute @{ custom_fields = @{ owner = 'IT' } }

        Creates a new interface with a description and a custom field value.

    .EXAMPLE
        Import-Csv -Path .\interfaces.csv | New-NbxDCIMInterface

        Creates an interface for each row in a CSV file. Columns are matched to parameters by name or NetBox field name.

    .INPUTS
        System.Management.Automation.PSObject
        You can pipe objects with properties matching the parameter names or NetBox field names to this cmdlet.

    .OUTPUTS
        NetboxTools.DCIMInterface

    .LINK
        Get-NbxDCIMInterface

    .LINK
        Set-NbxDCIMInterface

    .LINK
        Remove-NbxDCIMInterface
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    [OutputType('NetboxTools.DCIMInterface')]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [NbxIdTransformation('dcim/devices')]
        [Nullable[uint64]]$Device,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Name,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [NbxChoiceTransformation()]
        [ArgumentCompletions('virtual', 'bridge', 'lag', '100base-tx', '1000base-t', '2.5gbase-t', '5gbase-t', '10gbase-t', '1000base-x-sfp', '10gbase-x-sfpp', '25gbase-x-sfp28', '40gbase-x-qsfpp', '50gbase-x-sfp56', '100gbase-x-qsfp28', '200gbase-x-qsfp56', '400gbase-x-qsfpdd', '400gbase-x-osfp', '800gbase-x-qsfpdd', 'ieee802.11ac', 'ieee802.11ax', 'other')]
        [string]$Type,

        [Parameter(ValueFromPipelineByPropertyName)]
        [NbxIdTransformation('dcim/modules')]
        [Nullable[uint64]]$Module,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$Label,

        [Parameter(ValueFromPipelineByPropertyName)]
        [NbxBoolTransformation()]
        [bool]$Enabled,

        [Parameter(ValueFromPipelineByPropertyName)]
        [NbxIdTransformation('dcim/interfaces')]
        [Nullable[uint64]]$Parent,

        [Parameter(ValueFromPipelineByPropertyName)]
        [NbxIdTransformation('dcim/interfaces')]
        [Nullable[uint64]]$Bridge,

        [Parameter(ValueFromPipelineByPropertyName)]
        [NbxIdTransformation('dcim/interfaces')]
        [Nullable[uint64]]$Lag,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Nullable[int]]$Mtu,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('mac_address')]
        [string]$MacAddress,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Nullable[int]]$Speed,

        [Parameter(ValueFromPipelineByPropertyName)]
        [NbxChoiceTransformation()]
        [ArgumentCompletions('half', 'full', 'auto')]
        [string]$Duplex,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$Wwn,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('mgmt_only')]
        [NbxBoolTransformation()]
        [bool]$MgmtOnly,

        [Parameter(ValueFromPipelineByPropertyName)]
        [NbxChoiceTransformation()]
        [ArgumentCompletions('access', 'tagged', 'tagged-all', 'q-in-q')]
        [string]$Mode,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('untagged_vlan')]
        [NbxIdTransformation('ipam/vlans')]
        [Nullable[uint64]]$UntaggedVlan,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('tagged_vlans')]
        [NbxIdTransformation('ipam/vlans')]
        [uint64[]]$TaggedVlan,

        [Parameter(ValueFromPipelineByPropertyName)]
        [NbxIdTransformation('ipam/vrfs')]
        [Nullable[uint64]]$Vrf,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('mark_connected')]
        [NbxBoolTransformation()]
        [bool]$MarkConnected,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$Description,

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

        if ($PSCmdlet.ShouldProcess(($Body['name'] ?? 'new interface'), 'Create interface')) {
            InvokeNbxRestMethod -Endpoint 'dcim/interfaces/' -Method POST -Body $Body -TypeName 'NetboxTools.DCIMInterface'
        }
    }
}
