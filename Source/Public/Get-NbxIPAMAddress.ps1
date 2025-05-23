function Get-NbxIPAMAddress {

    [CmdletBinding(DefaultParameterSetName = 'Query')]
    param
    (
        [Parameter(ParameterSetName = 'Query',
            Position = 0)]
        [string]$Address,

        [Parameter(ParameterSetName = 'ByID')]
        [uint64[]]$Id,

        [Parameter(ParameterSetName = 'Query')]
        [string]$Query,

        [Parameter(ParameterSetName = 'Query')]
        [object]$Family,

        [Parameter(ParameterSetName = 'Query')]
        [string]$Parent,

        [Parameter(ParameterSetName = 'Query')]
        [byte]$Mask_Length,

        [Parameter(ParameterSetName = 'Query')]
        [string]$VRF,

        [Parameter(ParameterSetName = 'Query')]
        [uint64]$VRF_Id,

        [Parameter(ParameterSetName = 'Query')]
        [string]$Tenant,

        [Parameter(ParameterSetName = 'Query')]
        [uint64]$Tenant_Id,

        [Parameter(ParameterSetName = 'Query')]
        [string]$Device,

        [Parameter(ParameterSetName = 'Query')]
        [uint64]$Device_ID,

        [Parameter(ParameterSetName = 'Query')]
        [string]$Virtual_Machine,

        [Parameter(ParameterSetName = 'Query')]
        [uint64]$Virtual_Machine_Id,

        [Parameter(ParameterSetName = 'Query')]
        [uint64]$Interface_Id,

        [Parameter(ParameterSetName = 'Query')]
        [object]$Status,

        [Parameter(ParameterSetName = 'Query')]
        [object]$Role,

        [Parameter(ParameterSetName = 'Query')]
        [uint16]$Limit,

        [Parameter(ParameterSetName = 'Query')]
        [uint16]$Offset,

        [switch]$Raw
    )

    switch ($PSCmdlet.ParameterSetName) {
        'ById' {
            foreach ($IP_ID in $Id) {
                $Segments = [System.Collections.ArrayList]::new(@('ipam', 'ip-addresses', $IP_ID))

                $URIComponents = BuildURIComponents -URISegments $Segments -ParametersDictionary $PSBoundParameters -SkipParameterByName 'Id'

                $uri = BuildNewURI -Segments $URIComponents.Segments -Parameters $URIComponents.Parameters

                InvokeNbxRequest -URI $uri -Raw:$Raw
            }

            break
        }

        default {
            $Segments = [System.Collections.ArrayList]::new(@('ipam', 'ip-addresses'))

            $URIComponents = BuildURIComponents -URISegments $Segments -ParametersDictionary $PSBoundParameters

            $uri = BuildNewURI -Segments $URIComponents.Segments -Parameters $URIComponents.Parameters

            InvokeNbxRequest -URI $uri -Raw:$Raw

            break
        }
    }

}
