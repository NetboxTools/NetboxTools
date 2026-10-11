function Get-NbxDCIMDeviceRole {
    <#
    .SYNOPSIS
        Gets device roles from NetBox.

    .DESCRIPTION
        Gets device roles from the NetBox API endpoint 'dcim/device-roles'. Without parameters all device roles are returned,
        the cmdlet follows the pagination of the API.

        Device role objects are returned as they are returned by the API, with the type name 'NetboxTools.DCIMDeviceRole',
        and can be piped to the other cmdlets of the module.

    .PARAMETER Id
        The ID of the device role to get. Accepts device role objects from the pipeline.

    .PARAMETER Name
        Filters device roles by name. Multiple values return device roles matching any of the values.

    .PARAMETER Query
        Filters supported by the NetBox API as a hashtable, e.g. @{ q = 'search text' }. Filters with multiple values are specified as arrays. See the API documentation of your NetBox instance for available filters.

    .PARAMETER Limit
        The maximum number of device roles to return. By default all matching device roles are returned.

    .EXAMPLE
        Get-NbxDCIMDeviceRole

        Gets all device roles.

    .EXAMPLE
        Get-NbxDCIMDeviceRole -Id 42

        Gets the device role with ID 42.

    .EXAMPLE
        Get-NbxDCIMDeviceRole -Name 'example'

        Gets device roles where the name is 'example'.

    .EXAMPLE
        Get-NbxDCIMDeviceRole -Query @{ q = 'example' } -Limit 10

        Gets the first 10 device roles matching the search 'example'.

    .INPUTS
        System.UInt64, NetboxTools.DCIMDeviceRole
        You can pipe device role IDs or device role objects to this cmdlet.

    .OUTPUTS
        NetboxTools.DCIMDeviceRole
    #>
    [CmdletBinding(DefaultParameterSetName = 'Query')]
    [OutputType('NetboxTools.DCIMDeviceRole')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipeline)]
        [NbxIdTransformation('dcim/device-roles')]
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
                InvokeNbxRestMethod -Endpoint "dcim/device-roles/$ObjectId/" -TypeName 'NetboxTools.DCIMDeviceRole'
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

        InvokeNbxRestMethod -Endpoint 'dcim/device-roles/' -Query $Filter -Limit $Limit -TypeName 'NetboxTools.DCIMDeviceRole'
    }
}
