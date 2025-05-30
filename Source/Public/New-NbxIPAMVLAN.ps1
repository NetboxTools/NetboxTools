function New-NbxIPAMVLAN {

    <#
    .SYNOPSIS
        Create a new VLAN

    .DESCRIPTION
        Create a new VLAN in Netbox with a status of Active by default.

    .PARAMETER VID
        The VLAN ID.

    .PARAMETER Name
        The name of the VLAN.

    .PARAMETER Status
        Status of the VLAN. Defaults to Active

    .PARAMETER Tenant
        Tenant ID

    .PARAMETER Role
        Role such as anycast, loopback, etc... Defaults to nothing

    .PARAMETER Description
        Description of IP address

    .PARAMETER Custom_Fields
        Custom field hash table. Will be validated by the API service

    .PARAMETER Raw
        Return raw results from API service

    .PARAMETER Address
        IP address in CIDR notation: 192.168.1.1/24

    .EXAMPLE
        PS C:\> Create-NbxIPAMAddress

    .NOTES
        Additional information about the function.
#>

    [CmdletBinding(ConfirmImpact = 'low',
        SupportsShouldProcess = $true)]
    [OutputType([pscustomobject])]
    param
    (
        [Parameter(Mandatory = $true)]
        [uint16]$VID,

        [Parameter(Mandatory = $true)]
        [string]$Name,

        [object]$Status = 'Active',

        [uint64]$Tenant,

        [object]$Role,

        [string]$Description,

        [hashtable]$Custom_Fields,

        [switch]$Raw
    )

    #    $PSBoundParameters.Status = ValidateIPAMChoice -ProvidedValue $Status -VLANStatus

    #    if ($null -ne $Role) {
    #        $PSBoundParameters.Role = ValidateIPAMChoice -ProvidedValue $Role -IPAddressRole
    #    }

    $segments = [System.Collections.ArrayList]::new(@('ipam', 'vlans'))

    $URIComponents = BuildURIComponents -URISegments $segments -ParametersDictionary $PSBoundParameters

    $URI = BuildNewURI -Segments $URIComponents.Segments

    if ($PSCmdlet.ShouldProcess($nae, 'Create new Vlan $($vid)')) {
        InvokeNbxRequest -URI $URI -Method POST -Body $URIComponents.Parameters -Raw:$Raw
    }

}
