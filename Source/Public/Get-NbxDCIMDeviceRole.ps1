function Get-NbxDCIMDeviceRole {

    [CmdletBinding()]
    param
    (
        [uint16]$Limit,

        [uint16]$Offset,

        [Parameter(ParameterSetName = 'ById')]
        [uint64[]]$Id,

        [string]$Name,

        [string]$Slug,

        [string]$Color,

        [bool]$VM_Role,

        [switch]$Raw
    )

    switch ($PSCmdlet.ParameterSetName) {
        'ById' {
            foreach ($DRId in $Id) {
                $Segments = [System.Collections.ArrayList]::new(@('dcim', 'device-roles', $DRId))

                $URIComponents = BuildURIComponents -URISegments $Segments -ParametersDictionary $PSBoundParameters -SkipParameterByName 'Id', 'Raw'

                $URI = BuildNewURI -Segments $URIComponents.Segments -Parameters $URIComponents.Parameters

                InvokeNbxRequest -URI $URI -Raw:$Raw
            }

            break
        }

        default {
            InvokeNbxRestMethod -URI "$($script:NbxConfig.URI)/dcim/device-roles/?limit=9999" -Method GET
        }
    }

}
