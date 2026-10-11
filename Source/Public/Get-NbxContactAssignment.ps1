function Get-NbxContactAssignment {
    <#
    .SYNOPSIS
        Gets contact assignments from NetBox.

    .DESCRIPTION
        Gets contact assignments from the NetBox API endpoint 'tenancy/contact-assignments'. Without parameters all contact assignments are returned,
        the cmdlet follows the pagination of the API.

        Contact assignment objects are returned as they are returned by the API, with the type name 'NetboxTools.ContactAssignment',
        and can be piped to the other cmdlets of the module.

    .PARAMETER Id
        The ID of the contact assignment to get. Accepts contact assignment objects from the pipeline.

    .PARAMETER Query
        Filters supported by the NetBox API as a hashtable, e.g. @{ q = 'search text' }. Filters with multiple values are specified as arrays. See the API documentation of your NetBox instance for available filters.

    .PARAMETER Limit
        The maximum number of contact assignments to return. By default all matching contact assignments are returned.

    .EXAMPLE
        Get-NbxContactAssignment

        Gets all contact assignments.

    .EXAMPLE
        Get-NbxContactAssignment -Id 42

        Gets the contact assignment with ID 42.

    .EXAMPLE
        Get-NbxContactAssignment -Query @{ q = 'example' } -Limit 10

        Gets the first 10 contact assignments matching the search 'example'.

    .INPUTS
        System.UInt64, NetboxTools.ContactAssignment
        You can pipe contact assignment IDs or contact assignment objects to this cmdlet.

    .OUTPUTS
        NetboxTools.ContactAssignment

    .LINK
        New-NbxContactAssignment

    .LINK
        Set-NbxContactAssignment

    .LINK
        Remove-NbxContactAssignment
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'All', Justification = 'Kept for backward compatibility, all objects are returned by default.')]
    [CmdletBinding(DefaultParameterSetName = 'Query')]
    [OutputType('NetboxTools.ContactAssignment')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipeline)]
        [NbxIdTransformation('tenancy/contact-assignments')]
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
                InvokeNbxRestMethod -Endpoint "tenancy/contact-assignments/$ObjectId/" -TypeName 'NetboxTools.ContactAssignment'
            }
            return
        }

        $Filter = @{}
        if ($Query) {
            foreach ($Key in $Query.Keys) {
                $Filter[$Key] = $Query[$Key]
            }
        }

        InvokeNbxRestMethod -Endpoint 'tenancy/contact-assignments/' -Query $Filter -Limit $Limit -TypeName 'NetboxTools.ContactAssignment'
    }
}
