function Get-NbxIPAMAddress {

    [CmdletBinding()]
    param
    (

        [Parameter()]
        [uint64[]]$Id
    )

    if ($Id) {
        $Id | ForEach-Object {
            InvokeNbxRestMethod -URI "$($script:NbxConfig.URI)/ipam/ip-addresses/$($_)" -Method GET
        }
    }
    else {
        InvokeNbxRestMethod -URI "$($script:NbxConfig.URI)/ipam/ip-addresses?limit=9999" -Method GET
    }

}
