function Get-NbxCircuitType {
    <#
    .SYNOPSIS
        Gets circuit types from NetBox.

    .DESCRIPTION
        Gets circuit types from the NetBox API endpoint 'circuits/circuit-types'. Without parameters all circuit types are returned,
        the cmdlet follows the pagination of the API.

        Circuit type objects are returned as they are returned by the API, with the type name 'NetboxTools.CircuitType',
        and can be piped to the other cmdlets of the module.

    .PARAMETER Id
        The ID of the circuit type to get. Accepts circuit type objects from the pipeline.

    .PARAMETER Name
        Filters circuit types by name. Multiple values return circuit types matching any of the values.

    .PARAMETER Query
        Filters supported by the NetBox API as a hashtable, e.g. @{ q = 'search text' }. Filters with multiple values are specified as arrays. See the API documentation of your NetBox instance for available filters.

    .PARAMETER Limit
        The maximum number of circuit types to return. By default all matching circuit types are returned.

    .EXAMPLE
        Get-NbxCircuitType

        Gets all circuit types.

    .EXAMPLE
        Get-NbxCircuitType -Id 42

        Gets the circuit type with ID 42.

    .EXAMPLE
        Get-NbxCircuitType -Name 'example'

        Gets circuit types where the name is 'example'.

    .EXAMPLE
        Get-NbxCircuitType -Query @{ q = 'example' } -Limit 10

        Gets the first 10 circuit types matching the search 'example'.

    .INPUTS
        System.UInt64, NetboxTools.CircuitType
        You can pipe circuit type IDs or circuit type objects to this cmdlet.

    .OUTPUTS
        NetboxTools.CircuitType
    #>
    [CmdletBinding(DefaultParameterSetName = 'Query')]
    [OutputType('NetboxTools.CircuitType')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipeline)]
        [NbxIdTransformation('circuits/circuit-types')]
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
                InvokeNbxRestMethod -Endpoint "circuits/circuit-types/$ObjectId/" -TypeName 'NetboxTools.CircuitType'
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

        InvokeNbxRestMethod -Endpoint 'circuits/circuit-types/' -Query $Filter -Limit $Limit -TypeName 'NetboxTools.CircuitType'
    }
}
