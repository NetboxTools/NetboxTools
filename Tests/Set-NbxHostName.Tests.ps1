param(
    $PSM1 = "$PSScriptRoot\..\Source\NetboxTools.psm1"
)

BeforeAll {
    Remove-Module NetboxTools -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe "Set-NbxHostName" {

    Context "Function structure and parameters" {

        It "Should be available as a function" {
            Get-Command -Name "Set-NbxHostName" -ErrorAction SilentlyContinue | Should -Not -BeNullOrEmpty
        }

        It "Parameter names are PascalCase" {
            (Get-Command "Set-NbxHostName").Parameters.Keys | ForEach-Object { $_ | Should -Match '^[A-Z].*' }
        }

        It "Mandatory parameters are present in parameter list" {
            $cmd = Get-Command "Set-NbxHostName"
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

        It "Should set the hostname and return it" {
            InModuleScope NetboxTools {
                $savedConfig = $script:NbxConfig.Clone()
                try {
                    Set-NbxHostName -Hostname 'netbox.example.com' -Confirm:$false | Should -Be 'netbox.example.com'
                    $script:NbxConfig.Hostname | Should -Be 'netbox.example.com'
                }
                finally {
                    $script:NbxConfig = $savedConfig
                }
            }
        }

        It "Should trim whitespace from hostname" {
            InModuleScope NetboxTools {
                $savedConfig = $script:NbxConfig.Clone()
                try {
                    Set-NbxHostName -Hostname '  netbox.example.com  ' -Confirm:$false | Should -Be 'netbox.example.com'
                }
                finally {
                    $script:NbxConfig = $savedConfig
                }
            }
        }

    }

}
