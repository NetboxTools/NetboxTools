function Get-NbxDCIMDevice {
    <#
    .SYNOPSIS
        Gets devices from NetBox.

    .DESCRIPTION
        Gets devices from the NetBox API endpoint 'dcim/devices'. Without parameters all devices are returned,
        the cmdlet follows the pagination of the API.

        Device objects are returned as they are returned by the API, with the type name 'NetboxTools.DCIMDevice',
        and can be piped to the other cmdlets of the module.

    .PARAMETER Id
        The ID of the device to get. Accepts device objects from the pipeline.

    .PARAMETER Name
        Filters devices by name. Multiple values return devices matching any of the values.

    .PARAMETER Query
        Filters supported by the NetBox API as a hashtable, e.g. @{ q = 'search text' }. Filters with multiple values are specified as arrays. See the API documentation of your NetBox instance for available filters.

    .PARAMETER Limit
        The maximum number of devices to return. By default all matching devices are returned.

    .EXAMPLE
        Get-NbxDCIMDevice

        Gets all devices.

    .EXAMPLE
        Get-NbxDCIMDevice -Id 42

        Gets the device with ID 42.

    .EXAMPLE
        Get-NbxDCIMDevice -Name 'example'

        Gets devices where the name is 'example'.

    .EXAMPLE
        Get-NbxDCIMDevice -Query @{ q = 'example' } -Limit 10

        Gets the first 10 devices matching the search 'example'.

    .INPUTS
        System.UInt64, NetboxTools.DCIMDevice
        You can pipe device IDs or device objects to this cmdlet.

    .OUTPUTS
        NetboxTools.DCIMDevice

    .LINK
        New-NbxDCIMDevice

    .LINK
        Set-NbxDCIMDevice

    .LINK
        Remove-NbxDCIMDevice
    #>
    [CmdletBinding(DefaultParameterSetName = 'Query')]
    [OutputType('NetboxTools.DCIMDevice')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipeline)]
        [NbxIdTransformation('dcim/devices')]
        [uint64[]]$Id,

        [Parameter(ParameterSetName = 'Query')]
        [string[]]$Name,

        [Parameter(ParameterSetName = 'Query')]
        [hashtable]$Query,

        # Returns all objects, which is the default. Kept for backward compatibility.
        [Parameter(ParameterSetName = 'Query', DontShow)]
        [switch]$All,

        [Parameter(ParameterSetName = 'Query')]
        [ValidateRange(1, [int]::MaxValue)]
        [int]$Limit
    )

    process {
        if ($PSCmdlet.ParameterSetName -eq 'Id') {
            foreach ($ObjectId in $Id) {
                InvokeNbxRestMethod -Endpoint "dcim/devices/$ObjectId/" -TypeName 'NetboxTools.DCIMDevice'
            }
            return
        }

        $Filter = @{}
        if ($Query) {
            foreach ($Key in $Query.Keys) {
                $Filter[$Key] = $Query[$Key]
            }
        }
        if ($PSBoundParameters.ContainsKey('Name')) {
            $Filter['name'] = $Name
        }

        InvokeNbxRestMethod -Endpoint 'dcim/devices/' -Query $Filter -Limit $Limit -TypeName 'NetboxTools.DCIMDevice'
    }
}
