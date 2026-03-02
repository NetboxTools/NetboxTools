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

    Context "Function behavior" {

        BeforeAll {
            Mock -ModuleName NetboxTools -CommandName InvokeNbxRestMethod -MockWith {
                return [pscustomobject]@{ id = 1 }
            }
            Mock -ModuleName NetboxTools -CommandName Get-NbxDCIMInterface -MockWith {
                return [pscustomobject]@{ id = 1; name = 'eth0' }
            }

        }

        It "Should call InvokeNbxRestMethod with POST method" {
            Add-NbxDCIMInterfaceConnection -Interface_A 1 -Interface_B 2
            Should -Invoke -ModuleName NetboxTools -CommandName InvokeNbxRestMethod -Times 1 -ParameterFilter {
                $Method -eq 'POST'
            }
        }

        It "Should verify both interfaces exist" {
            Add-NbxDCIMInterfaceConnection -Interface_A 1 -Interface_B 2
            Should -Invoke -ModuleName NetboxTools -CommandName Get-NbxDCIMInterface -Times 2
        }

        AfterAll {
            InModuleScope NetboxTools {
                $script:NbxConfig.Remove('URI')
            }
        }
    }

}
