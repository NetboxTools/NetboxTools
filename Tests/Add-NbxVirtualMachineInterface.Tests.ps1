
Describe "Add-NbxVirtualMachineInterface" {

    Context "Function structure and parameters" {

        It "Should be available as a function" {
            Get-Command -Name "Add-NbxVirtualMachineInterface" -ErrorAction SilentlyContinue | Should -Not -BeNullOrEmpty
        }

        It "Should have parameters (if any)" {
            (Get-Command "Add-NbxVirtualMachineInterface").Parameters.Keys | Should -Not -BeNullOrEmpty -Because 'most functions have parameters or at least a parameter collection'
        }

        It "Parameter names are PascalCase" {
            (Get-Command "Add-NbxVirtualMachineInterface").Parameters.Keys | ForEach-Object { $_ | Should -Match '^[A-Z].*' }
        }

        It "Should have required parameters" {
            (Get-Command "Add-NbxVirtualMachineInterface").Parameters.Keys | Should -Contain "Name"
            (Get-Command "Add-NbxVirtualMachineInterface").Parameters.Keys | Should -Contain "Virtual_Machine"
        }
    }

}
