param(
    $PSM1 = "$PSScriptRoot\..\Source\NetboxTools.psm1"
)

BeforeAll {
    Remove-Module NetboxTools -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
    . "$PSScriptRoot\TestHelpers.ps1"
    Initialize-NbxTestConnection
}

Describe 'Set-NbxHostScheme' {
    AfterEach {
        Initialize-NbxTestConnection
    }

    It 'Sets the value without output' {
        Set-NbxHostScheme -Scheme 'http' | Should -BeNullOrEmpty
        InModuleScope NetboxTools { $script:NbxConfig.Scheme } | Should -Be 'http'
    }

    It 'Returns the value with -PassThru' {
        Set-NbxHostScheme -Scheme 'http' -PassThru | Should -Be 'http'
    }

    It 'Does not change the value with -WhatIf' {
        $Before = InModuleScope NetboxTools { $script:NbxConfig.Scheme }
        Set-NbxHostScheme -Scheme 'http' -WhatIf
        InModuleScope NetboxTools { $script:NbxConfig.Scheme } | Should -Be $Before
    }

    It 'Updates the API URI' {
        Set-NbxHostScheme -Scheme 'http'
        InModuleScope NetboxTools { $script:NbxConfig.URI } | Should -Be 'http://netbox.example.com/api'
    }

    It 'Warns when http is used' {
        Set-NbxHostScheme -Scheme http -WarningVariable Warnings -WarningAction SilentlyContinue
        $Warnings | Should -Not -BeNullOrEmpty
    }
}
