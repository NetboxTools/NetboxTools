param(
    $PSM1 = "$PSScriptRoot\..\Source\NetboxTools.psm1"
)

BeforeAll {
    Remove-Module NetboxTools -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
    . "$PSScriptRoot\TestHelpers.ps1"
    Initialize-NbxTestConnection
}

Describe 'Get-NbxVirtualMachineInterface' {
    BeforeEach {
        Mock Invoke-RestMethod -ModuleName NetboxTools -MockWith { New-NbxTestResponse -Uri $Uri -Method $Method -Body $Body }
    }

    It 'Gets all virtual machine interfaces from the list endpoint' {
        $Result = Get-NbxVirtualMachineInterface
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Method -eq 'GET' -and $Uri -eq 'https://netbox.example.com/api/virtualization/interfaces/?limit=1000'
        }
        $Result | Should -HaveCount 1
    }

    It 'Returns objects with the type name NetboxTools.VirtualMachineInterface' {
        (Get-NbxVirtualMachineInterface).PSObject.TypeNames | Should -Contain 'NetboxTools.VirtualMachineInterface'
    }

    It 'Gets virtual machine interfaces by Id' {
        Get-NbxVirtualMachineInterface -Id 41, 42
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter { $Method -eq 'GET' -and $Uri -eq 'https://netbox.example.com/api/virtualization/interfaces/41/' }
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter { $Method -eq 'GET' -and $Uri -eq 'https://netbox.example.com/api/virtualization/interfaces/42/' }
    }

    It 'Accepts IDs and virtual machine interface objects from the pipeline' {
        41, [pscustomobject]@{ id = 42; url = 'https://netbox.example.com/api/virtualization/interfaces/42/' } | Get-NbxVirtualMachineInterface
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 2 -Exactly
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter { $Uri -eq 'https://netbox.example.com/api/virtualization/interfaces/42/' }
    }

    It 'Rejects objects of another type' {
        { [pscustomobject]@{ id = 42; url = 'https://netbox.example.com/api/dcim/sites/42/' } | Get-NbxVirtualMachineInterface -ErrorAction Stop } | Should -Throw '*not of the expected type*'
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 0 -Exactly
    }

    It 'Passes the query to the API' {
        Get-NbxVirtualMachineInterface -Query @{ q = 'test value'; tag = 'a', 'b' }
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Uri.AbsoluteUri -like '*q=test%20value*' -and $Uri.AbsoluteUri -like '*tag=a&tag=b*'
        }
    }

    It 'Limits the number of returned objects' {
        Get-NbxVirtualMachineInterface -Limit 5
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter { $Uri -eq 'https://netbox.example.com/api/virtualization/interfaces/?limit=5' }
    }

        It 'Filters by Name' {
            Get-NbxVirtualMachineInterface -Name 'a', 'b'
            Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
                $Uri -like '*/api/virtualization/interfaces/?*' -and $Uri -like '*name=a&name=b*'
            }
        }
}
