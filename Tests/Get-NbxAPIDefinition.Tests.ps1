param(
    $PSM1 = "$PSScriptRoot\..\Source\NetboxTools.psm1"
)

BeforeAll {
    Remove-Module NetboxTools -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
    . "$PSScriptRoot\TestHelpers.ps1"
    Initialize-NbxTestConnection
}

Describe 'Get-NbxAPIDefinition' {
    BeforeEach {
        Mock Invoke-RestMethod -ModuleName NetboxTools -MockWith { New-NbxTestResponse -Uri $Uri -Method $Method -Body $Body }
    }

    It 'Gets the JSON schema by default' {
        Get-NbxAPIDefinition
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Uri -like 'https://netbox.example.com/api/schema/?format=json&lang=en*'
        }
    }

    It 'Gets the YAML schema' {
        Get-NbxAPIDefinition -Format yaml -Language sv
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Uri -like '*format=yaml&lang=sv*'
        }
    }
}
