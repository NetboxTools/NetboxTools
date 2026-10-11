param(
    $PSM1 = "$PSScriptRoot\..\Source\NetboxTools.psm1"
)

BeforeAll {
    Remove-Module NetboxTools -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
    . "$PSScriptRoot\TestHelpers.ps1"
    Initialize-NbxTestConnection
}

Describe 'Disconnect-NbxAPI' {
    AfterAll {
        Initialize-NbxTestConnection
    }

    It 'Removes the connection and token' {
        Disconnect-NbxAPI
        InModuleScope NetboxTools {
            $script:NbxConfig.URI | Should -BeNullOrEmpty
            $script:NbxConfig.Credential | Should -Be ([pscredential]::Empty)
        }
    }

    It 'Makes other cmdlets fail with a clear error' {
        Disconnect-NbxAPI
        { Get-NbxDCIMDevice } | Should -Throw '*Not connected*Connect-NbxAPI*'
    }
}
