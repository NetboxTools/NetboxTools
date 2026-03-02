param(
    $PSM1 = "$PSScriptRoot\..\Source\NetboxTools.psm1"
)

BeforeAll {
    Remove-Module NetboxTools -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe "GetNbxConfigVariable" {

    Context "Function behavior" {

        It "Should return the NbxConfig hashtable" {
            InModuleScope NetboxTools {
                $result = GetNbxConfigVariable
                $result | Should -Not -BeNullOrEmpty
                $result | Should -BeOfType [hashtable]
            }
        }

        It "Should return the same reference as script:NbxConfig" {
            InModuleScope NetboxTools {
                $script:NbxConfig.TestKey = 'TestValue'
                $result = GetNbxConfigVariable
                $result.TestKey | Should -Be 'TestValue'
                $script:NbxConfig.Remove('TestKey')
            }
        }

        It "Should contain default keys" {
            InModuleScope NetboxTools {
                $result = GetNbxConfigVariable
                $result.Keys | Should -Contain 'Connected'
                $result.Keys | Should -Contain 'Timeout'
            }
        }
    }
}
