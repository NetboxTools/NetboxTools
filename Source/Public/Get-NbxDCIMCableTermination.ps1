function Get-NbxDCIMCableTermination {
    <#
    .SYNOPSIS
        Gets cable terminations from NetBox.

    .DESCRIPTION
        Gets cable terminations from the NetBox API endpoint 'dcim/cable-terminations'. Without parameters all cable terminations are returned,
        the cmdlet follows the pagination of the API.

        Cable termination objects are returned as they are returned by the API, with the type name 'NetboxTools.DCIMCableTermination',
        and can be piped to the other cmdlets of the module.

    .PARAMETER Id
        The ID of the cable termination to get. Accepts cable termination objects from the pipeline.

    .PARAMETER Query
        Filters supported by the NetBox API as a hashtable, e.g. @{ q = 'search text' }. Filters with multiple values are specified as arrays. See the API documentation of your NetBox instance for available filters.

    .PARAMETER Limit
        The maximum number of cable terminations to return. By default all matching cable terminations are returned.

    .EXAMPLE
        Get-NbxDCIMCableTermination

        Gets all cable terminations.

    .EXAMPLE
        Get-NbxDCIMCableTermination -Id 42

        Gets the cable termination with ID 42.

    .EXAMPLE
        Get-NbxDCIMCableTermination -Query @{ q = 'example' } -Limit 10

        Gets the first 10 cable terminations matching the search 'example'.

    .INPUTS
        System.UInt64, NetboxTools.DCIMCableTermination
        You can pipe cable termination IDs or cable termination objects to this cmdlet.

    .OUTPUTS
        NetboxTools.DCIMCableTermination
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'All', Justification = 'Kept for backward compatibility, all objects are returned by default.')]
    [CmdletBinding(DefaultParameterSetName = 'Query')]
    [OutputType('NetboxTools.DCIMCableTermination')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipeline)]
        [NbxIdTransformation('dcim/cable-terminations')]
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
                InvokeNbxRestMethod -Endpoint "dcim/cable-terminations/$ObjectId/" -TypeName 'NetboxTools.DCIMCableTermination'
            }
            return
        }

        $Filter = @{}
        if ($Query) {
            foreach ($Key in $Query.Keys) {
                $Filter[$Key] = $Query[$Key]
            }
        }

        InvokeNbxRestMethod -Endpoint 'dcim/cable-terminations/' -Query $Filter -Limit $Limit -TypeName 'NetboxTools.DCIMCableTermination'
    }
}
