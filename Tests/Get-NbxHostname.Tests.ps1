param(
    $PSM1 = "$PSScriptRoot\..\Source\NetboxTools.psm1"
)

BeforeAll {
    Remove-Module NetboxTools -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe "Get-NbxHostname" {

    Context "Function structure and parameters" {

        It "Should be available as a function" {
            Get-Command -Name "Get-NbxHostname" -ErrorAction SilentlyContinue | Should -Not -BeNullOrEmpty
        }

        It "Parameter names are PascalCase" {
            (Get-Command "Get-NbxHostname").Parameters.Keys | ForEach-Object { $_ | Should -Match '^[A-Z].*' }
        }

        It "Mandatory parameters are present in parameter list" {
            $cmd = Get-Command "Get-NbxHostname"
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

        It "Should throw when Hostname is not set" {
            InModuleScope NetboxTools {
                $savedConfig = $script:NbxConfig.Clone()
                $script:NbxConfig.Hostname = $null
                try {
                    { Get-NbxHostname } | Should -Throw '*Hostname is not set*'
                }
                finally {
                    $script:NbxConfig = $savedConfig
                }
            }
        }

        It "Should return the hostname when it is set" {
            InModuleScope NetboxTools {
                $savedConfig = $script:NbxConfig.Clone()
                $script:NbxConfig.Hostname = 'netbox.example.com'
                try {
                    Get-NbxHostname | Should -Be 'netbox.example.com'
                }
                finally {
                    $script:NbxConfig = $savedConfig
                }
            }
        }
    }

}
