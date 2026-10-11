param(
    $PSM1 = "$PSScriptRoot\..\Source\NetboxTools.psm1"
)

BeforeAll {
    Remove-Module NetboxTools -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
    . "$PSScriptRoot\TestHelpers.ps1"
    Initialize-NbxTestConnection
}

Describe 'Get-NbxHostname' {
    AfterEach {
        Initialize-NbxTestConnection
    }

    It 'Returns the configured value' {
        Set-NbxHostname -Hostname 'netbox2.example.com'
        Get-NbxHostname | Should -Be 'netbox2.example.com'
    }
}

Describe 'Get-NbxHostname when not connected' {
    AfterAll {
        Initialize-NbxTestConnection
    }

    It 'Throws when not connected' {
        Disconnect-NbxAPI
        { Get-NbxHostname } | Should -Throw '*Connect-NbxAPI*'
    }
}
