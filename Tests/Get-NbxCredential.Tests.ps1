param(
    $PSM1 = "$PSScriptRoot\..\Source\NetboxTools.psm1"
)

BeforeAll {
    Remove-Module NetboxTools -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
    . "$PSScriptRoot\TestHelpers.ps1"
    Initialize-NbxTestConnection
}

Describe 'Get-NbxCredential' {
    AfterAll {
        Initialize-NbxTestConnection
    }

    It 'Returns the credential with the API token' {
        (Get-NbxCredential).GetNetworkCredential().Password | Should -Be '0123456789abcdef'
    }

    It 'Throws when no token is configured' {
        Disconnect-NbxAPI
        { Get-NbxCredential } | Should -Throw '*No NetBox API token*'
    }
}
