
Describe "Get-NbxTimeout" {

    Context "Function structure and parameters" {

        It "Should be available as a function" {
            Get-Command -Name "Get-NbxTimeout" -ErrorAction SilentlyContinue | Should -Not -BeNullOrEmpty
        }

        It "Should have parameters (if any)" {
            (Get-Command "Get-NbxTimeout").Parameters.Keys | Should -Not -BeNullOrEmpty -Because 'most functions have parameters or at least a parameter collection'
        }

        It "Parameter names are PascalCase" {
            (Get-Command "Get-NbxTimeout").Parameters.Keys | ForEach-Object { $_ | Should -Match '^[A-Z].*' }
        }

    }
}
