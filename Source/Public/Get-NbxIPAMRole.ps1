function Get-NbxIPAMRole {
    <#
    .SYNOPSIS
        Gets IPAM roles from NetBox.

    .DESCRIPTION
        Gets IPAM roles from the NetBox API endpoint 'ipam/roles'. Without parameters all IPAM roles are returned,
        the cmdlet follows the pagination of the API.

        IPAM role objects are returned as they are returned by the API, with the type name 'NetboxTools.IPAMRole',
        and can be piped to the other cmdlets of the module.

    .PARAMETER Id
        The ID of the IPAM role to get. Accepts IPAM role objects from the pipeline.

    .PARAMETER Name
        Filters IPAM roles by name. Multiple values return IPAM roles matching any of the values.

    .PARAMETER Query
        Filters supported by the NetBox API as a hashtable, e.g. @{ q = 'search text' }. Filters with multiple values are specified as arrays. See the API documentation of your NetBox instance for available filters.

    .PARAMETER Limit
        The maximum number of IPAM roles to return. By default all matching IPAM roles are returned.

    .EXAMPLE
        Get-NbxIPAMRole

        Gets all IPAM roles.

    .EXAMPLE
        Get-NbxIPAMRole -Id 42

        Gets the IPAM role with ID 42.

    .EXAMPLE
        Get-NbxIPAMRole -Name 'example'

        Gets IPAM roles where the name is 'example'.

    .EXAMPLE
        Get-NbxIPAMRole -Query @{ q = 'example' } -Limit 10

        Gets the first 10 IPAM roles matching the search 'example'.

    .INPUTS
        System.UInt64, NetboxTools.IPAMRole
        You can pipe IPAM role IDs or IPAM role objects to this cmdlet.

    .OUTPUTS
        NetboxTools.IPAMRole
    #>
    [CmdletBinding(DefaultParameterSetName = 'Query')]
    [OutputType('NetboxTools.IPAMRole')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipeline)]
        [NbxIdTransformation('ipam/roles')]
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
                InvokeNbxRestMethod -Endpoint "ipam/roles/$ObjectId/" -TypeName 'NetboxTools.IPAMRole'
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

        InvokeNbxRestMethod -Endpoint 'ipam/roles/' -Query $Filter -Limit $Limit -TypeName 'NetboxTools.IPAMRole'
    }
}
