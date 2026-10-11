function ConvertToNbxObjectReference {
    <#
        Converts objects into NetBox generic object references: @{ object_type = 'dcim.interface'; object_id = 1 }

        Accepts:
        - NetBox objects with an 'url', the object type is derived from the API endpoint.
        - Generic references with 'object_type' and 'object_id', such as cable terminations returned by NetBox.
        - IDs, which use DefaultType as object type.
    #>
    [CmdletBinding()]
    [OutputType([hashtable])]
    param (
        [Parameter(Mandatory)]
        [AllowNull()]
        [object]$InputObject,

        [Parameter()]
        [string]$DefaultType
    )

    # API endpoints that do not follow the '<app>/<model>s' naming
    $EndpointTypes = @{
        'virtualization/interfaces' = 'virtualization.vminterface'
        'dcim/virtual-chassis'      = 'dcim.virtualchassis'
        'ipam/ip-addresses'         = 'ipam.ipaddress'
        'ipam/vlans'                = 'ipam.vlan'
        'ipam/vrfs'                 = 'ipam.vrf'
    }

    foreach ($Item in @($InputObject)) {
        if ($null -eq $Item) {
            continue
        }
        if ($Item -is [psobject] -and $Item.PSObject.BaseObject -isnot [System.Management.Automation.PSCustomObject]) {
            $Item = $Item.PSObject.BaseObject
        }
        if ($Item -is [System.Collections.IDictionary]) {
            $Item = [pscustomobject]$Item
        }

        if ($Item -is [string] -or $Item -is [ValueType]) {
            if ([string]::IsNullOrEmpty($DefaultType)) {
                throw [System.ArgumentException]::new("An object type is required for the ID '$Item'. Pass a NetBox object instead of an ID.")
            }
            @{ object_type = $DefaultType; object_id = [uint64]$Item }
            continue
        }

        $Properties = $Item.PSObject.Properties.Name
        if ($Properties -contains 'object_type' -and $Properties -contains 'object_id') {
            @{ object_type = [string]$Item.object_type; object_id = [uint64]$Item.object_id }
            continue
        }

        if ($Properties -contains 'url' -and $Properties -contains 'id' -and $Item.url -match '/api/(?<app>[a-z0-9-]+)/(?<model>[a-z0-9-]+)/\d+/?$') {
            $App = $Matches.app -replace '-', ''
            $Model = $Matches.model -replace '-', ''
            $Endpoint = '{0}/{1}' -f $Matches.app, $Matches.model
            $ObjectType = $EndpointTypes[$Endpoint]
            if (-not $ObjectType) {
                $Model = switch -Regex ($Model) {
                    '(ss|x)es$' { $Model -replace 'es$', ''; break }
                    'ies$' { $Model -replace 'ies$', 'y'; break }
                    '[^s]s$' { $Model -replace 's$', ''; break }
                    default { $Model }
                }
                $ObjectType = '{0}.{1}' -f $App, $Model
            }
            @{ object_type = $ObjectType; object_id = [uint64]$Item.id }
            continue
        }

        throw [System.ArgumentException]::new('The input object is not a NetBox object. Pass an object returned by a Get cmdlet, or an ID.')
    }
}
