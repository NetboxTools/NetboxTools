function Get-NbxVirtualMachineInterface {
    <#
    .SYNOPSIS
        Gets virtual machine interfaces from NetBox.

    .DESCRIPTION
        Gets virtual machine interfaces from the NetBox API endpoint 'virtualization/interfaces'. Without parameters all virtual machine interfaces are returned,
        the cmdlet follows the pagination of the API.

        Virtual machine interface objects are returned as they are returned by the API, with the type name 'NetboxTools.VirtualMachineInterface',
        and can be piped to the other cmdlets of the module.

    .PARAMETER Id
        The ID of the virtual machine interface to get. Accepts virtual machine interface objects from the pipeline.

    .PARAMETER Name
        Filters virtual machine interfaces by name. Multiple values return virtual machine interfaces matching any of the values.

    .PARAMETER Query
        Filters supported by the NetBox API as a hashtable, e.g. @{ q = 'search text' }. Filters with multiple values are specified as arrays. See the API documentation of your NetBox instance for available filters.

    .PARAMETER Limit
        The maximum number of virtual machine interfaces to return. By default all matching virtual machine interfaces are returned.

    .EXAMPLE
        Get-NbxVirtualMachineInterface

        Gets all virtual machine interfaces.

    .EXAMPLE
        Get-NbxVirtualMachineInterface -Id 42

        Gets the virtual machine interface with ID 42.

    .EXAMPLE
        Get-NbxVirtualMachineInterface -Name 'example'

        Gets virtual machine interfaces where the name is 'example'.

    .EXAMPLE
        Get-NbxVirtualMachineInterface -Query @{ q = 'example' } -Limit 10

        Gets the first 10 virtual machine interfaces matching the search 'example'.

    .INPUTS
        System.UInt64, NetboxTools.VirtualMachineInterface
        You can pipe virtual machine interface IDs or virtual machine interface objects to this cmdlet.

    .OUTPUTS
        NetboxTools.VirtualMachineInterface

    .LINK
        New-NbxVirtualMachineInterface

    .LINK
        Set-NbxVirtualMachineInterface

    .LINK
        Remove-NbxVirtualMachineInterface
    #>
    [CmdletBinding(DefaultParameterSetName = 'Query')]
    [OutputType('NetboxTools.VirtualMachineInterface')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipeline)]
        [NbxIdTransformation('virtualization/interfaces')]
        [uint64[]]$Id,

        [Parameter(ParameterSetName = 'Query')]
        [string[]]$Name,

        [Parameter(ParameterSetName = 'Query')]
        [hashtable]$Query,

        # Returns all objects, which is the default. Kept for backward compatibility.
        [Parameter(ParameterSetName = 'Query', DontShow)]
        [switch]$All,

        [Parameter(ParameterSetName = 'Query')]
        [ValidateRange(1, [int]::MaxValue)]
        [int]$Limit
    )

    process {
        if ($PSCmdlet.ParameterSetName -eq 'Id') {
            foreach ($ObjectId in $Id) {
                InvokeNbxRestMethod -Endpoint "virtualization/interfaces/$ObjectId/" -TypeName 'NetboxTools.VirtualMachineInterface'
            }
            return
        }

        $Filter = @{}
        if ($Query) {
            foreach ($Key in $Query.Keys) {
                $Filter[$Key] = $Query[$Key]
            }
        }
        if ($PSBoundParameters.ContainsKey('Name')) {
            $Filter['name'] = $Name
        }

        InvokeNbxRestMethod -Endpoint 'virtualization/interfaces/' -Query $Filter -Limit $Limit -TypeName 'NetboxTools.VirtualMachineInterface'
    }
}
