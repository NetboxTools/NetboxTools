function Get-NbxIPAMAddress {
    <#
    .SYNOPSIS
        Gets IP addresses from NetBox.

    .DESCRIPTION
        Gets IP addresses from the NetBox API endpoint 'ipam/ip-addresses'. Without parameters all IP addresses are returned,
        the cmdlet follows the pagination of the API.

        IP address objects are returned as they are returned by the API, with the type name 'NetboxTools.IPAMAddress',
        and can be piped to the other cmdlets of the module.

    .PARAMETER Id
        The ID of the IP address to get. Accepts IP address objects from the pipeline.

    .PARAMETER Address
        Filters IP addresses by address. Multiple values return IP addresses matching any of the values.

    .PARAMETER Query
        Filters supported by the NetBox API as a hashtable, e.g. @{ q = 'search text' }. Filters with multiple values are specified as arrays. See the API documentation of your NetBox instance for available filters.

    .PARAMETER Limit
        The maximum number of IP addresses to return. By default all matching IP addresses are returned.

    .EXAMPLE
        Get-NbxIPAMAddress

        Gets all IP addresses.

    .EXAMPLE
        Get-NbxIPAMAddress -Id 42

        Gets the IP address with ID 42.

    .EXAMPLE
        Get-NbxIPAMAddress -Address 'example'

        Gets IP addresses where the address is 'example'.

    .EXAMPLE
        Get-NbxIPAMAddress -Query @{ q = 'example' } -Limit 10

        Gets the first 10 IP addresses matching the search 'example'.

    .INPUTS
        System.UInt64, NetboxTools.IPAMAddress
        You can pipe IP address IDs or IP address objects to this cmdlet.

    .OUTPUTS
        NetboxTools.IPAMAddress

    .LINK
        New-NbxIPAMAddress

    .LINK
        Set-NbxIPAMAddress

    .LINK
        Remove-NbxIPAMAddress
    #>
    [CmdletBinding(DefaultParameterSetName = 'Query')]
    [OutputType('NetboxTools.IPAMAddress')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipeline)]
        [NbxIdTransformation('ipam/ip-addresses')]
        [uint64[]]$Id,

        [Parameter(ParameterSetName = 'Query')]
        [string[]]$Address,

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
                InvokeNbxRestMethod -Endpoint "ipam/ip-addresses/$ObjectId/" -TypeName 'NetboxTools.IPAMAddress'
            }
            return
        }

        $Filter = @{}
        if ($Query) {
            foreach ($Key in $Query.Keys) {
                $Filter[$Key] = $Query[$Key]
            }
        }
        if ($PSBoundParameters.ContainsKey('Address')) {
            $Filter['address'] = $Address
        }

        InvokeNbxRestMethod -Endpoint 'ipam/ip-addresses/' -Query $Filter -Limit $Limit -TypeName 'NetboxTools.IPAMAddress'
    }
}
