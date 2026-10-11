function New-NbxVirtualMachineInterface {
    <#
    .SYNOPSIS
        Creates a new virtual machine interface in NetBox.

    .DESCRIPTION
        Creates a new virtual machine interface using the NetBox API endpoint 'virtualization/interfaces' and returns the created virtual machine interface.

        References to other objects, such as a site or a tenant, accept IDs or the objects returned by the Get cmdlets.
        Objects with properties matching the parameter names or the NetBox field names can be piped to the cmdlet,
        for example rows from Import-Csv or virtual machine interface objects returned by Get-NbxVirtualMachineInterface.

    .PARAMETER VirtualMachine
        The virtual machine of the virtual machine interface. Accepts an ID or an object from Get-NbxVirtualMachine.

    .PARAMETER Name
        The name of the virtual machine interface.

    .PARAMETER Enabled
        Whether the virtual machine interface is enabled.

    .PARAMETER Parent
        The parent interface. Accepts an ID or an object from Get-NbxVirtualMachineInterface.

    .PARAMETER Bridge
        The bridge interface. Accepts an ID or an object from Get-NbxVirtualMachineInterface.

    .PARAMETER Mtu
        The maximum transmission unit.

    .PARAMETER MacAddress
        The primary MAC address of the interface. Requires NetBox 4.7 or later, earlier versions ignore the value.

    .PARAMETER Mode
        The 802.1Q mode. Common values are: access, tagged, tagged-all, q-in-q.

    .PARAMETER UntaggedVlan
        The untagged VLAN (the VLAN object or its ID, not the VLAN number). Accepts an ID or an object from Get-NbxIPAMVLAN.

    .PARAMETER TaggedVlan
        The tagged VLANs (VLAN objects or their IDs, not the VLAN numbers). Accepts IDs or objects from Get-NbxIPAMVLAN.

    .PARAMETER Vrf
        The vrf of the virtual machine interface. Accepts an ID or a NetBox object.

    .PARAMETER Description
        A short description of the virtual machine interface.

    .PARAMETER Tag
        The tags of the virtual machine interface. Accepts tag IDs or objects from Get-NbxTag. Replaces the current tags.

    .PARAMETER CustomField
        Custom field values as a hashtable, e.g. @{ cost_center = '1234' }.

    .PARAMETER OptionalAttribute
        Additional NetBox fields as a hashtable with the API field names as keys, for fields that do not have a parameter. Named parameters take precedence over values in the hashtable.

    .PARAMETER WhatIf
        Shows what would happen if the cmdlet runs. The cmdlet is not run.

    .PARAMETER Confirm
        Prompts you for confirmation before running the cmdlet.

    .EXAMPLE
        New-NbxVirtualMachineInterface -VirtualMachine 1 -Name 'eth0'

        Creates a new virtual machine interface.

    .EXAMPLE
        New-NbxVirtualMachineInterface -VirtualMachine 1 -Name 'eth0' -Description 'Created with NetboxTools' -OptionalAttribute @{ custom_fields = @{ owner = 'IT' } }

        Creates a new virtual machine interface with a description and a custom field value.

    .EXAMPLE
        Import-Csv -Path .\virtual-machine-interfaces.csv | New-NbxVirtualMachineInterface

        Creates a virtual machine interface for each row in a CSV file. Columns are matched to parameters by name or NetBox field name.

    .INPUTS
        System.Management.Automation.PSObject
        You can pipe objects with properties matching the parameter names or NetBox field names to this cmdlet.

    .OUTPUTS
        NetboxTools.VirtualMachineInterface

    .LINK
        Get-NbxVirtualMachineInterface

    .LINK
        Set-NbxVirtualMachineInterface

    .LINK
        Remove-NbxVirtualMachineInterface
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    [OutputType('NetboxTools.VirtualMachineInterface')]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('virtual_machine')]
        [NbxIdTransformation('virtualization/virtual-machines')]
        [Nullable[uint64]]$VirtualMachine,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Name,

        [Parameter(ValueFromPipelineByPropertyName)]
        [NbxBoolTransformation()]
        [bool]$Enabled,

        [Parameter(ValueFromPipelineByPropertyName)]
        [NbxIdTransformation('virtualization/interfaces')]
        [Nullable[uint64]]$Parent,

        [Parameter(ValueFromPipelineByPropertyName)]
        [NbxIdTransformation('virtualization/interfaces')]
        [Nullable[uint64]]$Bridge,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Nullable[int]]$Mtu,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('mac_address')]
        [string]$MacAddress,

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

        if ($PSCmdlet.ShouldProcess(($Body['name'] ?? 'new virtual machine interface'), 'Create virtual machine interface')) {
            InvokeNbxRestMethod -Endpoint 'virtualization/interfaces/' -Method POST -Body $Body -TypeName 'NetboxTools.VirtualMachineInterface'
        }
    }
}
