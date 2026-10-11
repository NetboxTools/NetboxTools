function Get-NbxContact {
    <#
    .SYNOPSIS
        Gets contacts from NetBox.

    .DESCRIPTION
        Gets contacts from the NetBox API endpoint 'tenancy/contacts'. Without parameters all contacts are returned,
        the cmdlet follows the pagination of the API.

        Contact objects are returned as they are returned by the API, with the type name 'NetboxTools.Contact',
        and can be piped to the other cmdlets of the module.

    .PARAMETER Id
        The ID of the contact to get. Accepts contact objects from the pipeline.

    .PARAMETER Name
        Filters contacts by name. Multiple values return contacts matching any of the values.

    .PARAMETER Query
        Filters supported by the NetBox API as a hashtable, e.g. @{ q = 'search text' }. Filters with multiple values are specified as arrays. See the API documentation of your NetBox instance for available filters.

    .PARAMETER Limit
        The maximum number of contacts to return. By default all matching contacts are returned.

    .EXAMPLE
        Get-NbxContact

        Gets all contacts.

    .EXAMPLE
        Get-NbxContact -Id 42

        Gets the contact with ID 42.

    .EXAMPLE
        Get-NbxContact -Name 'example'

        Gets contacts where the name is 'example'.

    .EXAMPLE
        Get-NbxContact -Query @{ q = 'example' } -Limit 10

        Gets the first 10 contacts matching the search 'example'.

    .INPUTS
        System.UInt64, NetboxTools.Contact
        You can pipe contact IDs or contact objects to this cmdlet.

    .OUTPUTS
        NetboxTools.Contact

    .LINK
        New-NbxContact

    .LINK
        Set-NbxContact

    .LINK
        Remove-NbxContact
    #>
    [CmdletBinding(DefaultParameterSetName = 'Query')]
    [OutputType('NetboxTools.Contact')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipeline)]
        [NbxIdTransformation('tenancy/contacts')]
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
                InvokeNbxRestMethod -Endpoint "tenancy/contacts/$ObjectId/" -TypeName 'NetboxTools.Contact'
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

        InvokeNbxRestMethod -Endpoint 'tenancy/contacts/' -Query $Filter -Limit $Limit -TypeName 'NetboxTools.Contact'
    }
}
