function Set-NbxDCIMInterface {
    <#
    .SYNOPSIS
        Updates interfaces in NetBox.

    .DESCRIPTION
        Updates one or more interfaces using the NetBox API endpoint 'dcim/interfaces'.
        Only the specified properties are changed, all other properties keep their current values.

        References to other objects, such as a site or a tenant, accept IDs or the objects returned by the Get cmdlets.

    .PARAMETER Id
        The ID of the interface to update. Accepts interface objects from the pipeline.

    .PARAMETER Device
        The device of the interface. Accepts an ID or an object from Get-NbxDCIMDevice.

    .PARAMETER Name
        The name of the interface.

    .PARAMETER Type
        The interface type, e.g. '1000base-t' or 'virtual'. Common values are: virtual, bridge, lag, 100base-tx, 1000base-t, 2.5gbase-t, 5gbase-t, 10gbase-t, 1000base-x-sfp, 10gbase-x-sfpp, 25gbase-x-sfp28, 40gbase-x-qsfpp, 50gbase-x-sfp56, 100gbase-x-qsfp28, 200gbase-x-qsfp56, 400gbase-x-qsfpdd, 400gbase-x-osfp, 800gbase-x-qsfpdd, ieee802.11ac, ieee802.11ax, other.

    .PARAMETER Module
        The module of the interface. Accepts an ID or a NetBox object. Specify $null to clear the value.

    .PARAMETER Label
        A physical label. Specify $null to clear the value.

    .PARAMETER Enabled
        Whether the interface is enabled.

    .PARAMETER Parent
        The parent interface. Accepts an ID or an object from Get-NbxDCIMInterface. Specify $null to clear the value.

    .PARAMETER Bridge
        The bridge interface. Accepts an ID or an object from Get-NbxDCIMInterface. Specify $null to clear the value.

    .PARAMETER Lag
        The parent LAG interface. Accepts an ID or an object from Get-NbxDCIMInterface. Specify $null to clear the value.

    .PARAMETER Mtu
        The maximum transmission unit. Specify $null to clear the value.

    .PARAMETER MacAddress
        The primary MAC address of the interface. Requires NetBox 4.7 or later, earlier versions ignore the value. Specify $null to clear the value.

    .PARAMETER Speed
        The speed in Kbps. Specify $null to clear the value.

    .PARAMETER Duplex
        The duplex of the interface. Common values are: half, full, auto. Specify $null to clear the value.

    .PARAMETER Wwn
        The 64-bit World Wide Name. Specify $null to clear the value.

    .PARAMETER MgmtOnly
        Whether the interface is used for out-of-band management only.

    .PARAMETER Mode
        The 802.1Q mode. Common values are: access, tagged, tagged-all, q-in-q. Specify $null to clear the value.

    .PARAMETER UntaggedVlan
        The untagged VLAN (the VLAN object or its ID, not the VLAN number). Accepts an ID or an object from Get-NbxIPAMVLAN. Specify $null to clear the value.

    .PARAMETER TaggedVlan
        The tagged VLANs (VLAN objects or their IDs, not the VLAN numbers). Accepts IDs or objects from Get-NbxIPAMVLAN.

    .PARAMETER Vrf
        The vrf of the interface. Accepts an ID or a NetBox object. Specify $null to clear the value.

    .PARAMETER MarkConnected
        Treat the interface as if a cable is connected.

    .PARAMETER Description
        A short description of the interface. Specify $null to clear the value.

    .PARAMETER Tag
        The tags of the interface. Accepts tag IDs or objects from Get-NbxTag. Replaces the current tags.

    .PARAMETER CustomField
        Custom field values as a hashtable, e.g. @{ cost_center = '1234' }.

    .PARAMETER OptionalAttribute
        Additional NetBox fields as a hashtable with the API field names as keys, for fields that do not have a parameter. Named parameters take precedence over values in the hashtable.

    .PARAMETER PassThru
        Returns the updated interface. By default, this cmdlet does not generate any output.

    .PARAMETER Force
        Updates the object without asking for confirmation.

    .PARAMETER WhatIf
        Shows what would happen if the cmdlet runs. The cmdlet is not run.

    .PARAMETER Confirm
        Prompts you for confirmation before running the cmdlet.

    .EXAMPLE
        Set-NbxDCIMInterface -Id 42 -Description 'Updated with NetboxTools'

        Updates the description of the interface with ID 42.

    .EXAMPLE
        Get-NbxDCIMInterface -Query @{ q = 'example' } | Set-NbxDCIMInterface -Description 'Updated' -PassThru

        Updates the description of all interfaces matching the search 'example' and returns the updated interfaces.

    .INPUTS
        System.UInt64, NetboxTools.DCIMInterface
        You can pipe interface IDs or interface objects to this cmdlet.

    .OUTPUTS
        None, NetboxTools.DCIMInterface
        With -PassThru the updated interface is returned.

    .LINK
        Get-NbxDCIMInterface

    .LINK
        New-NbxDCIMInterface

    .LINK
        Remove-NbxDCIMInterface
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    [OutputType('NetboxTools.DCIMInterface')]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [NbxIdTransformation('dcim/interfaces')]
        [uint64[]]$Id,

        [Parameter()]
        [NbxIdTransformation('dcim/devices')]
        [Nullable[uint64]]$Device,

        [Parameter()]
        [string]$Name,

        [Parameter()]
        [NbxChoiceTransformation()]
        [ArgumentCompletions('virtual', 'bridge', 'lag', '100base-tx', '1000base-t', '2.5gbase-t', '5gbase-t', '10gbase-t', '1000base-x-sfp', '10gbase-x-sfpp', '25gbase-x-sfp28', '40gbase-x-qsfpp', '50gbase-x-sfp56', '100gbase-x-qsfp28', '200gbase-x-qsfp56', '400gbase-x-qsfpdd', '400gbase-x-osfp', '800gbase-x-qsfpdd', 'ieee802.11ac', 'ieee802.11ax', 'other')]
        [string]$Type,

        [Parameter()]
        [NbxIdTransformation('dcim/modules')]
        [Nullable[uint64]]$Module,

        [Parameter()]
        [string]$Label,

        [Parameter()]
        [NbxBoolTransformation()]
        [bool]$Enabled,

        [Parameter()]
        [NbxIdTransformation('dcim/interfaces')]
        [Nullable[uint64]]$Parent,

        [Parameter()]
        [NbxIdTransformation('dcim/interfaces')]
        [Nullable[uint64]]$Bridge,

        [Parameter()]
        [NbxIdTransformation('dcim/interfaces')]
        [Nullable[uint64]]$Lag,

        [Parameter()]
        [Nullable[int]]$Mtu,

        [Parameter()]
        [Alias('mac_address')]
        [string]$MacAddress,

        [Parameter()]
        [Nullable[int]]$Speed,

        [Parameter()]
        [NbxChoiceTransformation()]
        [ArgumentCompletions('half', 'full', 'auto')]
        [string]$Duplex,

        [Parameter()]
        [string]$Wwn,

        [Parameter()]
        [Alias('mgmt_only')]
        [NbxBoolTransformation()]
        [bool]$MgmtOnly,

        [Parameter()]
        [NbxChoiceTransformation()]
        [ArgumentCompletions('access', 'tagged', 'tagged-all', 'q-in-q')]
        [string]$Mode,

        [Parameter()]
        [Alias('untagged_vlan')]
        [NbxIdTransformation('ipam/vlans')]
        [Nullable[uint64]]$UntaggedVlan,

        [Parameter()]
        [Alias('tagged_vlans')]
        [NbxIdTransformation('ipam/vlans')]
        [uint64[]]$TaggedVlan,

        [Parameter()]
        [NbxIdTransformation('ipam/vrfs')]
        [Nullable[uint64]]$Vrf,

        [Parameter()]
        [Alias('mark_connected')]
        [NbxBoolTransformation()]
        [bool]$MarkConnected,

        [Parameter()]
        [string]$Description,

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
            if (($Force -and -not $WhatIfPreference) -or $PSCmdlet.ShouldProcess("interface $ObjectId", 'Update')) {
                $Result = InvokeNbxRestMethod -Endpoint "dcim/interfaces/$ObjectId/" -Method PATCH -Body $Body -TypeName 'NetboxTools.DCIMInterface'
                if ($PassThru) {
                    $Result
                }
            }
        }
    }
}
