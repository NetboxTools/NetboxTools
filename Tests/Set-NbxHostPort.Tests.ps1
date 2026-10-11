param(
    $PSM1 = "$PSScriptRoot\..\Source\NetboxTools.psm1"
)

BeforeAll {
    Remove-Module NetboxTools -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
    . "$PSScriptRoot\TestHelpers.ps1"
    Initialize-NbxTestConnection
}

Describe 'Set-NbxHostPort' {
    AfterEach {
        Initialize-NbxTestConnection
    }

    It 'Sets the value without output' {
        Set-NbxHostPort -Port 8443 | Should -BeNullOrEmpty
        InModuleScope NetboxTools { $script:NbxConfig.Port } | Should -Be 8443
    }

    It 'Returns the value with -PassThru' {
        Set-NbxHostPort -Port 8443 -PassThru | Should -Be 8443
    }

    It 'Does not change the value with -WhatIf' {
        $Before = InModuleScope NetboxTools { $script:NbxConfig.Port }
        Set-NbxHostPort -Port 8443 -WhatIf
        InModuleScope NetboxTools { $script:NbxConfig.Port } | Should -Be $Before
    }

    It 'Updates the API URI' {
        Set-NbxHostPort -Port 8443
        InModuleScope NetboxTools { $script:NbxConfig.URI } | Should -Be 'https://netbox.example.com:8443/api'
    }
}
