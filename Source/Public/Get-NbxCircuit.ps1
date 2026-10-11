function Get-NbxCircuit {
    <#
    .SYNOPSIS
        Gets circuits from NetBox.

    .DESCRIPTION
        Gets circuits from the NetBox API endpoint 'circuits/circuits'. Without parameters all circuits are returned,
        the cmdlet follows the pagination of the API.

        Circuit objects are returned as they are returned by the API, with the type name 'NetboxTools.Circuit',
        and can be piped to the other cmdlets of the module.

    .PARAMETER Id
        The ID of the circuit to get. Accepts circuit objects from the pipeline.

    .PARAMETER CID
        Filters circuits by circuit ID. Multiple values return circuits matching any of the values.

    .PARAMETER Query
        Filters supported by the NetBox API as a hashtable, e.g. @{ q = 'search text' }. Filters with multiple values are specified as arrays. See the API documentation of your NetBox instance for available filters.

    .PARAMETER Limit
        The maximum number of circuits to return. By default all matching circuits are returned.

    .EXAMPLE
        Get-NbxCircuit

        Gets all circuits.

    .EXAMPLE
        Get-NbxCircuit -Id 42

        Gets the circuit with ID 42.

    .EXAMPLE
        Get-NbxCircuit -CID 'example'

        Gets circuits where the circuit ID is 'example'.

    .EXAMPLE
        Get-NbxCircuit -Query @{ q = 'example' } -Limit 10

        Gets the first 10 circuits matching the search 'example'.

    .INPUTS
        System.UInt64, NetboxTools.Circuit
        You can pipe circuit IDs or circuit objects to this cmdlet.

    .OUTPUTS
        NetboxTools.Circuit

    .LINK
        New-NbxCircuit

    .LINK
        Set-NbxCircuit

    .LINK
        Remove-NbxCircuit
    #>
    [CmdletBinding(DefaultParameterSetName = 'Query')]
    [OutputType('NetboxTools.Circuit')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipeline)]
        [NbxIdTransformation('circuits/circuits')]
        [uint64[]]$Id,

        [Parameter(ParameterSetName = 'Query')]
        [string[]]$CID,

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
                InvokeNbxRestMethod -Endpoint "circuits/circuits/$ObjectId/" -TypeName 'NetboxTools.Circuit'
            }
            return
        }

        $Filter = @{}
        if ($Query) {
            foreach ($Key in $Query.Keys) {
                $Filter[$Key] = $Query[$Key]
            }
        }
        if ($PSBoundParameters.ContainsKey('CID')) {
            $Filter['cid'] = $CID
        }

        InvokeNbxRestMethod -Endpoint 'circuits/circuits/' -Query $Filter -Limit $Limit -TypeName 'NetboxTools.Circuit'
    }
}
