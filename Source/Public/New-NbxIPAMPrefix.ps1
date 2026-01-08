function New-NbxIPAMPrefix {

    [CmdletBinding(ConfirmImpact = 'low',
        SupportsShouldProcess = $true)]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string]$Prefix,

        [object]$Status = 'Active',

        [uint64]$Tenant,

        [object]$Role,

        [bool]$IsPool,

        [string]$Description,

        [uint64]$Site,

        [uint64]$VRF,

        [uint64]$VLAN,

        [hashtable]$Custom_Fields,

        [switch]$Raw
    )

    $Body = @{
        Prefix        = $Prefix
        Status       = $Status
        Tenant       = $Tenant
        Role         = $Role
        IsPool       = $IsPool
        Description  = $Description
        Site         = $Site
        VRF          = $VRF
        VLAN         = $VLAN
        Custom_Fields= $Custom_Fields
    }

    $Json = $Body | ConvertTo-Json -Depth 100

    InvokeNbxRestMethod -URI "$($script:NbxConfig.URI)/ipam/prefixes" -Method POST -Body $Json

}
