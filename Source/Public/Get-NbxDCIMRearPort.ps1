function Get-NbxDCIMRearPort {
    <#
    .SYNOPSIS
        Gets rear ports from NetBox.

    .DESCRIPTION
        Gets rear ports from the NetBox API endpoint 'dcim/rear-ports'. Without parameters all rear ports are returned,
        the cmdlet follows the pagination of the API.

        Rear port objects are returned as they are returned by the API, with the type name 'NetboxTools.DCIMRearPort',
        and can be piped to the other cmdlets of the module.

    .PARAMETER Id
        The ID of the rear port to get. Accepts rear port objects from the pipeline.

    .PARAMETER Name
        Filters rear ports by name. Multiple values return rear ports matching any of the values.

    .PARAMETER Query
        Filters supported by the NetBox API as a hashtable, e.g. @{ q = 'search text' }. Filters with multiple values are specified as arrays. See the API documentation of your NetBox instance for available filters.

    .PARAMETER Limit
        The maximum number of rear ports to return. By default all matching rear ports are returned.

    .EXAMPLE
        Get-NbxDCIMRearPort

        Gets all rear ports.

    .EXAMPLE
        Get-NbxDCIMRearPort -Id 42

        Gets the rear port with ID 42.

    .EXAMPLE
        Get-NbxDCIMRearPort -Name 'example'

        Gets rear ports where the name is 'example'.

    .EXAMPLE
        Get-NbxDCIMRearPort -Query @{ q = 'example' } -Limit 10

        Gets the first 10 rear ports matching the search 'example'.

    .INPUTS
        System.UInt64, NetboxTools.DCIMRearPort
        You can pipe rear port IDs or rear port objects to this cmdlet.

    .OUTPUTS
        NetboxTools.DCIMRearPort

    .LINK
        New-NbxDCIMRearPort

    .LINK
        Set-NbxDCIMRearPort

    .LINK
        Remove-NbxDCIMRearPort
    #>
    [CmdletBinding(DefaultParameterSetName = 'Query')]
    [OutputType('NetboxTools.DCIMRearPort')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipeline)]
        [NbxIdTransformation('dcim/rear-ports')]
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
                InvokeNbxRestMethod -Endpoint "dcim/rear-ports/$ObjectId/" -TypeName 'NetboxTools.DCIMRearPort'
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

        InvokeNbxRestMethod -Endpoint 'dcim/rear-ports/' -Query $Filter -Limit $Limit -TypeName 'NetboxTools.DCIMRearPort'
    }
}
