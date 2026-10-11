function Get-NbxContactRole {
    <#
    .SYNOPSIS
        Gets contact roles from NetBox.

    .DESCRIPTION
        Gets contact roles from the NetBox API endpoint 'tenancy/contact-roles'. Without parameters all contact roles are returned,
        the cmdlet follows the pagination of the API.

        Contact role objects are returned as they are returned by the API, with the type name 'NetboxTools.ContactRole',
        and can be piped to the other cmdlets of the module.

    .PARAMETER Id
        The ID of the contact role to get. Accepts contact role objects from the pipeline.

    .PARAMETER Name
        Filters contact roles by name. Multiple values return contact roles matching any of the values.

    .PARAMETER Query
        Filters supported by the NetBox API as a hashtable, e.g. @{ q = 'search text' }. Filters with multiple values are specified as arrays. See the API documentation of your NetBox instance for available filters.

    .PARAMETER Limit
        The maximum number of contact roles to return. By default all matching contact roles are returned.

    .EXAMPLE
        Get-NbxContactRole

        Gets all contact roles.

    .EXAMPLE
        Get-NbxContactRole -Id 42

        Gets the contact role with ID 42.

    .EXAMPLE
        Get-NbxContactRole -Name 'example'

        Gets contact roles where the name is 'example'.

    .EXAMPLE
        Get-NbxContactRole -Query @{ q = 'example' } -Limit 10

        Gets the first 10 contact roles matching the search 'example'.

    .INPUTS
        System.UInt64, NetboxTools.ContactRole
        You can pipe contact role IDs or contact role objects to this cmdlet.

    .OUTPUTS
        NetboxTools.ContactRole

    .LINK
        New-NbxContactRole

    .LINK
        Set-NbxContactRole

    .LINK
        Remove-NbxContactRole
    #>
    [CmdletBinding(DefaultParameterSetName = 'Query')]
    [OutputType('NetboxTools.ContactRole')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipeline)]
        [NbxIdTransformation('tenancy/contact-roles')]
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
                InvokeNbxRestMethod -Endpoint "tenancy/contact-roles/$ObjectId/" -TypeName 'NetboxTools.ContactRole'
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

        InvokeNbxRestMethod -Endpoint 'tenancy/contact-roles/' -Query $Filter -Limit $Limit -TypeName 'NetboxTools.ContactRole'
    }
}
