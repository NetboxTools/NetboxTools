param(
    $PSM1 = "$PSScriptRoot\..\Source\NetboxTools.psm1"
)

BeforeAll {
    Remove-Module NetboxTools -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}


Describe "Get-NbxCredential" {

    Context "Function structure and parameters" {

        It "Should be available as a function" {
            Get-Command -Name "Get-NbxCredential" -ErrorAction SilentlyContinue | Should -Not -BeNullOrEmpty
        }

        It "Should have parameters (if any)" {
            (Get-Command "Get-NbxCredential").Parameters.Keys | Should -Not -BeNullOrEmpty -Because 'most functions have parameters or at least a parameter collection'
        }

        It "Parameter names are PascalCase" {
            (Get-Command "Get-NbxCredential").Parameters.Keys | ForEach-Object { $_ | Should -Match '^[A-Z].*' }
        }

    }

    Context "Function behavior" {

        It "Should throw when Token is not set" {
            InModuleScope NetboxTools {
                $savedConfig = $script:NbxConfig.Clone()
                $script:NbxConfig.Token = $null
                try {
                    { Get-NbxCredential } | Should -Throw '*Credentials not set*'
                }
                finally {
                    $script:NbxConfig = $savedConfig
                }
            }
        }

        It "Should return the token when it is set" {
            InModuleScope NetboxTools {
                $savedConfig = $script:NbxConfig.Clone()
                $script:NbxConfig.Token = 'test-api-token-12345'
                try {
                    Get-NbxCredential | Should -Be 'test-api-token-12345'
                }
                finally {
                    $script:NbxConfig = $savedConfig
                }
            }
        }
    }

}
