function Get-NbxDCIMDeviceType {
    <#
    .SYNOPSIS
        Gets device types from NetBox.

    .DESCRIPTION
        Gets device types from the NetBox API endpoint 'dcim/device-types'. Without parameters all device types are returned,
        the cmdlet follows the pagination of the API.

        Device type objects are returned as they are returned by the API, with the type name 'NetboxTools.DCIMDeviceType',
        and can be piped to the other cmdlets of the module.

    .PARAMETER Id
        The ID of the device type to get. Accepts device type objects from the pipeline.

    .PARAMETER Model
        Filters device types by model. Multiple values return device types matching any of the values.

    .PARAMETER Query
        Filters supported by the NetBox API as a hashtable, e.g. @{ q = 'search text' }. Filters with multiple values are specified as arrays. See the API documentation of your NetBox instance for available filters.

    .PARAMETER Limit
        The maximum number of device types to return. By default all matching device types are returned.

    .EXAMPLE
        Get-NbxDCIMDeviceType

        Gets all device types.

    .EXAMPLE
        Get-NbxDCIMDeviceType -Id 42

        Gets the device type with ID 42.

    .EXAMPLE
        Get-NbxDCIMDeviceType -Model 'example'

        Gets device types where the model is 'example'.

    .EXAMPLE
        Get-NbxDCIMDeviceType -Query @{ q = 'example' } -Limit 10

        Gets the first 10 device types matching the search 'example'.

    .INPUTS
        System.UInt64, NetboxTools.DCIMDeviceType
        You can pipe device type IDs or device type objects to this cmdlet.

    .OUTPUTS
        NetboxTools.DCIMDeviceType
    #>
    [CmdletBinding(DefaultParameterSetName = 'Query')]
    [OutputType('NetboxTools.DCIMDeviceType')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipeline)]
        [NbxIdTransformation('dcim/device-types')]
        [uint64[]]$Id,

        [Parameter(ParameterSetName = 'Query')]
        [string[]]$Model,

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
                InvokeNbxRestMethod -Endpoint "dcim/device-types/$ObjectId/" -TypeName 'NetboxTools.DCIMDeviceType'
            }
            return
        }

        $Filter = @{}
        if ($Query) {
            foreach ($Key in $Query.Keys) {
                $Filter[$Key] = $Query[$Key]
            }
        }
        if ($PSBoundParameters.ContainsKey('Model')) {
            $Filter['model'] = $Model
        }

        InvokeNbxRestMethod -Endpoint 'dcim/device-types/' -Query $Filter -Limit $Limit -TypeName 'NetboxTools.DCIMDeviceType'
    }
}
