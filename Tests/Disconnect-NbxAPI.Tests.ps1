param(
    $PSM1 = "$PSScriptRoot\..\Source\NetboxTools.psm1"
)

BeforeAll {
    Remove-Module NetboxTools -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe "Disconnect-NbxAPI" {

    Context "Function structure and parameters" {

        It "Should be available as a function" {
            Get-Command -Name "Disconnect-NbxAPI" -ErrorAction SilentlyContinue | Should -Not -BeNullOrEmpty
        }

        It "Should have parameters (if any)" {
            (Get-Command "Disconnect-NbxAPI").Parameters.Keys | Should -Not -BeNullOrEmpty -Because 'most functions have parameters or at least a parameter collection'
        }

        It "Parameter names are PascalCase" {
            (Get-Command "Disconnect-NbxAPI").Parameters.Keys | ForEach-Object { $_ | Should -Match '^[A-Z].*' }
        }
    }

    Context "Function behavior" {

        It "Should set NbxConfig to null" {
            Disconnect-NbxAPI
            InModuleScope NetboxTools {
                $script:NbxConfig | Should -BeNullOrEmpty
            }
        }

        AfterAll {
            InModuleScope NetboxTools {
                $script:NbxConfig = @{
                    'Connected'     = $true
                    'Choices'       = @{}
                    'APIDefinition' = $null
                    'ContentTypes'  = $null
                    'NbxVersion'    = @{ 'Netbox-version' = '3.5.4' }
                    'Timeout'       = 30
                    'Credential'    = [System.Management.Automation.PSCredential]::Empty
                    'InvokeParams'  = @{ SkipCertificateCheck = $false }
                }
            }
        }
    }

}
