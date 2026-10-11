function Set-NbxVirtualMachine {
    <#
    .SYNOPSIS
        Updates virtual machines in NetBox.

    .DESCRIPTION
        Updates one or more virtual machines using the NetBox API endpoint 'virtualization/virtual-machines'.
        Only the specified properties are changed, all other properties keep their current values.

        References to other objects, such as a site or a tenant, accept IDs or the objects returned by the Get cmdlets.

    .PARAMETER Id
        The ID of the virtual machine to update. Accepts virtual machine objects from the pipeline.

    .PARAMETER Name
        The name of the virtual machine.

    .PARAMETER Status
        The status of the virtual machine. Common values are: offline, active, planned, staged, failed, decommissioning. Specify $null to clear the value.

    .PARAMETER Site
        The site of the virtual machine. Accepts an ID or an object from Get-NbxDCIMSite. Specify $null to clear the value.

    .PARAMETER Cluster
        The cluster of the virtual machine. Accepts an ID or an object from Get-NbxVirtualizationCluster. Specify $null to clear the value.

    .PARAMETER Device
        The device (host) the virtual machine runs on. Accepts an ID or an object from Get-NbxDCIMDevice. Specify $null to clear the value.

    .PARAMETER Role
        The device role. Accepts an ID or an object from Get-NbxDCIMDeviceRole. Specify $null to clear the value.

    .PARAMETER VirtualMachineType
        The virtual machine type of the virtual machine. Accepts an ID or a NetBox object. Specify $null to clear the value.

    .PARAMETER Tenant
        The tenant of the virtual machine. Accepts an ID or an object from Get-NbxTenant. Specify $null to clear the value.

    .PARAMETER Platform
        The platform of the virtual machine. Accepts an ID or an object from Get-NbxDCIMPlatform. Specify $null to clear the value.

    .PARAMETER PrimaryIP4
        The primary IPv4 address of the virtual machine. Accepts an ID or an object from Get-NbxIPAMAddress. Specify $null to clear the value.

    .PARAMETER PrimaryIP6
        The primary IPv6 address of the virtual machine. Accepts an ID or an object from Get-NbxIPAMAddress. Specify $null to clear the value.

    .PARAMETER VCPUs
        The number of virtual CPUs. Specify $null to clear the value.

    .PARAMETER Memory
        The amount of memory in MB. Specify $null to clear the value.

    .PARAMETER Disk
        The disk size in MB. Specify $null to clear the value.

    .PARAMETER Serial
        The serial number of the virtual machine. Specify $null to clear the value.

    .PARAMETER ConfigTemplate
        The config template of the virtual machine. Accepts an ID or a NetBox object. Specify $null to clear the value.

    .PARAMETER Description
        A short description of the virtual machine. Specify $null to clear the value.

    .PARAMETER Comments
        Comments about the virtual machine. Supports Markdown. Specify $null to clear the value.

    .PARAMETER Tag
        The tags of the virtual machine. Accepts tag IDs or objects from Get-NbxTag. Replaces the current tags.

    .PARAMETER CustomField
        Custom field values as a hashtable, e.g. @{ cost_center = '1234' }.

    .PARAMETER OptionalAttribute
        Additional NetBox fields as a hashtable with the API field names as keys, for fields that do not have a parameter. Named parameters take precedence over values in the hashtable.

    .PARAMETER PassThru
        Returns the updated virtual machine. By default, this cmdlet does not generate any output.

    .PARAMETER Force
        Updates the object without asking for confirmation.

    .PARAMETER WhatIf
        Shows what would happen if the cmdlet runs. The cmdlet is not run.

    .PARAMETER Confirm
        Prompts you for confirmation before running the cmdlet.

    .EXAMPLE
        Set-NbxVirtualMachine -Id 42 -Description 'Updated with NetboxTools'

        Updates the description of the virtual machine with ID 42.

    .EXAMPLE
        Get-NbxVirtualMachine -Query @{ q = 'example' } | Set-NbxVirtualMachine -Description 'Updated' -PassThru

        Updates the description of all virtual machines matching the search 'example' and returns the updated virtual machines.

    .INPUTS
        System.UInt64, NetboxTools.VirtualMachine
        You can pipe virtual machine IDs or virtual machine objects to this cmdlet.

    .OUTPUTS
        None, NetboxTools.VirtualMachine
        With -PassThru the updated virtual machine is returned.

    .LINK
        Get-NbxVirtualMachine

    .LINK
        New-NbxVirtualMachine

    .LINK
        Remove-NbxVirtualMachine
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    [OutputType('NetboxTools.VirtualMachine')]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [NbxIdTransformation('virtualization/virtual-machines')]
        [uint64[]]$Id,

        [Parameter()]
        [string]$Name,

        [Parameter()]
        [NbxChoiceTransformation()]
        [ArgumentCompletions('offline', 'active', 'planned', 'staged', 'failed', 'decommissioning')]
        [string]$Status,

        [Parameter()]
        [NbxIdTransformation('dcim/sites')]
        [Nullable[uint64]]$Site,

        [Parameter()]
        [NbxIdTransformation('virtualization/clusters')]
        [Nullable[uint64]]$Cluster,

        [Parameter()]
        [NbxIdTransformation('dcim/devices')]
        [Nullable[uint64]]$Device,

        [Parameter()]
        [NbxIdTransformation('dcim/device-roles')]
        [Nullable[uint64]]$Role,

        [Parameter()]
        [Alias('virtual_machine_type')]
        [NbxIdTransformation('virtualization/virtual-machine-types')]
        [Nullable[uint64]]$VirtualMachineType,

        [Parameter()]
        [NbxIdTransformation('tenancy/tenants')]
        [Nullable[uint64]]$Tenant,

        [Parameter()]
        [NbxIdTransformation('dcim/platforms')]
        [Nullable[uint64]]$Platform,

        [Parameter()]
        [Alias('primary_ip4')]
        [NbxIdTransformation('ipam/ip-addresses')]
        [Nullable[uint64]]$PrimaryIP4,

        [Parameter()]
        [Alias('primary_ip6')]
        [NbxIdTransformation('ipam/ip-addresses')]
        [Nullable[uint64]]$PrimaryIP6,

        [Parameter()]
        [Nullable[decimal]]$VCPUs,

        [Parameter()]
        [Nullable[int]]$Memory,

        [Parameter()]
        [Nullable[int]]$Disk,

        [Parameter()]
        [string]$Serial,

        [Parameter()]
        [Alias('config_template')]
        [NbxIdTransformation('extras/config-templates')]
        [Nullable[uint64]]$ConfigTemplate,

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
            if (($Force -and -not $WhatIfPreference) -or $PSCmdlet.ShouldProcess("virtual machine $ObjectId", 'Update')) {
                $Result = InvokeNbxRestMethod -Endpoint "virtualization/virtual-machines/$ObjectId/" -Method PATCH -Body $Body -TypeName 'NetboxTools.VirtualMachine'
                if ($PassThru) {
                    $Result
                }
            }
        }
    }
}
