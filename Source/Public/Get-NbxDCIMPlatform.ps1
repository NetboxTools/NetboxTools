function Get-NbxDCIMPlatform {
    <#
    .SYNOPSIS
        Gets platforms from NetBox.

    .DESCRIPTION
        Gets platforms from the NetBox API endpoint 'dcim/platforms'. Without parameters all platforms are returned,
        the cmdlet follows the pagination of the API.

        Platform objects are returned as they are returned by the API, with the type name 'NetboxTools.DCIMPlatform',
        and can be piped to the other cmdlets of the module.

    .PARAMETER Id
        The ID of the platform to get. Accepts platform objects from the pipeline.

    .PARAMETER Name
        Filters platforms by name. Multiple values return platforms matching any of the values.

    .PARAMETER Query
        Filters supported by the NetBox API as a hashtable, e.g. @{ q = 'search text' }. Filters with multiple values are specified as arrays. See the API documentation of your NetBox instance for available filters.

    .PARAMETER Limit
        The maximum number of platforms to return. By default all matching platforms are returned.

    .EXAMPLE
        Get-NbxDCIMPlatform

        Gets all platforms.

    .EXAMPLE
        Get-NbxDCIMPlatform -Id 42

        Gets the platform with ID 42.

    .EXAMPLE
        Get-NbxDCIMPlatform -Name 'example'

        Gets platforms where the name is 'example'.

    .EXAMPLE
        Get-NbxDCIMPlatform -Query @{ q = 'example' } -Limit 10

        Gets the first 10 platforms matching the search 'example'.

    .INPUTS
        System.UInt64, NetboxTools.DCIMPlatform
        You can pipe platform IDs or platform objects to this cmdlet.

    .OUTPUTS
        NetboxTools.DCIMPlatform
    #>
    [CmdletBinding(DefaultParameterSetName = 'Query')]
    [OutputType('NetboxTools.DCIMPlatform')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipeline)]
        [NbxIdTransformation('dcim/platforms')]
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
                InvokeNbxRestMethod -Endpoint "dcim/platforms/$ObjectId/" -TypeName 'NetboxTools.DCIMPlatform'
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

        InvokeNbxRestMethod -Endpoint 'dcim/platforms/' -Query $Filter -Limit $Limit -TypeName 'NetboxTools.DCIMPlatform'
    }
}
