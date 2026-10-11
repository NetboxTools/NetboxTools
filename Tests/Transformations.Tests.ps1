param(
    $PSM1 = "$PSScriptRoot\..\Source\NetboxTools.psm1"
)

BeforeAll {
    Remove-Module NetboxTools -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe 'NbxIdTransformation' {
    BeforeAll {
        $Transformation = InModuleScope NetboxTools { [NbxIdTransformation]::new('dcim/devices') }
        $Multiple = InModuleScope NetboxTools { [NbxIdTransformation]::new('dcim/interfaces', 'virtualization/interfaces') }
    }

    It 'Passes IDs through' {
        $Transformation.Transform($null, 5) | Should -Be 5
        $Transformation.Transform($null, '5') | Should -Be '5'
    }

    It 'Converts objects of the expected type to their ID' {
        $Transformation.Transform($null, [pscustomobject]@{ id = 7; url = 'https://nb/api/dcim/devices/7/' }) | Should -Be 7
    }

    It 'Converts hashtables and objects without url to their ID' {
        $Transformation.Transform($null, @{ id = 8 }) | Should -Be 8
        $Transformation.Transform($null, [pscustomobject]@{ id = 9; name = 'Device' }) | Should -Be 9
    }

    It 'Converts arrays' {
        $Result = $Transformation.Transform($null, @(1, [pscustomobject]@{ id = 2; url = 'https://nb/api/dcim/devices/2/' }))
        $Result | Should -Be 1, 2
        , $Result | Should -BeOfType [array]
    }

    It 'Rejects objects of another type' {
        { $Transformation.Transform($null, [pscustomobject]@{ id = 7; url = 'https://nb/api/dcim/interfaces/7/' }) } |
            Should -Throw '*not of the expected type*dcim/devices*'
    }

    It 'Accepts any of multiple endpoints' {
        $Multiple.Transform($null, [pscustomobject]@{ id = 1; url = 'https://nb/api/virtualization/interfaces/1/' }) | Should -Be 1
    }

    It 'Rejects objects without id' {
        { $Transformation.Transform($null, [pscustomobject]@{ name = 'Device' }) } | Should -Throw "*'id' property*"
    }

    It 'Passes $null through' {
        $Transformation.Transform($null, $null) | Should -BeNullOrEmpty
    }
}

Describe 'NbxChoiceTransformation' {
    BeforeAll {
        $Transformation = InModuleScope NetboxTools { [NbxChoiceTransformation]::new() }
    }

    It 'Converts NetBox choice objects to their value' {
        $Transformation.Transform($null, [pscustomobject]@{ value = 'active'; label = 'Active' }) | Should -Be 'active'
        $Transformation.Transform($null, @{ value = 'planned'; label = 'Planned' }) | Should -Be 'planned'
    }

    It 'Passes strings through' {
        $Transformation.Transform($null, 'active') | Should -Be 'active'
    }
}

Describe 'NbxDictionaryTransformation' {
    BeforeAll {
        $Transformation = InModuleScope NetboxTools { [NbxDictionaryTransformation]::new() }
    }

    It 'Converts objects to hashtables' {
        $Result = $Transformation.Transform($null, [pscustomobject]@{ owner = 'IT'; cost = 5 })
        $Result | Should -BeOfType [hashtable]
        $Result.owner | Should -Be 'IT'
        $Result.cost | Should -Be 5
    }

    It 'Passes hashtables through' {
        $Hashtable = @{ a = 1 }
        $Transformation.Transform($null, $Hashtable) | Should -Be $Hashtable
    }
}

Describe 'ConvertToNbxObjectReference' {
    It 'Derives the object type of <Url>' -TestCases @(
        @{ Url = 'https://nb/api/dcim/interfaces/1/'; Type = 'dcim.interface' }
        @{ Url = 'https://nb/api/dcim/front-ports/1/'; Type = 'dcim.frontport' }
        @{ Url = 'https://nb/api/dcim/rear-ports/1/'; Type = 'dcim.rearport' }
        @{ Url = 'https://nb/api/dcim/sites/1/'; Type = 'dcim.site' }
        @{ Url = 'https://nb/api/dcim/site-groups/1/'; Type = 'dcim.sitegroup' }
        @{ Url = 'https://nb/api/dcim/device-roles/1/'; Type = 'dcim.devicerole' }
        @{ Url = 'https://nb/api/dcim/virtual-chassis/1/'; Type = 'dcim.virtualchassis' }
        @{ Url = 'https://nb/api/circuits/circuit-terminations/1/'; Type = 'circuits.circuittermination' }
        @{ Url = 'https://nb/api/virtualization/interfaces/1/'; Type = 'virtualization.vminterface' }
        @{ Url = 'https://nb/api/virtualization/virtual-machines/1/'; Type = 'virtualization.virtualmachine' }
        @{ Url = 'https://nb/api/ipam/prefixes/1/'; Type = 'ipam.prefix' }
        @{ Url = 'https://nb/api/ipam/ip-addresses/1/'; Type = 'ipam.ipaddress' }
        @{ Url = 'https://nb/api/ipam/fhrp-groups/1/'; Type = 'ipam.fhrpgroup' }
        @{ Url = 'https://nb/api/tenancy/tenants/1/'; Type = 'tenancy.tenant' }
        @{ Url = 'https://nb/api/dcim/power-feeds/1/'; Type = 'dcim.powerfeed' }
    ) {
        param ($Url, $Type)
        InModuleScope NetboxTools -Parameters @{ Url = $Url; Type = $Type } {
            param ($Url, $Type)
            $Reference = ConvertToNbxObjectReference -InputObject ([pscustomobject]@{ id = 1; url = $Url })
            $Reference.object_type | Should -Be $Type
            $Reference.object_id | Should -Be 1
        }
    }

    It 'Accepts generic references returned by NetBox' {
        InModuleScope NetboxTools {
            $Reference = ConvertToNbxObjectReference -InputObject ([pscustomobject]@{ object_type = 'dcim.interface'; object_id = 5; object = $null })
            $Reference.object_type | Should -Be 'dcim.interface'
            $Reference.object_id | Should -Be 5
        }
    }

    It 'Uses the default type for IDs' {
        InModuleScope NetboxTools {
            $References = @(ConvertToNbxObjectReference -InputObject 1, 2 -DefaultType 'dcim.rearport')
            $References | Should -HaveCount 2
            $References[1].object_type | Should -Be 'dcim.rearport'
            $References[1].object_id | Should -Be 2
        }
    }

    It 'Throws for IDs without a default type' {
        InModuleScope NetboxTools {
            { ConvertToNbxObjectReference -InputObject 1 } | Should -Throw '*object type is required*'
        }
    }

    It 'Throws for objects that are not NetBox objects' {
        InModuleScope NetboxTools {
            { ConvertToNbxObjectReference -InputObject ([pscustomobject]@{ name = 'x' }) } | Should -Throw '*not a NetBox object*'
        }
    }
}

Describe 'NbxBoolTransformation' {
    BeforeAll {
        $Transformation = InModuleScope NetboxTools { [NbxBoolTransformation]::new() }
    }

    It 'Converts <Text> to <Expected>' -TestCases @(
        @{ Text = 'true'; Expected = $true }
        @{ Text = 'True'; Expected = $true }
        @{ Text = 'yes'; Expected = $true }
        @{ Text = '1'; Expected = $true }
        @{ Text = 'false'; Expected = $false }
        @{ Text = 'no'; Expected = $false }
        @{ Text = '0'; Expected = $false }
        @{ Text = ''; Expected = $false }
    ) {
        param ($Text, $Expected)
        $Transformation.Transform($null, $Text) | Should -Be $Expected
    }

    It 'Passes booleans through' {
        $Transformation.Transform($null, $true) | Should -BeTrue
    }

    It 'Rejects other text' {
        { $Transformation.Transform($null, 'maybe') } | Should -Throw '*not a boolean*'
    }
}

Describe 'ConvertToNbxObjectReference with digits in the endpoint' {
    It 'Derives the object type of L2VPN objects' {
        InModuleScope NetboxTools {
            (ConvertToNbxObjectReference -InputObject ([pscustomobject]@{ id = 1; url = 'https://nb/api/vpn/l2vpns/1/' })).object_type |
                Should -Be 'vpn.l2vpn'
        }
    }
}
