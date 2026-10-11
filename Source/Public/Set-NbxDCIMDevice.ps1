function Set-NbxDCIMDevice {
    <#
    .SYNOPSIS
        Updates devices in NetBox.

    .DESCRIPTION
        Updates one or more devices using the NetBox API endpoint 'dcim/devices'.
        Only the specified properties are changed, all other properties keep their current values.

        References to other objects, such as a site or a tenant, accept IDs or the objects returned by the Get cmdlets.

    .PARAMETER Id
        The ID of the device to update. Accepts device objects from the pipeline.

    .PARAMETER Name
        The name of the device. Specify $null to clear the value.

    .PARAMETER Role
        The device role. Accepts an ID or an object from Get-NbxDCIMDeviceRole.

    .PARAMETER DeviceType
        The device type of the device. Accepts an ID or an object from Get-NbxDCIMDeviceType.

    .PARAMETER Site
        The site of the device. Accepts an ID or an object from Get-NbxDCIMSite.

    .PARAMETER Status
        The status of the device. Common values are: offline, active, planned, staged, failed, inventory, decommissioning. Specify $null to clear the value.

    .PARAMETER Tenant
        The tenant of the device. Accepts an ID or an object from Get-NbxTenant. Specify $null to clear the value.

    .PARAMETER Platform
        The platform of the device. Accepts an ID or an object from Get-NbxDCIMPlatform. Specify $null to clear the value.

    .PARAMETER Serial
        The serial number of the device. Specify $null to clear the value.

    .PARAMETER AssetTag
        A unique tag used to identify the device. Specify $null to clear the value.

    .PARAMETER Location
        The location of the device. Accepts an ID or a NetBox object. Specify $null to clear the value.

    .PARAMETER Rack
        The rack of the device. Accepts an ID or a NetBox object. Specify $null to clear the value.

    .PARAMETER Position
        The lowest rack unit occupied by the device. Specify $null to clear the value.

    .PARAMETER Face
        The rack face the device is mounted on. Common values are: front, rear. Specify $null to clear the value.

    .PARAMETER Airflow
        The airflow of the device. Common values are: front-to-rear, rear-to-front, left-to-right, right-to-left, side-to-rear, rear-to-side, bottom-to-top, top-to-bottom, passive, mixed. Specify $null to clear the value.

    .PARAMETER Latitude
        GPS latitude in decimal format (xx.yyyyyy). Specify $null to clear the value.

    .PARAMETER Longitude
        GPS longitude in decimal format (xx.yyyyyy). Specify $null to clear the value.

    .PARAMETER PrimaryIP4
        The primary IPv4 address of the device. Accepts an ID or an object from Get-NbxIPAMAddress. Specify $null to clear the value.

    .PARAMETER PrimaryIP6
        The primary IPv6 address of the device. Accepts an ID or an object from Get-NbxIPAMAddress. Specify $null to clear the value.

    .PARAMETER OobIP
        The out-of-band management IP address of the device. Accepts an ID or an object from Get-NbxIPAMAddress. Specify $null to clear the value.

    .PARAMETER Cluster
        The cluster of the device. Accepts an ID or an object from Get-NbxVirtualizationCluster. Specify $null to clear the value.

    .PARAMETER VirtualChassis
        The virtual chassis of the device. Accepts an ID or a NetBox object. Specify $null to clear the value.

    .PARAMETER VcPosition
        The position of the device in the virtual chassis. Specify $null to clear the value.

    .PARAMETER VcPriority
        The virtual chassis master election priority. Specify $null to clear the value.

    .PARAMETER ConfigTemplate
        The config template of the device. Accepts an ID or a NetBox object. Specify $null to clear the value.

    .PARAMETER Description
        A short description of the device. Specify $null to clear the value.

    .PARAMETER Comments
        Comments about the device. Supports Markdown. Specify $null to clear the value.

    .PARAMETER Tag
        The tags of the device. Accepts tag IDs or objects from Get-NbxTag. Replaces the current tags.

    .PARAMETER CustomField
        Custom field values as a hashtable, e.g. @{ cost_center = '1234' }.

    .PARAMETER OptionalAttribute
        Additional NetBox fields as a hashtable with the API field names as keys, for fields that do not have a parameter. Named parameters take precedence over values in the hashtable.

    .PARAMETER PassThru
        Returns the updated device. By default, this cmdlet does not generate any output.

    .PARAMETER Force
        Updates the object without asking for confirmation.

    .PARAMETER WhatIf
        Shows what would happen if the cmdlet runs. The cmdlet is not run.

    .PARAMETER Confirm
        Prompts you for confirmation before running the cmdlet.

    .EXAMPLE
        Set-NbxDCIMDevice -Id 42 -Description 'Updated with NetboxTools'

        Updates the description of the device with ID 42.

    .EXAMPLE
        Get-NbxDCIMDevice -Query @{ q = 'example' } | Set-NbxDCIMDevice -Description 'Updated' -PassThru

        Updates the description of all devices matching the search 'example' and returns the updated devices.

    .INPUTS
        System.UInt64, NetboxTools.DCIMDevice
        You can pipe device IDs or device objects to this cmdlet.

    .OUTPUTS
        None, NetboxTools.DCIMDevice
        With -PassThru the updated device is returned.

    .LINK
        Get-NbxDCIMDevice

    .LINK
        New-NbxDCIMDevice

    .LINK
        Remove-NbxDCIMDevice
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    [OutputType('NetboxTools.DCIMDevice')]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [NbxIdTransformation('dcim/devices')]
        [uint64[]]$Id,

        [Parameter()]
        [string]$Name,

        [Parameter()]
        [Alias('Device_Role')]
        [NbxIdTransformation('dcim/device-roles')]
        [Nullable[uint64]]$Role,

        [Parameter()]
        [Alias('device_type')]
        [NbxIdTransformation('dcim/device-types')]
        [Nullable[uint64]]$DeviceType,

        [Parameter()]
        [NbxIdTransformation('dcim/sites')]
        [Nullable[uint64]]$Site,

        [Parameter()]
        [NbxChoiceTransformation()]
        [ArgumentCompletions('offline', 'active', 'planned', 'staged', 'failed', 'inventory', 'decommissioning')]
        [string]$Status,

        [Parameter()]
        [NbxIdTransformation('tenancy/tenants')]
        [Nullable[uint64]]$Tenant,

        [Parameter()]
        [NbxIdTransformation('dcim/platforms')]
        [Nullable[uint64]]$Platform,

        [Parameter()]
        [string]$Serial,

        [Parameter()]
        [Alias('asset_tag')]
        [string]$AssetTag,

        [Parameter()]
        [NbxIdTransformation('dcim/locations')]
        [Nullable[uint64]]$Location,

        [Parameter()]
        [NbxIdTransformation('dcim/racks')]
        [Nullable[uint64]]$Rack,

        [Parameter()]
        [Nullable[decimal]]$Position,

        [Parameter()]
        [NbxChoiceTransformation()]
        [ArgumentCompletions('front', 'rear')]
        [string]$Face,

        [Parameter()]
        [NbxChoiceTransformation()]
        [ArgumentCompletions('front-to-rear', 'rear-to-front', 'left-to-right', 'right-to-left', 'side-to-rear', 'rear-to-side', 'bottom-to-top', 'top-to-bottom', 'passive', 'mixed')]
        [string]$Airflow,

        [Parameter()]
        [Nullable[decimal]]$Latitude,

        [Parameter()]
        [Nullable[decimal]]$Longitude,

        [Parameter()]
        [Alias('primary_ip4')]
        [NbxIdTransformation('ipam/ip-addresses')]
        [Nullable[uint64]]$PrimaryIP4,

        [Parameter()]
        [Alias('primary_ip6')]
        [NbxIdTransformation('ipam/ip-addresses')]
        [Nullable[uint64]]$PrimaryIP6,

        [Parameter()]
        [Alias('oob_ip')]
        [NbxIdTransformation('ipam/ip-addresses')]
        [Nullable[uint64]]$OobIP,

        [Parameter()]
        [NbxIdTransformation('virtualization/clusters')]
        [Nullable[uint64]]$Cluster,

        [Parameter()]
        [Alias('virtual_chassis')]
        [NbxIdTransformation('dcim/virtual-chassis')]
        [Nullable[uint64]]$VirtualChassis,

        [Parameter()]
        [Alias('vc_position')]
        [Nullable[int]]$VcPosition,

        [Parameter()]
        [Alias('vc_priority')]
        [Nullable[int]]$VcPriority,

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
            if (($Force -and -not $WhatIfPreference) -or $PSCmdlet.ShouldProcess("device $ObjectId", 'Update')) {
                $Result = InvokeNbxRestMethod -Endpoint "dcim/devices/$ObjectId/" -Method PATCH -Body $Body -TypeName 'NetboxTools.DCIMDevice'
                if ($PassThru) {
                    $Result
                }
            }
        }
    }
}
