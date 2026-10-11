function Get-NbxDCIMFrontPort {
    <#
    .SYNOPSIS
        Gets front ports from NetBox.

    .DESCRIPTION
        Gets front ports from the NetBox API endpoint 'dcim/front-ports'. Without parameters all front ports are returned,
        the cmdlet follows the pagination of the API.

        Front port objects are returned as they are returned by the API, with the type name 'NetboxTools.DCIMFrontPort',
        and can be piped to the other cmdlets of the module.

    .PARAMETER Id
        The ID of the front port to get. Accepts front port objects from the pipeline.

    .PARAMETER Name
        Filters front ports by name. Multiple values return front ports matching any of the values.

    .PARAMETER Query
        Filters supported by the NetBox API as a hashtable, e.g. @{ q = 'search text' }. Filters with multiple values are specified as arrays. See the API documentation of your NetBox instance for available filters.

    .PARAMETER Limit
        The maximum number of front ports to return. By default all matching front ports are returned.

    .EXAMPLE
        Get-NbxDCIMFrontPort

        Gets all front ports.

    .EXAMPLE
        Get-NbxDCIMFrontPort -Id 42

        Gets the front port with ID 42.

    .EXAMPLE
        Get-NbxDCIMFrontPort -Name 'example'

        Gets front ports where the name is 'example'.

    .EXAMPLE
        Get-NbxDCIMFrontPort -Query @{ q = 'example' } -Limit 10

        Gets the first 10 front ports matching the search 'example'.

    .INPUTS
        System.UInt64, NetboxTools.DCIMFrontPort
        You can pipe front port IDs or front port objects to this cmdlet.

    .OUTPUTS
        NetboxTools.DCIMFrontPort

    .LINK
        New-NbxDCIMFrontPort

    .LINK
        Set-NbxDCIMFrontPort

    .LINK
        Remove-NbxDCIMFrontPort
    #>
    [CmdletBinding(DefaultParameterSetName = 'Query')]
    [OutputType('NetboxTools.DCIMFrontPort')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipeline)]
        [NbxIdTransformation('dcim/front-ports')]
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
                InvokeNbxRestMethod -Endpoint "dcim/front-ports/$ObjectId/" -TypeName 'NetboxTools.DCIMFrontPort'
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

        InvokeNbxRestMethod -Endpoint 'dcim/front-ports/' -Query $Filter -Limit $Limit -TypeName 'NetboxTools.DCIMFrontPort'
    }
}
