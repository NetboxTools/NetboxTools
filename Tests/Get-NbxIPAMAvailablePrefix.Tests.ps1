param(
    $PSM1 = "$PSScriptRoot\..\Source\NetboxTools.psm1"
)

BeforeAll {
    Remove-Module NetboxTools -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
    . "$PSScriptRoot\TestHelpers.ps1"
    Initialize-NbxTestConnection
}

Describe 'Get-NbxIPAMAvailablePrefix' {
    BeforeEach {
        Mock Invoke-RestMethod -ModuleName NetboxTools -MockWith {
            @([pscustomobject]@{ address = '192.0.2.1/24' }, [pscustomobject]@{ address = '192.0.2.2/24' })
        }
    }

    It 'Gets the available objects of a prefix' {
        Get-NbxIPAMAvailablePrefix -Prefix 5 | Should -HaveCount 2
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Method -eq 'GET' -and $Uri -like 'https://netbox.example.com/api/ipam/prefixes/5/available-prefixes/*'
        }
    }

    It 'Accepts prefix objects from the pipeline' {
        [pscustomobject]@{ id = 5; url = 'https://netbox.example.com/api/ipam/prefixes/5/' } | Get-NbxIPAMAvailablePrefix
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Uri -like '*/ipam/prefixes/5/available-prefixes/*'
        }
    }

    It 'Accepts the Id alias and the previous Prefix_ID parameter name' {
        Get-NbxIPAMAvailablePrefix -Id 5
        Get-NbxIPAMAvailablePrefix -Prefix_ID 6
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 2 -Exactly
    }

    It 'Rejects objects that are not prefixes' {
        { [pscustomobject]@{ id = 5; url = 'https://netbox.example.com/api/ipam/ip-ranges/5/' } | Get-NbxIPAMAvailablePrefix -ErrorAction Stop } |
            Should -Throw '*not of the expected type*'
    }

    It 'Limits the number of returned objects' {
        Get-NbxIPAMAvailablePrefix -Prefix 5 -Limit 1 | Should -HaveCount 1
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter { $Uri -like '*limit=1' }
    }
}

Describe 'Get-NbxIPAMAvailablePrefix with -Query' {
    BeforeEach {
        Mock Invoke-RestMethod -ModuleName NetboxTools -MockWith { @() }
    }

    It 'Passes the query to the API' {
        Get-NbxIPAMAvailablePrefix -Prefix 5 -Query @{ vrf_id = 2 }
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Uri.AbsoluteUri -like '*/ipam/prefixes/5/available-prefixes/?vrf_id=2*'
        }
    }
}
