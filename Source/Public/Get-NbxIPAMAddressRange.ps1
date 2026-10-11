function Get-NbxIPAMAddressRange {
    <#
    .SYNOPSIS
        Gets IP ranges from NetBox.

    .DESCRIPTION
        Gets IP ranges from the NetBox API endpoint 'ipam/ip-ranges'. Without parameters all IP ranges are returned,
        the cmdlet follows the pagination of the API.

        IP range objects are returned as they are returned by the API, with the type name 'NetboxTools.IPAMAddressRange',
        and can be piped to the other cmdlets of the module.

    .PARAMETER Id
        The ID of the IP range to get. Accepts IP range objects from the pipeline.

    .PARAMETER Query
        Filters supported by the NetBox API as a hashtable, e.g. @{ q = 'search text' }. Filters with multiple values are specified as arrays. See the API documentation of your NetBox instance for available filters.

    .PARAMETER Limit
        The maximum number of IP ranges to return. By default all matching IP ranges are returned.

    .EXAMPLE
        Get-NbxIPAMAddressRange

        Gets all IP ranges.

    .EXAMPLE
        Get-NbxIPAMAddressRange -Id 42

        Gets the IP range with ID 42.

    .EXAMPLE
        Get-NbxIPAMAddressRange -Query @{ q = 'example' } -Limit 10

        Gets the first 10 IP ranges matching the search 'example'.

    .INPUTS
        System.UInt64, NetboxTools.IPAMAddressRange
        You can pipe IP range IDs or IP range objects to this cmdlet.

    .OUTPUTS
        NetboxTools.IPAMAddressRange

    .LINK
        New-NbxIPAMAddressRange

    .LINK
        Set-NbxIPAMAddressRange

    .LINK
        Remove-NbxIPAMAddressRange
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'All', Justification = 'Kept for backward compatibility, all objects are returned by default.')]
    [CmdletBinding(DefaultParameterSetName = 'Query')]
    [OutputType('NetboxTools.IPAMAddressRange')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipeline)]
        [NbxIdTransformation('ipam/ip-ranges')]
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
                InvokeNbxRestMethod -Endpoint "ipam/ip-ranges/$ObjectId/" -TypeName 'NetboxTools.IPAMAddressRange'
            }
            return
        }

        $Filter = @{}
        if ($Query) {
            foreach ($Key in $Query.Keys) {
                $Filter[$Key] = $Query[$Key]
            }
        }

        InvokeNbxRestMethod -Endpoint 'ipam/ip-ranges/' -Query $Filter -Limit $Limit -TypeName 'NetboxTools.IPAMAddressRange'
    }
}
