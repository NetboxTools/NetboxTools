param(
    $PSM1 = "$PSScriptRoot\..\Source\NetboxTools.psm1"
)

BeforeAll {
    Remove-Module NetboxTools -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
    . "$PSScriptRoot\TestHelpers.ps1"
    Initialize-NbxTestConnection
}

Describe 'Set-NbxUntrustedSSL' {
    AfterEach {
        Initialize-NbxTestConnection
    }

    It 'Enables SkipCertificateCheck and warns that it is deprecated' {
        Set-NbxUntrustedSSL -WarningVariable Warnings -WarningAction SilentlyContinue
        $Warnings | Should -BeLike '*deprecated*'
        InModuleScope NetboxTools { $script:NbxConfig.InvokeParams.SkipCertificateCheck } | Should -BeTrue
    }

    It 'Does not change the configuration with -WhatIf' {
        Set-NbxUntrustedSSL -WhatIf -WarningAction SilentlyContinue
        InModuleScope NetboxTools { $script:NbxConfig.InvokeParams.SkipCertificateCheck } | Should -BeFalse
    }
}
