param(
    $PSM1 = "$PSScriptRoot\..\Source\NetboxTools.psm1"
)

BeforeAll {
    Remove-Module NetboxTools -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe "Set-NbxIPAMPrefix" {

    Context "Function structure and parameters" {

        It "Should be available as a function" {
            Get-Command -Name "Set-NbxIPAMPrefix" -ErrorAction SilentlyContinue | Should -Not -BeNullOrEmpty
        }

        It "Parameter names are PascalCase" {
            (Get-Command "Set-NbxIPAMPrefix").Parameters.Keys | ForEach-Object { $_ | Should -Match '^[A-Z].*' }
        }

        It "Mandatory parameters are present in parameter list" {

            (Get-Command "Set-NbxIPAMPrefix").Parameters.Keys | Should -Contain "Id"
        }
    }

}
