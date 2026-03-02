param(
    $PSM1 = "$PSScriptRoot\..\Source\NetboxTools.psm1"
)

BeforeAll {
    Remove-Module NetboxTools -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe "Get-NbxDCIMRearPort" {

    Context "Function structure and parameters" {

        It "Should be available as a function" {
            Get-Command -Name "Get-NbxDCIMRearPort" -ErrorAction SilentlyContinue | Should -Not -BeNullOrEmpty
        }

        It "Parameter names are PascalCase" {
            (Get-Command "Get-NbxDCIMRearPort").Parameters.Keys | ForEach-Object { $_ | Should -Match '^[A-Z].*' }
        }

        It "Should have mandatory parameters" {
            (Get-Command "Get-NbxDCIMRearPort").Parameters.Keys | Should -Contain "Id"
            (Get-Command "Get-NbxDCIMRearPort").Parameters.Keys | Should -Contain "Query"
        }
    }

    Context "Function behavior" {

        BeforeAll {
            Mock -ModuleName NetboxTools -CommandName InvokeNbxRestMethod -MockWith {
                return [pscustomobject]@{ id = 1; display = 'Test' }
            }

        }

        It "Should call InvokeNbxRestMethod with Id parameter set" {
            Get-NbxDCIMRearPort -Id 42
            Should -Invoke -ModuleName NetboxTools -CommandName InvokeNbxRestMethod -Times 1 -ParameterFilter {
                $Uri -like '*/dcim/rear-ports/42/*' -and $Method -eq 'GET'
            }
        }

        It "Should call InvokeNbxRestMethod for each Id when multiple are provided" {
            Get-NbxDCIMRearPort -Id 1, 2, 3
            Should -Invoke -ModuleName NetboxTools -CommandName InvokeNbxRestMethod -Times 3
        }

        It "Should call InvokeNbxRestMethod with Query parameter set" {
            Get-NbxDCIMRearPort -Query @{ name = 'Test' }
            Should -Invoke -ModuleName NetboxTools -CommandName InvokeNbxRestMethod -Times 1 -ParameterFilter {
                $Uri -like '*/dcim/rear-ports/*' -and $Method -eq 'GET' -and $Query.name -eq 'Test'
            }
        }

        It "Should call InvokeNbxRestMethod with Default parameter set" {
            Get-NbxDCIMRearPort
            Should -Invoke -ModuleName NetboxTools -CommandName InvokeNbxRestMethod -Times 1 -ParameterFilter {
                $Uri -like '*/dcim/rear-ports/*' -and $Method -eq 'GET'
            }
        }

        AfterAll {
            InModuleScope NetboxTools {
                $script:NbxConfig.Remove('URI')
            }
        }
    }

}
