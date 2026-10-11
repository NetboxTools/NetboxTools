function Set-NbxVirtualMachineInterface {
    <#
    .SYNOPSIS
        Updates virtual machine interfaces in NetBox.

    .DESCRIPTION
        Updates one or more virtual machine interfaces using the NetBox API endpoint 'virtualization/interfaces'.
        Only the specified properties are changed, all other properties keep their current values.

        References to other objects, such as a site or a tenant, accept IDs or the objects returned by the Get cmdlets.

    .PARAMETER Id
        The ID of the virtual machine interface to update. Accepts virtual machine interface objects from the pipeline.

    .PARAMETER VirtualMachine
        The virtual machine of the virtual machine interface. Accepts an ID or an object from Get-NbxVirtualMachine.

    .PARAMETER Name
        The name of the virtual machine interface.

    .PARAMETER Enabled
        Whether the virtual machine interface is enabled.

    .PARAMETER Parent
        The parent interface. Accepts an ID or an object from Get-NbxVirtualMachineInterface. Specify $null to clear the value.

    .PARAMETER Bridge
        The bridge interface. Accepts an ID or an object from Get-NbxVirtualMachineInterface. Specify $null to clear the value.

    .PARAMETER Mtu
        The maximum transmission unit. Specify $null to clear the value.

    .PARAMETER MacAddress
        The primary MAC address of the interface. Requires NetBox 4.7 or later, earlier versions ignore the value. Specify $null to clear the value.

    .PARAMETER Mode
        The 802.1Q mode. Common values are: access, tagged, tagged-all, q-in-q. Specify $null to clear the value.

    .PARAMETER UntaggedVlan
        The untagged VLAN (the VLAN object or its ID, not the VLAN number). Accepts an ID or an object from Get-NbxIPAMVLAN. Specify $null to clear the value.

    .PARAMETER TaggedVlan
        The tagged VLANs (VLAN objects or their IDs, not the VLAN numbers). Accepts IDs or objects from Get-NbxIPAMVLAN.

    .PARAMETER Vrf
        The vrf of the virtual machine interface. Accepts an ID or a NetBox object. Specify $null to clear the value.

    .PARAMETER Description
        A short description of the virtual machine interface. Specify $null to clear the value.

    .PARAMETER Tag
        The tags of the virtual machine interface. Accepts tag IDs or objects from Get-NbxTag. Replaces the current tags.

    .PARAMETER CustomField
        Custom field values as a hashtable, e.g. @{ cost_center = '1234' }.

    .PARAMETER OptionalAttribute
        Additional NetBox fields as a hashtable with the API field names as keys, for fields that do not have a parameter. Named parameters take precedence over values in the hashtable.

    .PARAMETER PassThru
        Returns the updated virtual machine interface. By default, this cmdlet does not generate any output.

    .PARAMETER Force
        Updates the object without asking for confirmation.

    .PARAMETER WhatIf
        Shows what would happen if the cmdlet runs. The cmdlet is not run.

    .PARAMETER Confirm
        Prompts you for confirmation before running the cmdlet.

    .EXAMPLE
        Set-NbxVirtualMachineInterface -Id 42 -Description 'Updated with NetboxTools'

        Updates the description of the virtual machine interface with ID 42.

    .EXAMPLE
        Get-NbxVirtualMachineInterface -Query @{ q = 'example' } | Set-NbxVirtualMachineInterface -Description 'Updated' -PassThru

        Updates the description of all virtual machine interfaces matching the search 'example' and returns the updated virtual machine interfaces.

    .INPUTS
        System.UInt64, NetboxTools.VirtualMachineInterface
        You can pipe virtual machine interface IDs or virtual machine interface objects to this cmdlet.

    .OUTPUTS
        None, NetboxTools.VirtualMachineInterface
        With -PassThru the updated virtual machine interface is returned.

    .LINK
        Get-NbxVirtualMachineInterface

    .LINK
        New-NbxVirtualMachineInterface

    .LINK
        Remove-NbxVirtualMachineInterface
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    [OutputType('NetboxTools.VirtualMachineInterface')]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [NbxIdTransformation('virtualization/interfaces')]
        [uint64[]]$Id,

        [Parameter()]
        [Alias('virtual_machine')]
        [NbxIdTransformation('virtualization/virtual-machines')]
        [Nullable[uint64]]$VirtualMachine,

        [Parameter()]
        [string]$Name,

        [Parameter()]
        [NbxBoolTransformation()]
        [bool]$Enabled,

        [Parameter()]
        [NbxIdTransformation('virtualization/interfaces')]
        [Nullable[uint64]]$Parent,

        [Parameter()]
        [NbxIdTransformation('virtualization/interfaces')]
        [Nullable[uint64]]$Bridge,

        [Parameter()]
        [Nullable[int]]$Mtu,

        [Parameter()]
        [Alias('mac_address')]
        [string]$MacAddress,

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
            if (($Force -and -not $WhatIfPreference) -or $PSCmdlet.ShouldProcess("virtual machine interface $ObjectId", 'Update')) {
                $Result = InvokeNbxRestMethod -Endpoint "virtualization/interfaces/$ObjectId/" -Method PATCH -Body $Body -TypeName 'NetboxTools.VirtualMachineInterface'
                if ($PassThru) {
                    $Result
                }
            }
        }
    }
}
