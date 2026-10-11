function Get-NbxDCIMSite {
    <#
    .SYNOPSIS
        Gets sites from NetBox.

    .DESCRIPTION
        Gets sites from the NetBox API endpoint 'dcim/sites'. Without parameters all sites are returned,
        the cmdlet follows the pagination of the API.

        Site objects are returned as they are returned by the API, with the type name 'NetboxTools.DCIMSite',
        and can be piped to the other cmdlets of the module.

    .PARAMETER Id
        The ID of the site to get. Accepts site objects from the pipeline.

    .PARAMETER Name
        Filters sites by name. Multiple values return sites matching any of the values.

    .PARAMETER Query
        Filters supported by the NetBox API as a hashtable, e.g. @{ q = 'search text' }. Filters with multiple values are specified as arrays. See the API documentation of your NetBox instance for available filters.

    .PARAMETER Limit
        The maximum number of sites to return. By default all matching sites are returned.

    .EXAMPLE
        Get-NbxDCIMSite

        Gets all sites.

    .EXAMPLE
        Get-NbxDCIMSite -Id 42

        Gets the site with ID 42.

    .EXAMPLE
        Get-NbxDCIMSite -Name 'example'

        Gets sites where the name is 'example'.

    .EXAMPLE
        Get-NbxDCIMSite -Query @{ q = 'example' } -Limit 10

        Gets the first 10 sites matching the search 'example'.

    .INPUTS
        System.UInt64, NetboxTools.DCIMSite
        You can pipe site IDs or site objects to this cmdlet.

    .OUTPUTS
        NetboxTools.DCIMSite

    .LINK
        New-NbxDCIMSite

    .LINK
        Set-NbxDCIMSite

    .LINK
        Remove-NbxDCIMSite
    #>
    [CmdletBinding(DefaultParameterSetName = 'Query')]
    [OutputType('NetboxTools.DCIMSite')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipeline)]
        [NbxIdTransformation('dcim/sites')]
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
                InvokeNbxRestMethod -Endpoint "dcim/sites/$ObjectId/" -TypeName 'NetboxTools.DCIMSite'
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

        InvokeNbxRestMethod -Endpoint 'dcim/sites/' -Query $Filter -Limit $Limit -TypeName 'NetboxTools.DCIMSite'
    }
}
