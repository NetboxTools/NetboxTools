param(
    $PSM1 = "$PSScriptRoot\..\Source\NetboxTools.psm1"
)

BeforeAll {
    Remove-Module NetboxTools -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe "Get-NbxHostPort" {

    Context "Function structure and parameters" {

        It "Should be available as a function" {
            Get-Command -Name "Get-NbxHostPort" -ErrorAction SilentlyContinue | Should -Not -BeNullOrEmpty
        }

        It "Parameter names are PascalCase" {
            (Get-Command "Get-NbxHostPort").Parameters.Keys | ForEach-Object { $_ | Should -Match '^[A-Z].*' }
        }

        It "Mandatory parameters are present in parameter list" {
            $cmd = Get-Command "Get-NbxHostPort"
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

        It "Should throw when HostPort is not set" {
            InModuleScope NetboxTools {
                $savedConfig = $script:NbxConfig.Clone()
                $script:NbxConfig.HostPort = $null
                try {
                    { Get-NbxHostPort } | Should -Throw '*host port is not set*'
                }
                finally {
                    $script:NbxConfig = $savedConfig
                }
            }
        }

        It "Should return the host port when it is set" {
            InModuleScope NetboxTools {
                $savedConfig = $script:NbxConfig.Clone()
                $script:NbxConfig.HostPort = 8443
                try {
                    Get-NbxHostPort | Should -Be 8443
                }
                finally {
                    $script:NbxConfig = $savedConfig
                }
            }
        }
    }

}
