param(
    $PSM1 = "$PSScriptRoot\..\Source\NetboxTools.psm1"
)

BeforeAll {
    Remove-Module NetboxTools -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe "Get-NbxIPAMPrefix" {

    Context "Function structure and parameters" {

        It "Should be available as a function" {
            Get-Command -Name "Get-NbxIPAMPrefix" -ErrorAction SilentlyContinue | Should -Not -BeNullOrEmpty
        }

        It "Parameter names are PascalCase" {
            (Get-Command "Get-NbxIPAMPrefix").Parameters.Keys | ForEach-Object { $_ | Should -Match '^[A-Z].*' }
        }

        It "Mandatory parameters are present in parameter list" {
            $cmd = Get-Command "Get-NbxIPAMPrefix"
            foreach ($p in $cmd.Parameters.GetEnumerator()) {
                foreach ($attr in $p.Value.Attributes) {
                    if ($attr -is [System.Management.Automation.ParameterAttribute] -and $attr.Mandatory) {
                        $cmd.Parameters.Keys | Should -Contain $p.Key
                    }
                }
            }
        }
    }

}
