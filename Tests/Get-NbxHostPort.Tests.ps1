param(
    $PSM1 = "$PSScriptRoot\..\Source\NetboxTools.psm1"
)

BeforeAll {
    Remove-Module NetboxTools -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
    . "$PSScriptRoot\TestHelpers.ps1"
    Initialize-NbxTestConnection
}

Describe 'Get-NbxHostPort' {
    AfterEach {
        Initialize-NbxTestConnection
    }

    It 'Returns the configured value' {
        Set-NbxHostPort -Port 8443
        Get-NbxHostPort | Should -Be 8443
    }
}
