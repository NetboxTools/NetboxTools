param(
    $PSM1 = "$PSScriptRoot\..\Source\NetboxTools.psm1"
)

BeforeAll {
    Remove-Module NetboxTools -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
    . "$PSScriptRoot\TestHelpers.ps1"
    Initialize-NbxTestConnection
}

Describe 'Set-NbxCipherSSL' {
    It 'Warns that it is deprecated and does not change the configuration' {
        $Before = InModuleScope NetboxTools { $script:NbxConfig | ConvertTo-Json -Depth 3 }
        Set-NbxCipherSSL -WarningVariable Warnings -WarningAction SilentlyContinue
        $Warnings | Should -BeLike '*deprecated*'
        InModuleScope NetboxTools { $script:NbxConfig | ConvertTo-Json -Depth 3 } | Should -Be $Before
    }
}
