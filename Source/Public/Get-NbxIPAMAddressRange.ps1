function Get-NbxIPAMAddressRange {

    [CmdletBinding()]
    param
    (
        [Parameter()]
        [uint64[]]$Id
    )

    if ($Id) {
        $Id | ForEach-Object {
            Write-Verbose "Getting IPAM Address Range with ID: $($_) at $($script:NbxConfig.URI)/ipam/ip-ranges/$($_)/"
            InvokeNbxRestMethod -URI "$($script:NbxConfig.URI)/ipam/ip-ranges/$($_)" -Method GET
        }
    }
    else {
        Write-Verbose "Getting All IPAM Address Ranges at $($script:NbxConfig.URI)/ipam/ip-ranges"
        InvokeNbxRestMethod -URI "$($script:NbxConfig.URI)/ipam/ip-ranges/?limit=9999" -Method GET
    }

}
