function Get-NbxContentType {
    <#
    .SYNOPSIS
        Gets object types from NetBox.

    .DESCRIPTION
        Gets object types from the NetBox API endpoint 'core/object-types'. Without parameters all object types are returned,
        the cmdlet follows the pagination of the API.

        Object type objects are returned as they are returned by the API, with the type name 'NetboxTools.ContentType',
        and can be piped to the other cmdlets of the module.

    .PARAMETER Id
        The ID of the object type to get. Accepts object type objects from the pipeline.

    .PARAMETER Query
        Filters supported by the NetBox API as a hashtable, e.g. @{ q = 'search text' }. Filters with multiple values are specified as arrays. See the API documentation of your NetBox instance for available filters.

    .PARAMETER Limit
        The maximum number of object types to return. By default all matching object types are returned.

    .EXAMPLE
        Get-NbxContentType

        Gets all object types.

    .EXAMPLE
        Get-NbxContentType -Id 42

        Gets the object type with ID 42.

    .EXAMPLE
        Get-NbxContentType -Query @{ q = 'example' } -Limit 10

        Gets the first 10 object types matching the search 'example'.

    .INPUTS
        System.UInt64, NetboxTools.ContentType
        You can pipe object type IDs or object type objects to this cmdlet.

    .OUTPUTS
        NetboxTools.ContentType
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'All', Justification = 'Kept for backward compatibility, all objects are returned by default.')]
    [CmdletBinding(DefaultParameterSetName = 'Query')]
    [OutputType('NetboxTools.ContentType')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipeline)]
        [NbxIdTransformation('core/object-types')]
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
                InvokeNbxRestMethod -Endpoint "core/object-types/$ObjectId/" -TypeName 'NetboxTools.ContentType'
            }
            return
        }

        $Filter = @{}
        if ($Query) {
            foreach ($Key in $Query.Keys) {
                $Filter[$Key] = $Query[$Key]
            }
        }

        InvokeNbxRestMethod -Endpoint 'core/object-types/' -Query $Filter -Limit $Limit -TypeName 'NetboxTools.ContentType'
    }
}
