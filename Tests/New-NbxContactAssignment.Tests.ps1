param(
    $PSM1 = "$PSScriptRoot\..\Source\NetboxTools.psm1"
)

BeforeAll {
    Remove-Module NetboxTools -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe "New-NbxContactAssignment" {

    Context "Function structure and parameters" {

        It "Should be available as a function" {
            Get-Command -Name "New-NbxContactAssignment" -ErrorAction SilentlyContinue | Should -Not -BeNullOrEmpty
        }

        It "Parameter names are PascalCase" {
            (Get-Command "New-NbxContactAssignment").Parameters.Keys | ForEach-Object { $_ | Should -Match '^[A-Z].*' }
        }

        It "Mandatory parameters are present in parameter list" {
            $cmd = Get-Command "New-NbxContactAssignment"
            $mandatoryParams = @()
            foreach ($p in $cmd.Parameters.GetEnumerator()) {
                foreach ($attr in $p.Value.Attributes) {
                    if ($attr -is [System.Management.Automation.ParameterAttribute] -and $attr.Mandatory) {
                        $mandatoryParams += $p.Key
                    }
                }
            }

            $mandatoryParams | Should -Contain 'Content_Type'
            $mandatoryParams | Should -Contain 'Object_Id'
            $mandatoryParams | Should -Contain 'Contact'
            $mandatoryParams | Should -Contain 'Role'
        }
    }

}
