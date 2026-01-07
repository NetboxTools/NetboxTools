param(
    $PSM1 = "$PSScriptRoot\..\Source\NetboxTools.psm1"
)

BeforeAll {
    Remove-Module NetboxTools -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe "Add-NbxDCIMInterfaceConnection" {

    Context "Function structure and parameters" {

        It "Should be available as a function" {
            Get-Command -Name "Add-NbxDCIMInterfaceConnection" -ErrorAction SilentlyContinue | Should -Not -BeNullOrEmpty
        }

        It "Parameter names are PascalCase" {
            (Get-Command "Add-NbxDCIMInterfaceConnection").Parameters.Keys | ForEach-Object { $_ | Should -Match '^[A-Z].*' }
        }

        It "Should have mandatory parameters" {
            (Get-Command "Add-NbxDCIMInterfaceConnection").Parameters.Keys | Should -Contain "Interface_A"
            (Get-Command "Add-NbxDCIMInterfaceConnection").Parameters.Keys | Should -Contain "Interface_B"
        }
    }

}
