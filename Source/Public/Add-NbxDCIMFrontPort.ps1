function Add-NbxDCIMFrontPort {
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

        [Parameter(Mandatory)]
        [uint64]$Rear_Port,

        [uint64]$Module,

        [string]$Label,

        [ValidatePattern('^[0-9a-f]{6}$')]
        [string]$Color,

        [uint64]$Rear_Port_Position,

        [string]$Description,

        [bool]$Mark_Connected,

        [uint16[]]$Tags

    )

    $Body = @{
        device             = $Device
        name               = $Name
        type               = $Type
        rear_port          = $Rear_Port
        module             = $Module
        label              = $Label
        color              = $Color
        rear_port_position = $Rear_Port_Position
        description        = $Description
        mark_connected     = $Mark_Connected
        tags               = $Tags
    }

    $Json = $Body | ConvertTo-Json -Depth 100

    InvokeNbxRestMethod -URI "$($script:NbxConfig.URI)/api/dcim/front-ports" -Method POST -Body $Json

}
