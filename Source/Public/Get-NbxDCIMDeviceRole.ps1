function Get-NbxDCIMDeviceRole {

    [CmdletBinding()]
    param
    (
        [Parameter(ParameterSetName = 'ById')]
        [uint64[]]$Id
    )

    if ($Id) {
        $Id | ForEach-Object {
            InvokeNbxRestMethod -URI "$($script:NbxConfig.URI)/dcim/device-roles/$($_)/" -Method GET
        }
    }
    else {
        InvokeNbxRestMethod -URI "$($script:NbxConfig.URI)/dcim/device-roles/?limit=9999" -Method GET
    }

}
