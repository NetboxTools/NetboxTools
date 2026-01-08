function Add-NbxDCIMRearPort {

    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param
    (
        [Parameter(Mandatory)]
        [uint64]$Device,

        [Parameter(Mandatory)]
        [string]$Name,
        
        [Parameter(Mandatory)]
        [string]$Type,

        [uint64]$Module,

        [string]$Label,

        [ValidatePattern('^[0-9a-f]{6}$')]
        [string]$Color,

        [uint16]$Positions = 1,

        [string]$Description,

        [bool]$Mark_Connected,

        [uint16[]]$Tags
    )

    $Body = @{
        device         = $Device
        name           = $Name
        type           = $Type
        module         = $Module
        label          = $Label
        color          = $Color
        positions      = $Positions
        description    = $Description
        mark_connected = $Mark_Connected
        tags           = $Tag
    }

    $Json = $Body | ConvertTo-Json -Depth 100

    InvokeNbxRestMethod -URI "$($script:NbxConfig.URI)/dcim/rear-ports" -Method POST -Body $Json

}
