param(
    $PSM1 = "$PSScriptRoot\..\Source\NetboxTools.psm1"
)

BeforeAll {
    Remove-Module NetboxTools -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
    . "$PSScriptRoot\TestHelpers.ps1"
    Initialize-NbxTestConnection
}

Describe 'Get-NbxVirtualizationClusterGroup' {
    BeforeEach {
        Mock Invoke-RestMethod -ModuleName NetboxTools -MockWith { New-NbxTestResponse -Uri $Uri -Method $Method -Body $Body }
    }

    It 'Gets all cluster groups from the list endpoint' {
        $Result = Get-NbxVirtualizationClusterGroup
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Method -eq 'GET' -and $Uri -eq 'https://netbox.example.com/api/virtualization/cluster-groups/?limit=1000'
        }
        $Result | Should -HaveCount 1
    }

    It 'Returns objects with the type name NetboxTools.VirtualizationClusterGroup' {
        (Get-NbxVirtualizationClusterGroup).PSObject.TypeNames | Should -Contain 'NetboxTools.VirtualizationClusterGroup'
    }

    It 'Gets cluster groups by Id' {
        Get-NbxVirtualizationClusterGroup -Id 41, 42
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter { $Method -eq 'GET' -and $Uri -eq 'https://netbox.example.com/api/virtualization/cluster-groups/41/' }
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter { $Method -eq 'GET' -and $Uri -eq 'https://netbox.example.com/api/virtualization/cluster-groups/42/' }
    }

    It 'Accepts IDs and cluster group objects from the pipeline' {
        41, [pscustomobject]@{ id = 42; url = 'https://netbox.example.com/api/virtualization/cluster-groups/42/' } | Get-NbxVirtualizationClusterGroup
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 2 -Exactly
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter { $Uri -eq 'https://netbox.example.com/api/virtualization/cluster-groups/42/' }
    }

    It 'Rejects objects of another type' {
        { [pscustomobject]@{ id = 42; url = 'https://netbox.example.com/api/dcim/sites/42/' } | Get-NbxVirtualizationClusterGroup -ErrorAction Stop } | Should -Throw '*not of the expected type*'
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 0 -Exactly
    }

    It 'Passes the query to the API' {
        Get-NbxVirtualizationClusterGroup -Query @{ q = 'test value'; tag = 'a', 'b' }
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Uri.AbsoluteUri -like '*q=test%20value*' -and $Uri.AbsoluteUri -like '*tag=a&tag=b*'
        }
    }

    It 'Limits the number of returned objects' {
        Get-NbxVirtualizationClusterGroup -Limit 5
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter { $Uri -eq 'https://netbox.example.com/api/virtualization/cluster-groups/?limit=5' }
    }

        It 'Filters by Name' {
            Get-NbxVirtualizationClusterGroup -Name 'a', 'b'
            Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
                $Uri -like '*/api/virtualization/cluster-groups/?*' -and $Uri -like '*name=a&name=b*'
            }
        }
}
