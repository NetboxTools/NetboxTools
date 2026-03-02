param(
    $PSM1 = "$PSScriptRoot\..\Source\NetboxTools.psm1"
)

BeforeAll {
    Remove-Module NetboxTools -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe "Get-NbxVersion" {

    Context "Function structure and parameters" {

        It "Should be available as a function" {
            Get-Command -Name "Get-NbxVersion" -ErrorAction SilentlyContinue | Should -Not -BeNullOrEmpty
        }

        It "Should have parameters (if any)" {
            (Get-Command "Get-NbxVersion").Parameters.Keys | Should -Not -BeNullOrEmpty -Because 'most functions have parameters or at least a parameter collection'
        }

        It "Parameter names are PascalCase" {
            (Get-Command "Get-NbxVersion").Parameters.Keys | ForEach-Object { $_ | Should -Match '^[A-Z].*' }
        }

    }

    Context "Function behavior" {

        BeforeAll {
            Mock -ModuleName NetboxTools -CommandName InvokeNbxRestMethod -MockWith {
                return [pscustomobject]@{ 'netbox-version' = '3.5.4' }
            }

        }

        It "Should call InvokeNbxRestMethod to get version" {
            Get-NbxVersion
            Should -Invoke -ModuleName NetboxTools -CommandName InvokeNbxRestMethod -Times 1 -ParameterFilter {
                $Uri -like '*/status/*' -and $Method -eq 'GET'
            }
        }

        AfterAll {
            InModuleScope NetboxTools {
                $script:NbxConfig.Remove('URI')
            }
        }
    }

}
