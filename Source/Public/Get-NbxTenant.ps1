function Get-NbxTenant {
    <#
    .SYNOPSIS
        Gets tenants from NetBox.

    .DESCRIPTION
        Gets tenants from the NetBox API endpoint 'tenancy/tenants'. Without parameters all tenants are returned,
        the cmdlet follows the pagination of the API.

        Tenant objects are returned as they are returned by the API, with the type name 'NetboxTools.Tenant',
        and can be piped to the other cmdlets of the module.

    .PARAMETER Id
        The ID of the tenant to get. Accepts tenant objects from the pipeline.

    .PARAMETER Name
        Filters tenants by name. Multiple values return tenants matching any of the values.

    .PARAMETER Query
        Filters supported by the NetBox API as a hashtable, e.g. @{ q = 'search text' }. Filters with multiple values are specified as arrays. See the API documentation of your NetBox instance for available filters.

    .PARAMETER Limit
        The maximum number of tenants to return. By default all matching tenants are returned.

    .EXAMPLE
        Get-NbxTenant

        Gets all tenants.

    .EXAMPLE
        Get-NbxTenant -Id 42

        Gets the tenant with ID 42.

    .EXAMPLE
        Get-NbxTenant -Name 'example'

        Gets tenants where the name is 'example'.

    .EXAMPLE
        Get-NbxTenant -Query @{ q = 'example' } -Limit 10

        Gets the first 10 tenants matching the search 'example'.

    .INPUTS
        System.UInt64, NetboxTools.Tenant
        You can pipe tenant IDs or tenant objects to this cmdlet.

    .OUTPUTS
        NetboxTools.Tenant

    .LINK
        New-NbxTenant

    .LINK
        Set-NbxTenant

    .LINK
        Remove-NbxTenant
    #>
    [CmdletBinding(DefaultParameterSetName = 'Query')]
    [OutputType('NetboxTools.Tenant')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipeline)]
        [NbxIdTransformation('tenancy/tenants')]
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
                InvokeNbxRestMethod -Endpoint "tenancy/tenants/$ObjectId/" -TypeName 'NetboxTools.Tenant'
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

        InvokeNbxRestMethod -Endpoint 'tenancy/tenants/' -Query $Filter -Limit $Limit -TypeName 'NetboxTools.Tenant'
    }
}
