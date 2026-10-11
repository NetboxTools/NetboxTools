function Get-NbxVirtualizationClusterGroup {
    <#
    .SYNOPSIS
        Gets cluster groups from NetBox.

    .DESCRIPTION
        Gets cluster groups from the NetBox API endpoint 'virtualization/cluster-groups'. Without parameters all cluster groups are returned,
        the cmdlet follows the pagination of the API.

        Cluster group objects are returned as they are returned by the API, with the type name 'NetboxTools.VirtualizationClusterGroup',
        and can be piped to the other cmdlets of the module.

    .PARAMETER Id
        The ID of the cluster group to get. Accepts cluster group objects from the pipeline.

    .PARAMETER Name
        Filters cluster groups by name. Multiple values return cluster groups matching any of the values.

    .PARAMETER Query
        Filters supported by the NetBox API as a hashtable, e.g. @{ q = 'search text' }. Filters with multiple values are specified as arrays. See the API documentation of your NetBox instance for available filters.

    .PARAMETER Limit
        The maximum number of cluster groups to return. By default all matching cluster groups are returned.

    .EXAMPLE
        Get-NbxVirtualizationClusterGroup

        Gets all cluster groups.

    .EXAMPLE
        Get-NbxVirtualizationClusterGroup -Id 42

        Gets the cluster group with ID 42.

    .EXAMPLE
        Get-NbxVirtualizationClusterGroup -Name 'example'

        Gets cluster groups where the name is 'example'.

    .EXAMPLE
        Get-NbxVirtualizationClusterGroup -Query @{ q = 'example' } -Limit 10

        Gets the first 10 cluster groups matching the search 'example'.

    .INPUTS
        System.UInt64, NetboxTools.VirtualizationClusterGroup
        You can pipe cluster group IDs or cluster group objects to this cmdlet.

    .OUTPUTS
        NetboxTools.VirtualizationClusterGroup
    #>
    [CmdletBinding(DefaultParameterSetName = 'Query')]
    [OutputType('NetboxTools.VirtualizationClusterGroup')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipeline)]
        [NbxIdTransformation('virtualization/cluster-groups')]
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
                InvokeNbxRestMethod -Endpoint "virtualization/cluster-groups/$ObjectId/" -TypeName 'NetboxTools.VirtualizationClusterGroup'
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

        InvokeNbxRestMethod -Endpoint 'virtualization/cluster-groups/' -Query $Filter -Limit $Limit -TypeName 'NetboxTools.VirtualizationClusterGroup'
    }
}
