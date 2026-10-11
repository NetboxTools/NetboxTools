function Get-NbxTag {
    <#
    .SYNOPSIS
        Gets tags from NetBox.

    .DESCRIPTION
        Gets tags from the NetBox API endpoint 'extras/tags'. Without parameters all tags are returned,
        the cmdlet follows the pagination of the API.

        Tag objects are returned as they are returned by the API, with the type name 'NetboxTools.Tag',
        and can be piped to the other cmdlets of the module.

    .PARAMETER Id
        The ID of the tag to get. Accepts tag objects from the pipeline.

    .PARAMETER Name
        Filters tags by name. Multiple values return tags matching any of the values.

    .PARAMETER Query
        Filters supported by the NetBox API as a hashtable, e.g. @{ q = 'search text' }. Filters with multiple values are specified as arrays. See the API documentation of your NetBox instance for available filters.

    .PARAMETER Limit
        The maximum number of tags to return. By default all matching tags are returned.

    .EXAMPLE
        Get-NbxTag

        Gets all tags.

    .EXAMPLE
        Get-NbxTag -Id 42

        Gets the tag with ID 42.

    .EXAMPLE
        Get-NbxTag -Name 'example'

        Gets tags where the name is 'example'.

    .EXAMPLE
        Get-NbxTag -Query @{ q = 'example' } -Limit 10

        Gets the first 10 tags matching the search 'example'.

    .INPUTS
        System.UInt64, NetboxTools.Tag
        You can pipe tag IDs or tag objects to this cmdlet.

    .OUTPUTS
        NetboxTools.Tag
    #>
    [CmdletBinding(DefaultParameterSetName = 'Query')]
    [OutputType('NetboxTools.Tag')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipeline)]
        [NbxIdTransformation('extras/tags')]
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
                InvokeNbxRestMethod -Endpoint "extras/tags/$ObjectId/" -TypeName 'NetboxTools.Tag'
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

        InvokeNbxRestMethod -Endpoint 'extras/tags/' -Query $Filter -Limit $Limit -TypeName 'NetboxTools.Tag'
    }
}
