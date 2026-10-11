function Get-NbxCircuitProvider {
    <#
    .SYNOPSIS
        Gets circuit providers from NetBox.

    .DESCRIPTION
        Gets circuit providers from the NetBox API endpoint 'circuits/providers'. Without parameters all circuit providers are returned,
        the cmdlet follows the pagination of the API.

        Circuit provider objects are returned as they are returned by the API, with the type name 'NetboxTools.CircuitProvider',
        and can be piped to the other cmdlets of the module.

    .PARAMETER Id
        The ID of the circuit provider to get. Accepts circuit provider objects from the pipeline.

    .PARAMETER Name
        Filters circuit providers by name. Multiple values return circuit providers matching any of the values.

    .PARAMETER Query
        Filters supported by the NetBox API as a hashtable, e.g. @{ q = 'search text' }. Filters with multiple values are specified as arrays. See the API documentation of your NetBox instance for available filters.

    .PARAMETER Limit
        The maximum number of circuit providers to return. By default all matching circuit providers are returned.

    .EXAMPLE
        Get-NbxCircuitProvider

        Gets all circuit providers.

    .EXAMPLE
        Get-NbxCircuitProvider -Id 42

        Gets the circuit provider with ID 42.

    .EXAMPLE
        Get-NbxCircuitProvider -Name 'example'

        Gets circuit providers where the name is 'example'.

    .EXAMPLE
        Get-NbxCircuitProvider -Query @{ q = 'example' } -Limit 10

        Gets the first 10 circuit providers matching the search 'example'.

    .INPUTS
        System.UInt64, NetboxTools.CircuitProvider
        You can pipe circuit provider IDs or circuit provider objects to this cmdlet.

    .OUTPUTS
        NetboxTools.CircuitProvider
    #>
    [CmdletBinding(DefaultParameterSetName = 'Query')]
    [OutputType('NetboxTools.CircuitProvider')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipeline)]
        [NbxIdTransformation('circuits/providers')]
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
                InvokeNbxRestMethod -Endpoint "circuits/providers/$ObjectId/" -TypeName 'NetboxTools.CircuitProvider'
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

        InvokeNbxRestMethod -Endpoint 'circuits/providers/' -Query $Filter -Limit $Limit -TypeName 'NetboxTools.CircuitProvider'
    }
}
