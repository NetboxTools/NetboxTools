function New-NbxDCIMDevice {
    <#
    .SYNOPSIS
        Creates a new device in NetBox.

    .DESCRIPTION
        Creates a new device using the NetBox API endpoint 'dcim/devices' and returns the created device.

        References to other objects, such as a site or a tenant, accept IDs or the objects returned by the Get cmdlets.
        Objects with properties matching the parameter names or the NetBox field names can be piped to the cmdlet,
        for example rows from Import-Csv or device objects returned by Get-NbxDCIMDevice.

    .PARAMETER Name
        The name of the device.

    .PARAMETER Role
        The device role. Accepts an ID or an object from Get-NbxDCIMDeviceRole.

    .PARAMETER DeviceType
        The device type of the device. Accepts an ID or an object from Get-NbxDCIMDeviceType.

    .PARAMETER Site
        The site of the device. Accepts an ID or an object from Get-NbxDCIMSite.

    .PARAMETER Status
        The status of the device. Common values are: offline, active, planned, staged, failed, inventory, decommissioning.

    .PARAMETER Tenant
        The tenant of the device. Accepts an ID or an object from Get-NbxTenant.

    .PARAMETER Platform
        The platform of the device. Accepts an ID or an object from Get-NbxDCIMPlatform.

    .PARAMETER Serial
        The serial number of the device.

    .PARAMETER AssetTag
        A unique tag used to identify the device.

    .PARAMETER Location
        The location of the device. Accepts an ID or a NetBox object.

    .PARAMETER Rack
        The rack of the device. Accepts an ID or a NetBox object.

    .PARAMETER Position
        The lowest rack unit occupied by the device.

    .PARAMETER Face
        The rack face the device is mounted on. Common values are: front, rear.

    .PARAMETER Airflow
        The airflow of the device. Common values are: front-to-rear, rear-to-front, left-to-right, right-to-left, side-to-rear, rear-to-side, bottom-to-top, top-to-bottom, passive, mixed.

    .PARAMETER Latitude
        GPS latitude in decimal format (xx.yyyyyy).

    .PARAMETER Longitude
        GPS longitude in decimal format (xx.yyyyyy).

    .PARAMETER PrimaryIP4
        The primary IPv4 address of the device. Accepts an ID or an object from Get-NbxIPAMAddress.

    .PARAMETER PrimaryIP6
        The primary IPv6 address of the device. Accepts an ID or an object from Get-NbxIPAMAddress.

    .PARAMETER OobIP
        The out-of-band management IP address of the device. Accepts an ID or an object from Get-NbxIPAMAddress.

    .PARAMETER Cluster
        The cluster of the device. Accepts an ID or an object from Get-NbxVirtualizationCluster.

    .PARAMETER VirtualChassis
        The virtual chassis of the device. Accepts an ID or a NetBox object.

    .PARAMETER VcPosition
        The position of the device in the virtual chassis.

    .PARAMETER VcPriority
        The virtual chassis master election priority.

    .PARAMETER ConfigTemplate
        The config template of the device. Accepts an ID or a NetBox object.

    .PARAMETER Description
        A short description of the device.

    .PARAMETER Comments
        Comments about the device. Supports Markdown.

    .PARAMETER Tag
        The tags of the device. Accepts tag IDs or objects from Get-NbxTag. Replaces the current tags.

    .PARAMETER CustomField
        Custom field values as a hashtable, e.g. @{ cost_center = '1234' }.

    .PARAMETER OptionalAttribute
        Additional NetBox fields as a hashtable with the API field names as keys, for fields that do not have a parameter. Named parameters take precedence over values in the hashtable.

    .PARAMETER WhatIf
        Shows what would happen if the cmdlet runs. The cmdlet is not run.

    .PARAMETER Confirm
        Prompts you for confirmation before running the cmdlet.

    .EXAMPLE
        New-NbxDCIMDevice -Role 1 -DeviceType 1 -Site 1

        Creates a new device.

    .EXAMPLE
        New-NbxDCIMDevice -Role 1 -DeviceType 1 -Site 1 -Description 'Created with NetboxTools' -OptionalAttribute @{ custom_fields = @{ owner = 'IT' } }

        Creates a new device with a description and a custom field value.

    .EXAMPLE
        Import-Csv -Path .\devices.csv | New-NbxDCIMDevice

        Creates a device for each row in a CSV file. Columns are matched to parameters by name or NetBox field name.

    .INPUTS
        System.Management.Automation.PSObject
        You can pipe objects with properties matching the parameter names or NetBox field names to this cmdlet.

    .OUTPUTS
        NetboxTools.DCIMDevice

    .LINK
        Get-NbxDCIMDevice

    .LINK
        Set-NbxDCIMDevice

    .LINK
        Remove-NbxDCIMDevice
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    [OutputType('NetboxTools.DCIMDevice')]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$Name,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('Device_Role')]
        [NbxIdTransformation('dcim/device-roles')]
        [Nullable[uint64]]$Role,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('device_type')]
        [NbxIdTransformation('dcim/device-types')]
        [Nullable[uint64]]$DeviceType,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [NbxIdTransformation('dcim/sites')]
        [Nullable[uint64]]$Site,

        [Parameter(ValueFromPipelineByPropertyName)]
        [NbxChoiceTransformation()]
        [ArgumentCompletions('offline', 'active', 'planned', 'staged', 'failed', 'inventory', 'decommissioning')]
        [string]$Status,

        [Parameter(ValueFromPipelineByPropertyName)]
        [NbxIdTransformation('tenancy/tenants')]
        [Nullable[uint64]]$Tenant,

        [Parameter(ValueFromPipelineByPropertyName)]
        [NbxIdTransformation('dcim/platforms')]
        [Nullable[uint64]]$Platform,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$Serial,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('asset_tag')]
        [string]$AssetTag,

        [Parameter(ValueFromPipelineByPropertyName)]
        [NbxIdTransformation('dcim/locations')]
        [Nullable[uint64]]$Location,

        [Parameter(ValueFromPipelineByPropertyName)]
        [NbxIdTransformation('dcim/racks')]
        [Nullable[uint64]]$Rack,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Nullable[decimal]]$Position,

        [Parameter(ValueFromPipelineByPropertyName)]
        [NbxChoiceTransformation()]
        [ArgumentCompletions('front', 'rear')]
        [string]$Face,

        [Parameter(ValueFromPipelineByPropertyName)]
        [NbxChoiceTransformation()]
        [ArgumentCompletions('front-to-rear', 'rear-to-front', 'left-to-right', 'right-to-left', 'side-to-rear', 'rear-to-side', 'bottom-to-top', 'top-to-bottom', 'passive', 'mixed')]
        [string]$Airflow,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Nullable[decimal]]$Latitude,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Nullable[decimal]]$Longitude,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('primary_ip4')]
        [NbxIdTransformation('ipam/ip-addresses')]
        [Nullable[uint64]]$PrimaryIP4,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('primary_ip6')]
        [NbxIdTransformation('ipam/ip-addresses')]
        [Nullable[uint64]]$PrimaryIP6,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('oob_ip')]
        [NbxIdTransformation('ipam/ip-addresses')]
        [Nullable[uint64]]$OobIP,

        [Parameter(ValueFromPipelineByPropertyName)]
        [NbxIdTransformation('virtualization/clusters')]
        [Nullable[uint64]]$Cluster,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('virtual_chassis')]
        [NbxIdTransformation('dcim/virtual-chassis')]
        [Nullable[uint64]]$VirtualChassis,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('vc_position')]
        [Nullable[int]]$VcPosition,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('vc_priority')]
        [Nullable[int]]$VcPriority,

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

        if ($PSCmdlet.ShouldProcess(($Body['name'] ?? 'new device'), 'Create device')) {
            InvokeNbxRestMethod -Endpoint 'dcim/devices/' -Method POST -Body $Body -TypeName 'NetboxTools.DCIMDevice'
        }
    }
}
