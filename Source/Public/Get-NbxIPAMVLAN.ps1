function Get-NbxIPAMVLAN {
    <#
    .SYNOPSIS
        Gets VLANs from NetBox.

    .DESCRIPTION
        Gets VLANs from the NetBox API endpoint 'ipam/vlans'. Without parameters all VLANs are returned,
        the cmdlet follows the pagination of the API.

        VLAN objects are returned as they are returned by the API, with the type name 'NetboxTools.IPAMVLAN',
        and can be piped to the other cmdlets of the module.

    .PARAMETER Id
        The ID of the VLAN to get. Accepts VLAN objects from the pipeline.

    .PARAMETER Name
        Filters VLANs by name. Multiple values return VLANs matching any of the values.

    .PARAMETER Query
        Filters supported by the NetBox API as a hashtable, e.g. @{ q = 'search text' }. Filters with multiple values are specified as arrays. See the API documentation of your NetBox instance for available filters.

    .PARAMETER Limit
        The maximum number of VLANs to return. By default all matching VLANs are returned.

    .EXAMPLE
        Get-NbxIPAMVLAN

        Gets all VLANs.

    .EXAMPLE
        Get-NbxIPAMVLAN -Id 42

        Gets the VLAN with ID 42.

    .EXAMPLE
        Get-NbxIPAMVLAN -Name 'example'

        Gets VLANs where the name is 'example'.

    .EXAMPLE
        Get-NbxIPAMVLAN -Query @{ q = 'example' } -Limit 10

        Gets the first 10 VLANs matching the search 'example'.

    .INPUTS
        System.UInt64, NetboxTools.IPAMVLAN
        You can pipe VLAN IDs or VLAN objects to this cmdlet.

    .OUTPUTS
        NetboxTools.IPAMVLAN

    .LINK
        New-NbxIPAMVLAN

    .LINK
        Set-NbxIPAMVLAN

    .LINK
        Remove-NbxIPAMVLAN
    #>
    [CmdletBinding(DefaultParameterSetName = 'Query')]
    [OutputType('NetboxTools.IPAMVLAN')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipeline)]
        [NbxIdTransformation('ipam/vlans')]
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
                InvokeNbxRestMethod -Endpoint "ipam/vlans/$ObjectId/" -TypeName 'NetboxTools.IPAMVLAN'
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

        InvokeNbxRestMethod -Endpoint 'ipam/vlans/' -Query $Filter -Limit $Limit -TypeName 'NetboxTools.IPAMVLAN'
    }
}
