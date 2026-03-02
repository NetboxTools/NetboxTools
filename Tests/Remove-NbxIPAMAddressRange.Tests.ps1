param(
    $PSM1 = "$PSScriptRoot\..\Source\NetboxTools.psm1"
)

BeforeAll {
    Remove-Module NetboxTools -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe "Remove-NbxIPAMAddressRange" {

    Context "Function structure and parameters" {

        It "Should be available as a function" {
            Get-Command -Name "Remove-NbxIPAMAddressRange" -ErrorAction SilentlyContinue | Should -Not -BeNullOrEmpty
        }

        It "Parameter names are PascalCase" {
            (Get-Command "Remove-NbxIPAMAddressRange").Parameters.Keys | ForEach-Object { $_ | Should -Match '^[A-Z].*' }
        }

        It "Mandatory parameters are present in parameter list" {
            $cmd = Get-Command "Remove-NbxIPAMAddressRange"
            foreach ($p in $cmd.Parameters.GetEnumerator()) {
                foreach ($attr in $p.Value.Attributes) {
                    if ($attr -is [System.Management.Automation.ParameterAttribute] -and $attr.Mandatory) {
                        $cmd.Parameters.Keys | Should -Contain $p.Key
                    }
                }
            }
        }
    }

    Context "Function behavior" {

        BeforeAll {
            Mock -ModuleName NetboxTools -CommandName InvokeNbxRestMethod -MockWith {}

        }

        It "Should call InvokeNbxRestMethod with DELETE method" {
            Remove-NbxIPAMAddressRange -Id 1
            Should -Invoke -ModuleName NetboxTools -CommandName InvokeNbxRestMethod -Times 1 -ParameterFilter {
                $Method -eq 'DELETE' -and $Uri -like '*/ipam/ip-ranges/*1/*'
            }
        }

        It "Should process multiple IDs" {
            Remove-NbxIPAMAddressRange -Id 1, 2, 3
            Should -Invoke -ModuleName NetboxTools -CommandName InvokeNbxRestMethod -Times 3
        }

        AfterAll {
            InModuleScope NetboxTools {
                $script:NbxConfig.Remove('URI')
            }
        }
    }

}
