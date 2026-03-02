param(
    $PSM1 = "$PSScriptRoot\..\Source\NetboxTools.psm1"
)

BeforeAll {
    Remove-Module NetboxTools -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe "Set-NbxTimeout" {

    Context "Function structure and parameters" {

        It "Should be available as a function" {
            Get-Command -Name "Set-NbxTimeout" -ErrorAction SilentlyContinue | Should -Not -BeNullOrEmpty
        }

        It "Parameter names are PascalCase" {
            (Get-Command "Set-NbxTimeout").Parameters.Keys | ForEach-Object { $_ | Should -Match '^[A-Z].*' }
        }

        It "Mandatory parameters are present in parameter list" {
            $cmd = Get-Command "Set-NbxTimeout"
            $mandatoryParams = @()
            foreach ($p in $cmd.Parameters.GetEnumerator()) {
                foreach ($attr in $p.Value.Attributes) {
                    if ($attr -is [System.Management.Automation.ParameterAttribute] -and $attr.Mandatory) {
                        $mandatoryParams += $p.Key
                    }
                }
            }

            $mandatoryParams | Should -BeNullOrEmpty
        }
    }

    Context "Function behavior" {

        It "Should set the timeout and return it" {
            InModuleScope NetboxTools {
                $savedConfig = $script:NbxConfig.Clone()
                try {
                    Set-NbxTimeout -TimeoutSeconds 120 -Confirm:$false | Should -Be 120
                    $script:NbxConfig.Timeout | Should -Be 120
                }
                finally {
                    $script:NbxConfig = $savedConfig
                }
            }
        }

        It "Should use default of 30 when no parameter given" {
            InModuleScope NetboxTools {
                $savedConfig = $script:NbxConfig.Clone()
                try {
                    Set-NbxTimeout -Confirm:$false | Should -Be 30
                }
                finally {
                    $script:NbxConfig = $savedConfig
                }
            }
        }

    }

}
