param(
    $PSM1 = "$PSScriptRoot\..\Source\NetboxTools.psm1"
)

BeforeAll {
    Remove-Module NetboxTools -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
    . "$PSScriptRoot\TestHelpers.ps1"
    Initialize-NbxTestConnection
}

Describe 'Get-NbxTimeout' {
    AfterEach {
        Initialize-NbxTestConnection
    }

    It 'Returns the configured value' {
        Set-NbxTimeout -TimeoutSeconds 90
        Get-NbxTimeout | Should -Be 90
    }
}
