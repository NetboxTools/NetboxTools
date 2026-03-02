param(
    $PSM1 = "$PSScriptRoot\..\Source\NetboxTools.psm1"
)

BeforeAll {
    Remove-Module NetboxTools -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe "New-NbxVirtualMachine" {

    Context "Function structure and parameters" {

        It "Should be available as a function" {
            Get-Command -Name "New-NbxVirtualMachine" -ErrorAction SilentlyContinue | Should -Not -BeNullOrEmpty
        }

        It "Parameter names are PascalCase" {
            (Get-Command "New-NbxVirtualMachine").Parameters.Keys | ForEach-Object { $_ | Should -Match '^[A-Z].*' }
        }

        It "Mandatory parameters are present in parameter list" {
            $cmd = Get-Command "New-NbxVirtualMachine"
            $mandatoryParams = @()
            foreach ($p in $cmd.Parameters.GetEnumerator()) {
                foreach ($attr in $p.Value.Attributes) {
                    if ($attr -is [System.Management.Automation.ParameterAttribute] -and $attr.Mandatory) {
                        $mandatoryParams += $p.Key
                    }
                }
            }

            $mandatoryParams | Should -Contain 'Name'
        }
    }

    Context "Function behavior" {

        BeforeAll {
            Mock -ModuleName NetboxTools -CommandName InvokeNbxRestMethod -MockWith {
                return [pscustomobject]@{ id = 1; display = 'Test' }
            }

        }

        It "Should call InvokeNbxRestMethod with POST method" {
            New-NbxVirtualMachine -Name 'TestVM'
            Should -Invoke -ModuleName NetboxTools -CommandName InvokeNbxRestMethod -Times 1 -ParameterFilter {
                $Method -eq 'POST' -and $Uri -like '*/virtualization/virtual-machines/*'
            }
        }

        It "Should include mandatory parameters in the request body" {
            New-NbxVirtualMachine -Name 'TestVM'
            Should -Invoke -ModuleName NetboxTools -CommandName InvokeNbxRestMethod -Times 1 -ParameterFilter {
                $Body -ne $null
            }
        }

        It "Should not throw with valid parameters" {
            { New-NbxVirtualMachine -Name 'TestVM' } | Should -Not -Throw
        }

        AfterAll {
            InModuleScope NetboxTools {
                $script:NbxConfig.Remove('URI')
            }
        }
    }

}
