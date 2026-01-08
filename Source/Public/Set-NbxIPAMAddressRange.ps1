function Set-NbxIPAMAddressRange {

    [CmdletBinding(ConfirmImpact = 'Medium',
        SupportsShouldProcess = $true)]
    param
    (
        [Parameter(Mandatory,
            ValueFromPipelineByPropertyName = $true)]
        [uint64[]]$Id,

        [string]$Start_Address,

        [string]$End_Address,

        [object]$Status,

        [uint64]$Tenant,

        [uint64]$VRF,

        [object]$Role,

        [hashtable]$Custom_Fields,

        [string]$Description,

        [string]$Comments,

        [object[]]$Tags,

        [switch]$Mark_Utilized
    )

    $Body = @{
        Start_Address  = $Start_Address
        End_Address    = $End_Address
        Status         = $Status
        Tenant         = $Tenant
        VRF            = $VRF
        Role           = $Role
        Custom_Fields  = $Custom_Fields
        Description    = $Description
        Comments       = $Comments
        Tags           = $Tags
        Mark_Utilized  = $Mark_Utilized
    }

    $Json = $Body | ConvertTo-Json -Depth 100

    InvokeNbxRestMethod -URI "$($script:NbxConfig.URI)/ipam/ip-ranges/$($_)" -Method PATCH -Body $Json

}
