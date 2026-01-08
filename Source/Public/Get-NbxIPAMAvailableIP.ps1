function Get-NbxIPAMAvailableIP {

    <#
    .SYNOPSIS
        A convenience method for returning available IP addresses within a prefix

    .DESCRIPTION
        A convenience method for returning available IP addresses within a prefix

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
        [Parameter(Mandatory)]
        [Alias('Id')]
        [uint64]$Prefix_ID
    )

    InvokeNbxRestMethod -URI "$($script:NbxConfig.URI)/ipam/prefixes/$Prefix_ID/available-ips" -Method GET

}
