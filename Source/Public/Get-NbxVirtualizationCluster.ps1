function Get-NbxVirtualizationCluster {
    <#
    .SYNOPSIS
        Gets clusters from NetBox.

    .DESCRIPTION
        Gets clusters from the NetBox API endpoint 'virtualization/clusters'. Without parameters all clusters are returned,
        the cmdlet follows the pagination of the API.

        Cluster objects are returned as they are returned by the API, with the type name 'NetboxTools.VirtualizationCluster',
        and can be piped to the other cmdlets of the module.

    .PARAMETER Id
        The ID of the cluster to get. Accepts cluster objects from the pipeline.

    .PARAMETER Name
        Filters clusters by name. Multiple values return clusters matching any of the values.

    .PARAMETER Query
        Filters supported by the NetBox API as a hashtable, e.g. @{ q = 'search text' }. Filters with multiple values are specified as arrays. See the API documentation of your NetBox instance for available filters.

    .PARAMETER Limit
        The maximum number of clusters to return. By default all matching clusters are returned.

    .EXAMPLE
        Get-NbxVirtualizationCluster

        Gets all clusters.

    .EXAMPLE
        Get-NbxVirtualizationCluster -Id 42

        Gets the cluster with ID 42.

    .EXAMPLE
        Get-NbxVirtualizationCluster -Name 'example'

        Gets clusters where the name is 'example'.

    .EXAMPLE
        Get-NbxVirtualizationCluster -Query @{ q = 'example' } -Limit 10

        Gets the first 10 clusters matching the search 'example'.

    .INPUTS
        System.UInt64, NetboxTools.VirtualizationCluster
        You can pipe cluster IDs or cluster objects to this cmdlet.

    .OUTPUTS
        NetboxTools.VirtualizationCluster
    #>
    [CmdletBinding(DefaultParameterSetName = 'Query')]
    [OutputType('NetboxTools.VirtualizationCluster')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipeline)]
        [NbxIdTransformation('virtualization/clusters')]
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
                InvokeNbxRestMethod -Endpoint "virtualization/clusters/$ObjectId/" -TypeName 'NetboxTools.VirtualizationCluster'
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

        InvokeNbxRestMethod -Endpoint 'virtualization/clusters/' -Query $Filter -Limit $Limit -TypeName 'NetboxTools.VirtualizationCluster'
    }
}
