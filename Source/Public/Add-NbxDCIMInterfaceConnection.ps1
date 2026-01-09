function Add-NbxDCIMInterfaceConnection {

    <#
    .SYNOPSIS
        Create a new connection between two interfaces

    .DESCRIPTION
        Create a new connection between two interfaces

    .PARAMETER Connection_Status
        Is it connected or planned?

    .PARAMETER Interface_A
        Database ID of interface A

    .PARAMETER Interface_B
        Database ID of interface B

    .EXAMPLE
        PS C:\> Add-NbxDCIMInterfaceConnection -Interface_A $value1 -Interface_B $value2

    .NOTES
        Additional information about the function.
#>

    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param
    (
        [object]$Connection_Status,

        [Parameter(Mandatory)]
        [uint64]$Interface_A,

        [Parameter(Mandatory)]
        [uint64]$Interface_B
    )

    # Verify if both Interfaces exist
    Get-NbxDCIMInterface -Id $Interface_A -ErrorAction Stop | Out-null
    Get-NbxDCIMInterface -Id $Interface_B -ErrorAction Stop | Out-null

    $Body = @{
        connection_status = $Connection_Status
        interface_a      = $Interface_A
        interface_b      = $Interface_B
    }

    $Json = $Body | ConvertTo-Json -Depth 100

    InvokeNbxRestMethod -URI "$($script:NbxConfig.URI)/dcim/interface-connections/" -Method POST -Body $Json

}
