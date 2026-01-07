param(
    $PSM1 = "$PSScriptRoot\..\Source\NetboxTools.psm1"
)

BeforeAll {
    Remove-Module NetboxTools -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe "Get-NbxContactAssignment" {

    Context "Function structure and parameters" {

        It "Should be available as a function" {
            Get-Command -Name "Get-NbxContactAssignment" -ErrorAction SilentlyContinue | Should -Not -BeNullOrEmpty
        }

        It "Parameter names are PascalCase" {
            (Get-Command "Get-NbxContactAssignment").Parameters.Keys | ForEach-Object { $_ | Should -Match '^[A-Z].*' }
        }

        It "Should have no mandatory parameters" {
            $cmd = Get-Command "Get-NbxContactAssignment"
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

}
