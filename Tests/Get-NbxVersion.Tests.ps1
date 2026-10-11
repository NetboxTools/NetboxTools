param(
    $PSM1 = "$PSScriptRoot\..\Source\NetboxTools.psm1"
)

BeforeAll {
    Remove-Module NetboxTools -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
    . "$PSScriptRoot\TestHelpers.ps1"
    Initialize-NbxTestConnection
}

Describe 'Get-NbxVersion' {
    BeforeEach {
        Mock Invoke-RestMethod -ModuleName NetboxTools -MockWith { [pscustomobject]@{ 'netbox-version' = '4.7.2' } }
    }

    It 'Gets the status from the status endpoint' {
        $Result = Get-NbxVersion
        $Result.'netbox-version' | Should -Be '4.7.2'
        $Result.PSObject.TypeNames | Should -Contain 'NetboxTools.Status'
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Method -eq 'GET' -and $Uri -like 'https://netbox.example.com/api/status/*'
        }
    }
}
