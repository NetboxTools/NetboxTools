function Get-NbxIPAMAvailablePrefix {
    <#
    .SYNOPSIS
        Gets available prefixes within a prefix.

    .DESCRIPTION
        Gets the prefixes within a prefix that are not in use, from the NetBox API endpoint 'ipam/prefixes/{id}/available-prefixes'.

    .PARAMETER Prefix
        The ID of the prefix. Accepts prefix objects from Get-NbxIPAMPrefix, also from the pipeline.

    .PARAMETER Query
        Filters supported by the NetBox API as a hashtable, e.g. @{ vrf_id = 2 }.

    .PARAMETER Limit
        The maximum number of prefixes to return for each prefix.

    .EXAMPLE
        Get-NbxIPAMPrefix -Prefix '192.0.2.0/24' | Get-NbxIPAMAvailablePrefix

        Gets the unused prefixes within the prefix 192.0.2.0/24.

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
            InvokeNbxRestMethod -Endpoint "ipam/prefixes/$PrefixId/available-prefixes/" -Query $Query -Limit $Limit
        }
    }
}
