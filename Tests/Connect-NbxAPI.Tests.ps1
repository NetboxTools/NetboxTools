param(
    $PSM1 = "$PSScriptRoot\..\Source\NetboxTools.psm1"
)

BeforeAll {
    Remove-Module NetboxTools -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe "Connect-NbxAPI" {

    Context "Function structure and parameters" {

        It "Should be available as a function" {
            Get-Command -Name "Connect-NbxAPI" -ErrorAction SilentlyContinue | Should -Not -BeNullOrEmpty
        }

        It "Should have parameters (if any)" {
            (Get-Command "Connect-NbxAPI").Parameters.Keys | Should -Not -BeNullOrEmpty -Because 'most functions have parameters or at least a parameter collection'
        }

        It "Parameter names are PascalCase" {
            (Get-Command "Connect-NbxAPI").Parameters.Keys | ForEach-Object { $_ | Should -Match '^[A-Z].*' }
        }

        It "Should have required parameters" {
            (Get-Command "Connect-NbxAPI").Parameters.Keys | Should -Contain "Hostname"
        }
    }

}
