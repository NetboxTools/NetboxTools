function Get-NbxVirtualMachine {
    <#
    .SYNOPSIS
        Gets virtual machines from NetBox.

    .DESCRIPTION
        Gets virtual machines from the NetBox API endpoint 'virtualization/virtual-machines'. Without parameters all virtual machines are returned,
        the cmdlet follows the pagination of the API.

        Virtual machine objects are returned as they are returned by the API, with the type name 'NetboxTools.VirtualMachine',
        and can be piped to the other cmdlets of the module.

    .PARAMETER Id
        The ID of the virtual machine to get. Accepts virtual machine objects from the pipeline.

    .PARAMETER Name
        Filters virtual machines by name. Multiple values return virtual machines matching any of the values.

    .PARAMETER Query
        Filters supported by the NetBox API as a hashtable, e.g. @{ q = 'search text' }. Filters with multiple values are specified as arrays. See the API documentation of your NetBox instance for available filters.

    .PARAMETER Limit
        The maximum number of virtual machines to return. By default all matching virtual machines are returned.

    .EXAMPLE
        Get-NbxVirtualMachine

        Gets all virtual machines.

    .EXAMPLE
        Get-NbxVirtualMachine -Id 42

        Gets the virtual machine with ID 42.

    .EXAMPLE
        Get-NbxVirtualMachine -Name 'example'

        Gets virtual machines where the name is 'example'.

    .EXAMPLE
        Get-NbxVirtualMachine -Query @{ q = 'example' } -Limit 10

        Gets the first 10 virtual machines matching the search 'example'.

    .INPUTS
        System.UInt64, NetboxTools.VirtualMachine
        You can pipe virtual machine IDs or virtual machine objects to this cmdlet.

    .OUTPUTS
        NetboxTools.VirtualMachine

    .LINK
        New-NbxVirtualMachine

    .LINK
        Set-NbxVirtualMachine

    .LINK
        Remove-NbxVirtualMachine
    #>
    [CmdletBinding(DefaultParameterSetName = 'Query')]
    [OutputType('NetboxTools.VirtualMachine')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipeline)]
        [NbxIdTransformation('virtualization/virtual-machines')]
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
                InvokeNbxRestMethod -Endpoint "virtualization/virtual-machines/$ObjectId/" -TypeName 'NetboxTools.VirtualMachine'
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

        InvokeNbxRestMethod -Endpoint 'virtualization/virtual-machines/' -Query $Filter -Limit $Limit -TypeName 'NetboxTools.VirtualMachine'
    }
}
