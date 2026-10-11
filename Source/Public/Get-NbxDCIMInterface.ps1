function Get-NbxDCIMInterface {
    <#
    .SYNOPSIS
        Gets interfaces from NetBox.

    .DESCRIPTION
        Gets interfaces from the NetBox API endpoint 'dcim/interfaces'. Without parameters all interfaces are returned,
        the cmdlet follows the pagination of the API.

        Interface objects are returned as they are returned by the API, with the type name 'NetboxTools.DCIMInterface',
        and can be piped to the other cmdlets of the module.

    .PARAMETER Id
        The ID of the interface to get. Accepts interface objects from the pipeline.

    .PARAMETER Name
        Filters interfaces by name. Multiple values return interfaces matching any of the values.

    .PARAMETER Query
        Filters supported by the NetBox API as a hashtable, e.g. @{ q = 'search text' }. Filters with multiple values are specified as arrays. See the API documentation of your NetBox instance for available filters.

    .PARAMETER Limit
        The maximum number of interfaces to return. By default all matching interfaces are returned.

    .EXAMPLE
        Get-NbxDCIMInterface

        Gets all interfaces.

    .EXAMPLE
        Get-NbxDCIMInterface -Id 42

        Gets the interface with ID 42.

    .EXAMPLE
        Get-NbxDCIMInterface -Name 'example'

        Gets interfaces where the name is 'example'.

    .EXAMPLE
        Get-NbxDCIMInterface -Query @{ q = 'example' } -Limit 10

        Gets the first 10 interfaces matching the search 'example'.

    .INPUTS
        System.UInt64, NetboxTools.DCIMInterface
        You can pipe interface IDs or interface objects to this cmdlet.

    .OUTPUTS
        NetboxTools.DCIMInterface

    .LINK
        New-NbxDCIMInterface

    .LINK
        Set-NbxDCIMInterface

    .LINK
        Remove-NbxDCIMInterface
    #>
    [CmdletBinding(DefaultParameterSetName = 'Query')]
    [OutputType('NetboxTools.DCIMInterface')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipeline)]
        [NbxIdTransformation('dcim/interfaces')]
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
                InvokeNbxRestMethod -Endpoint "dcim/interfaces/$ObjectId/" -TypeName 'NetboxTools.DCIMInterface'
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

        InvokeNbxRestMethod -Endpoint 'dcim/interfaces/' -Query $Filter -Limit $Limit -TypeName 'NetboxTools.DCIMInterface'
    }
}
