function Get-NbxIPAMPrefix {
    <#
    .SYNOPSIS
        Gets prefixes from NetBox.

    .DESCRIPTION
        Gets prefixes from the NetBox API endpoint 'ipam/prefixes'. Without parameters all prefixes are returned,
        the cmdlet follows the pagination of the API.

        Prefix objects are returned as they are returned by the API, with the type name 'NetboxTools.IPAMPrefix',
        and can be piped to the other cmdlets of the module.

    .PARAMETER Id
        The ID of the prefix to get. Accepts prefix objects from the pipeline.

    .PARAMETER Prefix
        Filters prefixes by prefix. Multiple values return prefixes matching any of the values.

    .PARAMETER Query
        Filters supported by the NetBox API as a hashtable, e.g. @{ q = 'search text' }. Filters with multiple values are specified as arrays. See the API documentation of your NetBox instance for available filters.

    .PARAMETER Limit
        The maximum number of prefixes to return. By default all matching prefixes are returned.

    .EXAMPLE
        Get-NbxIPAMPrefix

        Gets all prefixes.

    .EXAMPLE
        Get-NbxIPAMPrefix -Id 42

        Gets the prefix with ID 42.

    .EXAMPLE
        Get-NbxIPAMPrefix -Prefix 'example'

        Gets prefixes where the prefix is 'example'.

    .EXAMPLE
        Get-NbxIPAMPrefix -Query @{ q = 'example' } -Limit 10

        Gets the first 10 prefixes matching the search 'example'.

    .INPUTS
        System.UInt64, NetboxTools.IPAMPrefix
        You can pipe prefix IDs or prefix objects to this cmdlet.

    .OUTPUTS
        NetboxTools.IPAMPrefix

    .LINK
        New-NbxIPAMPrefix

    .LINK
        Set-NbxIPAMPrefix

    .LINK
        Remove-NbxIPAMPrefix
    #>
    [CmdletBinding(DefaultParameterSetName = 'Query')]
    [OutputType('NetboxTools.IPAMPrefix')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipeline)]
        [NbxIdTransformation('ipam/prefixes')]
        [uint64[]]$Id,

        [Parameter(ParameterSetName = 'Query')]
        [string[]]$Prefix,

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
                InvokeNbxRestMethod -Endpoint "ipam/prefixes/$ObjectId/" -TypeName 'NetboxTools.IPAMPrefix'
            }
            return
        }

        $Filter = @{}
        if ($Query) {
            foreach ($Key in $Query.Keys) {
                $Filter[$Key] = $Query[$Key]
            }
        }
        if ($PSBoundParameters.ContainsKey('Prefix')) {
            $Filter['prefix'] = $Prefix
        }

        InvokeNbxRestMethod -Endpoint 'ipam/prefixes/' -Query $Filter -Limit $Limit -TypeName 'NetboxTools.IPAMPrefix'
    }
}
