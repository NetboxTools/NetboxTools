function Add-NbxVirtualMachineInterface {

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [string]$Name,

        [Parameter(Mandatory = $true)]
        [uint64]$Virtual_Machine,

        [boolean]$Enabled = $true,

        [string]$MAC_Address,

        [uint16]$MTU,

        [string]$Description,

        [switch]$Raw
    )

    $Segments = [System.Collections.ArrayList]::new(@('virtualization', 'interfaces'))

    $PSBoundParameters.Enabled = $Enabled

    $URIComponents = BuildURIComponents -URISegments $Segments -ParametersDictionary $PSBoundParameters

    $uri = BuildNewURI -Segments $URIComponents.Segments

    InvokeNbxRequest -URI $uri -Method POST -Body $URIComponents.Parameters

}
