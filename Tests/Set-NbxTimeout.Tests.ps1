param(
    $PSM1 = "$PSScriptRoot\..\Source\NetboxTools.psm1"
)

BeforeAll {
    Remove-Module NetboxTools -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
    . "$PSScriptRoot\TestHelpers.ps1"
    Initialize-NbxTestConnection
}

Describe 'Set-NbxTimeout' {
    AfterEach {
        Initialize-NbxTestConnection
    }

    It 'Sets the value without output' {
        Set-NbxTimeout -TimeoutSeconds 90 | Should -BeNullOrEmpty
        InModuleScope NetboxTools { $script:NbxConfig.Timeout } | Should -Be 90
    }

    It 'Returns the value with -PassThru' {
        Set-NbxTimeout -TimeoutSeconds 90 -PassThru | Should -Be 90
    }

    It 'Does not change the value with -WhatIf' {
        $Before = InModuleScope NetboxTools { $script:NbxConfig.Timeout }
        Set-NbxTimeout -TimeoutSeconds 90 -WhatIf
        InModuleScope NetboxTools { $script:NbxConfig.Timeout } | Should -Be $Before
    }

    It 'Uses the timeout for requests' {
        Mock Invoke-RestMethod -ModuleName NetboxTools -MockWith { New-NbxTestResponse -Uri $Uri -Method $Method -Body $Body }
        Set-NbxTimeout -TimeoutSeconds 90
        Get-NbxTag
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter { $TimeoutSec -eq 90 }
    }
}
