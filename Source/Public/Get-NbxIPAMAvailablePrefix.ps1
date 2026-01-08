function Get-NbxIPAMAvailablePrefix {

    <#
    .SYNOPSIS
        A convenience method for returning available range within a prefix

    .DESCRIPTION
        By default, the number of IPs returned will be equivalent to PAGINATE_COUNT. An arbitrary limit
        (up to MAX_PAGE_SIZE, if set) may be passed, however results will not be paginated

    .PARAMETER Prefix_ID
        A description of the Prefix_ID parameter.

    .EXAMPLE
        Get-NbxIPAMAvailableIP -Prefix_ID (Get-NbxIPAMPrefix -Prefix 192.0.2.0/24).id

        Get (Next) Available IP on the Prefix 192.0.2.0/24

    .NOTES
        Additional information about the function.
#>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory,
            ValueFromPipelineByPropertyName = $true)]
        [Alias('Id')]
        [uint64]$Prefix_ID
    )

    InvokeNbxRestMethod -URI "$($script:NbxConfig.URI)/ipam/prefixes/$Prefix_ID/available-prefixes" -Method GET

}
