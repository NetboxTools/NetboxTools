function Get-NbxVirtualMachineInterface {

    <#
    .SYNOPSIS
        Gets VM interfaces

    .DESCRIPTION
        Obtains the interface objects for one or more VMs

    .PARAMETER Limit
        Number of results to return per page.

    .PARAMETER Offset
        The initial index from which to return the results.

    .PARAMETER Id
        Database ID of the interface

    .PARAMETER Name
        Name of the interface

    .PARAMETER Enabled
        True/False if the interface is enabled

    .PARAMETER MTU
        Maximum Transmission Unit size. Generally 1500 or 9000

    .PARAMETER Virtual_Machine_Id
        ID of the virtual machine to which the interface(s) are assigned.

    .PARAMETER Virtual_Machine
        Name of the virtual machine to get interfaces

    .PARAMETER MAC_Address
        MAC address assigned to the interface

    .PARAMETER Raw
        A description of the Raw parameter.

    .EXAMPLE
        PS C:\> Get-NbxVirtualMachineInterface

    .NOTES
        Additional information about the function.
#>

    [CmdletBinding()]
    param
    (
        [Parameter(ValueFromPipeline = $true)]
        [uint64]$Id,

        [string]$Name,

        [string]$Query,

        [boolean]$Enabled,

        [uint16]$MTU,

        [uint64]$Virtual_Machine_Id,

        [string]$Virtual_Machine,

        [string]$MAC_Address,

        [uint16]$Limit,

        [uint16]$Offset,

        [switch]$Raw
    )

    process {
        $Segments = [System.Collections.ArrayList]::new(@('virtualization', 'interfaces'))

        $URIComponents = BuildURIComponents -URISegments $Segments -ParametersDictionary $PSBoundParameters

        $uri = BuildNewURI -Segments $URIComponents.Segments -Parameters $URIComponents.Parameters

        InvokeNbxRequest -URI $uri -Raw:$Raw
    }

}
