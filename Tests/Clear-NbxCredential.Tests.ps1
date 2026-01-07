
Describe "Clear-NbxCredential" {

    Context "Function structure and parameters" {

        It "Should be available as a function" {
            Get-Command -Name "Clear-NbxCredential" -ErrorAction SilentlyContinue | Should -Not -BeNullOrEmpty
        }

        It "Should have parameters (if any)" {
            (Get-Command "Clear-NbxCredential").Parameters.Keys | Should -Not -BeNullOrEmpty -Because 'most functions have parameters or at least a parameter collection'
        }

        It "Parameter names are PascalCase" {
            (Get-Command "Clear-NbxCredential").Parameters.Keys | ForEach-Object { $_ | Should -Match '^[A-Z].*' }
        }
        
    }

}
