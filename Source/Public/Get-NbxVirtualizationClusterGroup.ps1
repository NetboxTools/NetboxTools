function Get-NbxVirtualizationClusterGroup {

    [CmdletBinding()]
    param
    (
        [string]$Name,

        [string]$Slug,

        [string]$Description,

        [string]$Query,

        [uint64[]]$Id,

        [uint16]$Limit,

        [uint16]$Offset,

        [switch]$Raw
    )

    $Segments = [System.Collections.ArrayList]::new(@('virtualization', 'cluster-groups'))

    $URIComponents = BuildURIComponents -URISegments $Segments -ParametersDictionary $PSBoundParameters

    $uri = BuildNewURI -Segments $URIComponents.Segments -Parameters $URIComponents.Parameters

    InvokeNbxRequest -URI $uri -Raw:$Raw

}
