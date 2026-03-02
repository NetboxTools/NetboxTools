param(
    $PSM1 = "$PSScriptRoot\..\Source\NetboxTools.psm1"
)

BeforeAll {
    Remove-Module NetboxTools -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe "Set-NbxHostScheme" {

    Context "Function structure and parameters" {

        It "Should be available as a function" {
            Get-Command -Name "Set-NbxHostScheme" -ErrorAction SilentlyContinue | Should -Not -BeNullOrEmpty
        }

        It "Parameter names are PascalCase" {
            (Get-Command "Set-NbxHostScheme").Parameters.Keys | ForEach-Object { $_ | Should -Match '^[A-Z].*' }
        }

        It "Mandatory parameters are present in parameter list" {
            $cmd = Get-Command "Set-NbxHostScheme"
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

        It "Should set the scheme to https and return it" {
            InModuleScope NetboxTools {
                $savedConfig = $script:NbxConfig.Clone()
                try {
                    Set-NbxHostScheme -Scheme 'https' -Confirm:$false | Should -Be 'https'
                    $script:NbxConfig.HostScheme | Should -Be 'https'
                }
                finally {
                    $script:NbxConfig = $savedConfig
                }
            }
        }

        It "Should warn when setting scheme to http" {
            InModuleScope NetboxTools {
                $savedConfig = $script:NbxConfig.Clone()
                try {
                    Set-NbxHostScheme -Scheme 'http' -Confirm:$false -WarningAction SilentlyContinue | Should -Be 'http'
                }
                finally {
                    $script:NbxConfig = $savedConfig
                }
            }
        }

    }

}
