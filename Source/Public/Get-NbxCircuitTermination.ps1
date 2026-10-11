function Get-NbxCircuitTermination {
    <#
    .SYNOPSIS
        Gets circuit terminations from NetBox.

    .DESCRIPTION
        Gets circuit terminations from the NetBox API endpoint 'circuits/circuit-terminations'. Without parameters all circuit terminations are returned,
        the cmdlet follows the pagination of the API.

        Circuit termination objects are returned as they are returned by the API, with the type name 'NetboxTools.CircuitTermination',
        and can be piped to the other cmdlets of the module.

    .PARAMETER Id
        The ID of the circuit termination to get. Accepts circuit termination objects from the pipeline.

    .PARAMETER Query
        Filters supported by the NetBox API as a hashtable, e.g. @{ q = 'search text' }. Filters with multiple values are specified as arrays. See the API documentation of your NetBox instance for available filters.

    .PARAMETER Limit
        The maximum number of circuit terminations to return. By default all matching circuit terminations are returned.

    .EXAMPLE
        Get-NbxCircuitTermination

        Gets all circuit terminations.

    .EXAMPLE
        Get-NbxCircuitTermination -Id 42

        Gets the circuit termination with ID 42.

    .EXAMPLE
        Get-NbxCircuitTermination -Query @{ q = 'example' } -Limit 10

        Gets the first 10 circuit terminations matching the search 'example'.

    .INPUTS
        System.UInt64, NetboxTools.CircuitTermination
        You can pipe circuit termination IDs or circuit termination objects to this cmdlet.

    .OUTPUTS
        NetboxTools.CircuitTermination
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'All', Justification = 'Kept for backward compatibility, all objects are returned by default.')]
    [CmdletBinding(DefaultParameterSetName = 'Query')]
    [OutputType('NetboxTools.CircuitTermination')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipeline)]
        [NbxIdTransformation('circuits/circuit-terminations')]
        [uint64[]]$Id,

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
                InvokeNbxRestMethod -Endpoint "circuits/circuit-terminations/$ObjectId/" -TypeName 'NetboxTools.CircuitTermination'
            }
            return
        }

        $Filter = @{}
        if ($Query) {
            foreach ($Key in $Query.Keys) {
                $Filter[$Key] = $Query[$Key]
            }
        }

        InvokeNbxRestMethod -Endpoint 'circuits/circuit-terminations/' -Query $Filter -Limit $Limit -TypeName 'NetboxTools.CircuitTermination'
    }
}
