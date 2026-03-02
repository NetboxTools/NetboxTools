param(
    $PSM1 = "$PSScriptRoot\..\Source\NetboxTools.psm1"
)

BeforeAll {
    Remove-Module NetboxTools -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe "Add-NbxDCIMInterface" {

    Context "Function structure and parameters" {

        It "Should be available as a function" {
            Get-Command -Name "Add-NbxDCIMInterface" -ErrorAction SilentlyContinue | Should -Not -BeNullOrEmpty
        }

        It "Parameter names are PascalCase" {
            (Get-Command "Add-NbxDCIMInterface").Parameters.Keys | ForEach-Object { $_ | Should -Match '^[A-Z].*' }
        }

        It "Mandatory parameters are present in parameter list" {
            $cmd = Get-Command "Add-NbxDCIMInterface"
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
            Mock -ModuleName NetboxTools -CommandName InvokeNbxRestMethod -MockWith {
                return [pscustomobject]@{ id = 1; name = 'eth0' }
            }

        }

        It "Should call InvokeNbxRestMethod with POST method" {
            Add-NbxDCIMInterface -Device 1 -Name 'eth0'
            Should -Invoke -ModuleName NetboxTools -CommandName InvokeNbxRestMethod -Times 1 -ParameterFilter {
                $Method -eq 'POST' -and $Uri -like '*/dcim/interfaces/*'
            }
        }

        It "Should not throw with valid parameters" {
            { Add-NbxDCIMInterface -Device 1 -Name 'eth0' } | Should -Not -Throw
        }

        AfterAll {
            InModuleScope NetboxTools {
                $script:NbxConfig.Remove('URI')
            }
        }
    }

}
