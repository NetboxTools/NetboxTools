function Add-NbxVirtualMachineInterface {

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string]$Name,

        [Parameter(Mandatory)]
        [uint64]$Virtual_Machine,

        [boolean]$Enabled = $true,

        [string]$MAC_Address,

        [uint16]$MTU,

        [string]$Description,

        [switch]$Raw
    )
    $Body = @{
        Name            = $Name
        Virtual_Machine = $Virtual_Machine
        Enabled         = $Enabled
        MAC_Address     = $MAC_Address
        MTU             = $MTU
        Description     = $Description
    }

    $Json = $Body | ConvertTo-Json -Depth 100

    InvokeNbxRestMethod -URI "$($script:NbxConfig.URI)/virtualization/interfaces" -Method POST -Body $Json

}
