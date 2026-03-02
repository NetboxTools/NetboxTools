param(
    $PSM1 = "$PSScriptRoot\..\Source\NetboxTools.psm1"
)

BeforeAll {
    Remove-Module NetboxTools -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

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

    Context "Function behavior" {

        It "Should return default 30 when Timeout is not set" {
            InModuleScope NetboxTools {
                $savedConfig = $script:NbxConfig.Clone()
                $script:NbxConfig.Timeout = $null
                try {
                    Get-NbxTimeout -WarningAction SilentlyContinue | Should -Be 30
                }
                finally {
                    $script:NbxConfig = $savedConfig
                }
            }
        }

        It "Should return the configured timeout when set" {
            InModuleScope NetboxTools {
                $savedConfig = $script:NbxConfig.Clone()
                $script:NbxConfig.Timeout = 60
                try {
                    Get-NbxTimeout | Should -Be 60
                }
                finally {
                    $script:NbxConfig = $savedConfig
                }
            }
        }
    }
}
