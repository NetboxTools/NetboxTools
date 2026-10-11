param(
    $PSM1 = "$PSScriptRoot\..\Source\NetboxTools.psm1"
)

BeforeAll {
    Remove-Module NetboxTools -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
    . "$PSScriptRoot\TestHelpers.ps1"
    Initialize-NbxTestConnection
}

Describe 'Set-NbxHostname' {
    AfterEach {
        Initialize-NbxTestConnection
    }

    It 'Sets the value without output' {
        Set-NbxHostname -Hostname 'netbox2.example.com' | Should -BeNullOrEmpty
        InModuleScope NetboxTools { $script:NbxConfig.Hostname } | Should -Be 'netbox2.example.com'
    }

    It 'Returns the value with -PassThru' {
        Set-NbxHostname -Hostname 'netbox2.example.com' -PassThru | Should -Be 'netbox2.example.com'
    }

    It 'Does not change the value with -WhatIf' {
        $Before = InModuleScope NetboxTools { $script:NbxConfig.Hostname }
        Set-NbxHostname -Hostname 'netbox2.example.com' -WhatIf
        InModuleScope NetboxTools { $script:NbxConfig.Hostname } | Should -Be $Before
    }

    It 'Updates the API URI' {
        Set-NbxHostname -Hostname 'netbox2.example.com'
        InModuleScope NetboxTools { $script:NbxConfig.URI } | Should -Be 'https://netbox2.example.com/api'
    }
}
