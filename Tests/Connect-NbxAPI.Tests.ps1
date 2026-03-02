param(
    $PSM1 = "$PSScriptRoot\..\Source\NetboxTools.psm1"
)

BeforeAll {
    Remove-Module NetboxTools -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe "Connect-NbxAPI" {

    Context "Function structure and parameters" {

        It "Should be available as a function" {
            Get-Command -Name "Connect-NbxAPI" -ErrorAction SilentlyContinue | Should -Not -BeNullOrEmpty
        }

        It "Should have parameters (if any)" {
            (Get-Command "Connect-NbxAPI").Parameters.Keys | Should -Not -BeNullOrEmpty -Because 'most functions have parameters or at least a parameter collection'
        }

        It "Parameter names are PascalCase" {
            (Get-Command "Connect-NbxAPI").Parameters.Keys | ForEach-Object { $_ | Should -Match '^[A-Z].*' }
        }

        It "Should have required parameters" {
            (Get-Command "Connect-NbxAPI").Parameters.Keys | Should -Contain "Hostname"
        }
    }

    Context "Function behavior" {

        BeforeAll {
            Mock -ModuleName NetboxTools -CommandName InvokeNbxRestMethod -MockWith {
                return @{ Content = @{}; Headers = @{}; StatusCode = 200 }
            }
        }

        It "Should set NbxConfig for Token connection with SkipVerification" {
            Connect-NbxAPI -Hostname 'netbox.example.com' -Token 'testtoken123' -SkipVerification
            InModuleScope NetboxTools {
                $script:NbxConfig.AuthenticationType | Should -Be 'Token'
                $script:NbxConfig.Token | Should -Be 'testtoken123'
            }
        }

        It "Should call InvokeNbxRestMethod when verifying Token connection" {
            Connect-NbxAPI -Hostname 'netbox.example.com' -Token 'testtoken123'
            Should -Invoke -ModuleName NetboxTools -CommandName InvokeNbxRestMethod -Times 1
        }

        It "Should set URI correctly" {
            Connect-NbxAPI -Hostname 'netbox.example.com' -Scheme 'https' -Port 443 -SkipVerification -Token 'test'
            InModuleScope NetboxTools {
                $script:NbxConfig.URI | Should -Not -BeNullOrEmpty
                $script:NbxConfig.URI | Should -BeLike '*netbox.example.com*'
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
