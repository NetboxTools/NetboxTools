function New-NbxVirtualMachine {
    <#
    .SYNOPSIS
        Creates a new virtual machine in NetBox.

    .DESCRIPTION
        Creates a new virtual machine using the NetBox API endpoint 'virtualization/virtual-machines' and returns the created virtual machine.

        References to other objects, such as a site or a tenant, accept IDs or the objects returned by the Get cmdlets.
        Objects with properties matching the parameter names or the NetBox field names can be piped to the cmdlet,
        for example rows from Import-Csv or virtual machine objects returned by Get-NbxVirtualMachine.

    .PARAMETER Name
        The name of the virtual machine.

    .PARAMETER Status
        The status of the virtual machine. Common values are: offline, active, planned, staged, failed, decommissioning.

    .PARAMETER Site
        The site of the virtual machine. Accepts an ID or an object from Get-NbxDCIMSite.

    .PARAMETER Cluster
        The cluster of the virtual machine. Accepts an ID or an object from Get-NbxVirtualizationCluster.

    .PARAMETER Device
        The device (host) the virtual machine runs on. Accepts an ID or an object from Get-NbxDCIMDevice.

    .PARAMETER Role
        The device role. Accepts an ID or an object from Get-NbxDCIMDeviceRole.

    .PARAMETER VirtualMachineType
        The virtual machine type of the virtual machine. Accepts an ID or a NetBox object.

    .PARAMETER Tenant
        The tenant of the virtual machine. Accepts an ID or an object from Get-NbxTenant.

    .PARAMETER Platform
        The platform of the virtual machine. Accepts an ID or an object from Get-NbxDCIMPlatform.

    .PARAMETER PrimaryIP4
        The primary IPv4 address of the virtual machine. Accepts an ID or an object from Get-NbxIPAMAddress.

    .PARAMETER PrimaryIP6
        The primary IPv6 address of the virtual machine. Accepts an ID or an object from Get-NbxIPAMAddress.

    .PARAMETER VCPUs
        The number of virtual CPUs.

    .PARAMETER Memory
        The amount of memory in MB.

    .PARAMETER Disk
        The disk size in MB.

    .PARAMETER Serial
        The serial number of the virtual machine.

    .PARAMETER ConfigTemplate
        The config template of the virtual machine. Accepts an ID or a NetBox object.

    .PARAMETER Description
        A short description of the virtual machine.

    .PARAMETER Comments
        Comments about the virtual machine. Supports Markdown.

    .PARAMETER Tag
        The tags of the virtual machine. Accepts tag IDs or objects from Get-NbxTag. Replaces the current tags.

    .PARAMETER CustomField
        Custom field values as a hashtable, e.g. @{ cost_center = '1234' }.

    .PARAMETER OptionalAttribute
        Additional NetBox fields as a hashtable with the API field names as keys, for fields that do not have a parameter. Named parameters take precedence over values in the hashtable.

    .PARAMETER WhatIf
        Shows what would happen if the cmdlet runs. The cmdlet is not run.

    .PARAMETER Confirm
        Prompts you for confirmation before running the cmdlet.

    .EXAMPLE
        New-NbxVirtualMachine -Name 'vm01'

        Creates a new virtual machine.

    .EXAMPLE
        New-NbxVirtualMachine -Name 'vm01' -Description 'Created with NetboxTools' -OptionalAttribute @{ custom_fields = @{ owner = 'IT' } }

        Creates a new virtual machine with a description and a custom field value.

    .EXAMPLE
        Import-Csv -Path .\virtual-machines.csv | New-NbxVirtualMachine

        Creates a virtual machine for each row in a CSV file. Columns are matched to parameters by name or NetBox field name.

    .INPUTS
        System.Management.Automation.PSObject
        You can pipe objects with properties matching the parameter names or NetBox field names to this cmdlet.

    .OUTPUTS
        NetboxTools.VirtualMachine

    .LINK
        Get-NbxVirtualMachine

    .LINK
        Set-NbxVirtualMachine

    .LINK
        Remove-NbxVirtualMachine
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    [OutputType('NetboxTools.VirtualMachine')]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Name,

        [Parameter(ValueFromPipelineByPropertyName)]
        [NbxChoiceTransformation()]
        [ArgumentCompletions('offline', 'active', 'planned', 'staged', 'failed', 'decommissioning')]
        [string]$Status,

        [Parameter(ValueFromPipelineByPropertyName)]
        [NbxIdTransformation('dcim/sites')]
        [Nullable[uint64]]$Site,

        [Parameter(ValueFromPipelineByPropertyName)]
        [NbxIdTransformation('virtualization/clusters')]
        [Nullable[uint64]]$Cluster,

        [Parameter(ValueFromPipelineByPropertyName)]
        [NbxIdTransformation('dcim/devices')]
        [Nullable[uint64]]$Device,

        [Parameter(ValueFromPipelineByPropertyName)]
        [NbxIdTransformation('dcim/device-roles')]
        [Nullable[uint64]]$Role,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('virtual_machine_type')]
        [NbxIdTransformation('virtualization/virtual-machine-types')]
        [Nullable[uint64]]$VirtualMachineType,

        [Parameter(ValueFromPipelineByPropertyName)]
        [NbxIdTransformation('tenancy/tenants')]
        [Nullable[uint64]]$Tenant,

        [Parameter(ValueFromPipelineByPropertyName)]
        [NbxIdTransformation('dcim/platforms')]
        [Nullable[uint64]]$Platform,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('primary_ip4')]
        [NbxIdTransformation('ipam/ip-addresses')]
        [Nullable[uint64]]$PrimaryIP4,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('primary_ip6')]
        [NbxIdTransformation('ipam/ip-addresses')]
        [Nullable[uint64]]$PrimaryIP6,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Nullable[decimal]]$VCPUs,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Nullable[int]]$Memory,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Nullable[int]]$Disk,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$Serial,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('config_template')]
        [NbxIdTransformation('extras/config-templates')]
        [Nullable[uint64]]$ConfigTemplate,

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

        if ($PSCmdlet.ShouldProcess(($Body['name'] ?? 'new virtual machine'), 'Create virtual machine')) {
            InvokeNbxRestMethod -Endpoint 'virtualization/virtual-machines/' -Method POST -Body $Body -TypeName 'NetboxTools.VirtualMachine'
        }
    }
}
