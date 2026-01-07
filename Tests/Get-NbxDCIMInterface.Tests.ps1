param(
    $PSM1 = "$PSScriptRoot\..\Source\NetboxTools.psm1"
)

BeforeAll {
    Remove-Module NetboxTools -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe "Get-NbxDCIMInterface" {

    Context "Function structure and parameters" {

        It "Should be available as a function" {
            Get-Command -Name "Get-NbxDCIMInterface" -ErrorAction SilentlyContinue | Should -Not -BeNullOrEmpty
        }

        It "Parameter names are PascalCase" {
            (Get-Command "Get-NbxDCIMInterface").Parameters.Keys | ForEach-Object { $_ | Should -Match '^[A-Z].*' }
        }

        It "Mandatory parameters are present in parameter list" {
            $cmd = Get-Command "Get-NbxDCIMInterface"
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
