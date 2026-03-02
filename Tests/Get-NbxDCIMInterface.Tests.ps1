param(
    $PSM1 = "$PSScriptRoot\..\Source\NetboxTools.psm1"
)

BeforeAll {
    Remove-Module NetboxTools -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe "Get-NbxDCIMInterface" {

    Context "Function structure and parameters" {

        It "Should be available as a function" {
            Get-Command -Name "Get-NbxDCIMInterface" -ErrorAction SilentlyContinue | Should -Not -BeNullOrEmpty
        }

        It "Parameter names are PascalCase" {
            (Get-Command "Get-NbxDCIMInterface").Parameters.Keys | ForEach-Object { $_ | Should -Match '^[A-Z].*' }
        }

        It "Should have mandatory parameters" {
            (Get-Command "Get-NbxDCIMInterface").Parameters.Keys | Should -Contain "Id"
            (Get-Command "Get-NbxDCIMInterface").Parameters.Keys | Should -Contain "Query"
        }
    }

    Context "Function behavior" {

        BeforeAll {
            Mock -ModuleName NetboxTools -CommandName InvokeNbxRestMethod -MockWith {
                return [pscustomobject]@{ id = 1; display = 'Test' }
            }

        }

        It "Should call InvokeNbxRestMethod with Id parameter set" {
            Get-NbxDCIMInterface -Id 42
            Should -Invoke -ModuleName NetboxTools -CommandName InvokeNbxRestMethod -Times 1 -ParameterFilter {
                $Uri -like '*/dcim/interfaces/42/*' -and $Method -eq 'GET'
            }
        }

        It "Should call InvokeNbxRestMethod for each Id when multiple are provided" {
            Get-NbxDCIMInterface -Id 1, 2, 3
            Should -Invoke -ModuleName NetboxTools -CommandName InvokeNbxRestMethod -Times 3
        }

        It "Should call InvokeNbxRestMethod with Query parameter set" {
            Get-NbxDCIMInterface -Query @{ name = 'Test' }
            Should -Invoke -ModuleName NetboxTools -CommandName InvokeNbxRestMethod -Times 1 -ParameterFilter {
                $Uri -like '*/dcim/interfaces/*' -and $Method -eq 'GET' -and $Query.name -eq 'Test'
            }
        }

        It "Should call InvokeNbxRestMethod with Default parameter set" {
            Get-NbxDCIMInterface
            Should -Invoke -ModuleName NetboxTools -CommandName InvokeNbxRestMethod -Times 1 -ParameterFilter {
                $Uri -like '*/dcim/interfaces/*' -and $Method -eq 'GET'
            }
        }

        AfterAll {
            InModuleScope NetboxTools {
                $script:NbxConfig.Remove('URI')
            }
        }
    }

}
