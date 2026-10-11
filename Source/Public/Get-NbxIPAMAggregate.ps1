function Get-NbxIPAMAggregate {
    <#
    .SYNOPSIS
        Gets aggregates from NetBox.

    .DESCRIPTION
        Gets aggregates from the NetBox API endpoint 'ipam/aggregates'. Without parameters all aggregates are returned,
        the cmdlet follows the pagination of the API.

        Aggregate objects are returned as they are returned by the API, with the type name 'NetboxTools.IPAMAggregate',
        and can be piped to the other cmdlets of the module.

    .PARAMETER Id
        The ID of the aggregate to get. Accepts aggregate objects from the pipeline.

    .PARAMETER Prefix
        Filters aggregates by prefix. Multiple values return aggregates matching any of the values.

    .PARAMETER Query
        Filters supported by the NetBox API as a hashtable, e.g. @{ q = 'search text' }. Filters with multiple values are specified as arrays. See the API documentation of your NetBox instance for available filters.

    .PARAMETER Limit
        The maximum number of aggregates to return. By default all matching aggregates are returned.

    .EXAMPLE
        Get-NbxIPAMAggregate

        Gets all aggregates.

    .EXAMPLE
        Get-NbxIPAMAggregate -Id 42

        Gets the aggregate with ID 42.

    .EXAMPLE
        Get-NbxIPAMAggregate -Prefix 'example'

        Gets aggregates where the prefix is 'example'.

    .EXAMPLE
        Get-NbxIPAMAggregate -Query @{ q = 'example' } -Limit 10

        Gets the first 10 aggregates matching the search 'example'.

    .INPUTS
        System.UInt64, NetboxTools.IPAMAggregate
        You can pipe aggregate IDs or aggregate objects to this cmdlet.

    .OUTPUTS
        NetboxTools.IPAMAggregate
    #>
    [CmdletBinding(DefaultParameterSetName = 'Query')]
    [OutputType('NetboxTools.IPAMAggregate')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipeline)]
        [NbxIdTransformation('ipam/aggregates')]
        [uint64[]]$Id,

        [Parameter(ParameterSetName = 'Query')]
        [string[]]$Prefix,

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
                InvokeNbxRestMethod -Endpoint "ipam/aggregates/$ObjectId/" -TypeName 'NetboxTools.IPAMAggregate'
            }
            return
        }

        $Filter = @{}
        if ($Query) {
            foreach ($Key in $Query.Keys) {
                $Filter[$Key] = $Query[$Key]
            }
        }
        if ($PSBoundParameters.ContainsKey('Prefix')) {
            $Filter['prefix'] = $Prefix
        }

        InvokeNbxRestMethod -Endpoint 'ipam/aggregates/' -Query $Filter -Limit $Limit -TypeName 'NetboxTools.IPAMAggregate'
    }
}
