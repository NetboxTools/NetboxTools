function Get-NbxIPAMAvailableIP {
    <#
    .SYNOPSIS
        Gets available IP addresses within a prefix.

    .DESCRIPTION
        Gets the IP addresses within a prefix that are not in use, from the NetBox API endpoint 'ipam/prefixes/{id}/available-ips'.

    .PARAMETER Prefix
        The ID of the prefix. Accepts prefix objects from Get-NbxIPAMPrefix, also from the pipeline.

    .PARAMETER Query
        Filters supported by the NetBox API as a hashtable, e.g. @{ vrf_id = 2 }.

    .PARAMETER Limit
        The maximum number of IP addresses to return for each prefix.

    .EXAMPLE
        Get-NbxIPAMPrefix -Prefix '192.0.2.0/24' | Get-NbxIPAMAvailableIP -Limit 1

        Gets the next available IP address in the prefix 192.0.2.0/24.

    .INPUTS
        System.UInt64, NetboxTools.IPAMPrefix
        You can pipe prefix IDs or prefix objects to this cmdlet.

    .OUTPUTS
        System.Management.Automation.PSObject

    .LINK
        Get-NbxIPAMPrefix
    #>
    [CmdletBinding()]
    [OutputType([psobject])]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [Alias('Id', 'Prefix_ID')]
        [NbxIdTransformation('ipam/prefixes')]
        [uint64[]]$Prefix,

        [Parameter()]
        [hashtable]$Query,

        [Parameter()]
        [ValidateRange(1, [int]::MaxValue)]
        [int]$Limit
    )

    process {
        foreach ($PrefixId in $Prefix) {
            InvokeNbxRestMethod -Endpoint "ipam/prefixes/$PrefixId/available-ips/" -Query $Query -Limit $Limit
        }
    }
}
