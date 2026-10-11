function Get-NbxDCIMCable {
    <#
    .SYNOPSIS
        Gets cables from NetBox.

    .DESCRIPTION
        Gets cables from the NetBox API endpoint 'dcim/cables'. Without parameters all cables are returned,
        the cmdlet follows the pagination of the API.

        Cable objects are returned as they are returned by the API, with the type name 'NetboxTools.DCIMCable',
        and can be piped to the other cmdlets of the module.

    .PARAMETER Id
        The ID of the cable to get. Accepts cable objects from the pipeline.

    .PARAMETER Label
        Filters cables by label. Multiple values return cables matching any of the values.

    .PARAMETER Query
        Filters supported by the NetBox API as a hashtable, e.g. @{ q = 'search text' }. Filters with multiple values are specified as arrays. See the API documentation of your NetBox instance for available filters.

    .PARAMETER Limit
        The maximum number of cables to return. By default all matching cables are returned.

    .EXAMPLE
        Get-NbxDCIMCable

        Gets all cables.

    .EXAMPLE
        Get-NbxDCIMCable -Id 42

        Gets the cable with ID 42.

    .EXAMPLE
        Get-NbxDCIMCable -Label 'example'

        Gets cables where the label is 'example'.

    .EXAMPLE
        Get-NbxDCIMCable -Query @{ q = 'example' } -Limit 10

        Gets the first 10 cables matching the search 'example'.

    .INPUTS
        System.UInt64, NetboxTools.DCIMCable
        You can pipe cable IDs or cable objects to this cmdlet.

    .OUTPUTS
        NetboxTools.DCIMCable

    .LINK
        New-NbxDCIMCable

    .LINK
        Set-NbxDCIMCable

    .LINK
        Remove-NbxDCIMCable
    #>
    [CmdletBinding(DefaultParameterSetName = 'Query')]
    [OutputType('NetboxTools.DCIMCable')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipeline)]
        [NbxIdTransformation('dcim/cables')]
        [uint64[]]$Id,

        [Parameter(ParameterSetName = 'Query')]
        [string[]]$Label,

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
                InvokeNbxRestMethod -Endpoint "dcim/cables/$ObjectId/" -TypeName 'NetboxTools.DCIMCable'
            }
            return
        }

        $Filter = @{}
        if ($Query) {
            foreach ($Key in $Query.Keys) {
                $Filter[$Key] = $Query[$Key]
            }
        }
        if ($PSBoundParameters.ContainsKey('Label')) {
            $Filter['label'] = $Label
        }

        InvokeNbxRestMethod -Endpoint 'dcim/cables/' -Query $Filter -Limit $Limit -TypeName 'NetboxTools.DCIMCable'
    }
}
