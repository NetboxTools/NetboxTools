param(
    $PSM1 = "$PSScriptRoot\..\Source\NetboxTools.psm1"
)

BeforeAll {
    Remove-Module NetboxTools -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe "InvokeNbxRestMethod" {

    Context "Authentication handling" {

        It "Should throw when AuthenticationType is not set" {
            InModuleScope NetboxTools {
                $savedConfig = $script:NbxConfig.Clone()
                $script:NbxConfig.Remove('AuthenticationType')
                try {
                    { InvokeNbxRestMethod -Uri 'https://netbox.example.com/api/test/' -Method GET } | Should -Throw '*Please login*'
                }
                finally {
                    $script:NbxConfig = $savedConfig
                }
            }
        }

        It "Should send anonymous request when AuthenticationType is Anonymous" {
            Mock -ModuleName NetboxTools -CommandName Invoke-RestMethod -MockWith {
                return [pscustomobject]@{ id = 1 }
            }
            InModuleScope NetboxTools {
                $savedConfig = $script:NbxConfig.Clone()
                $script:NbxConfig.AuthenticationType = 'Anonymous'
                try {
                    InvokeNbxRestMethod -Uri 'https://netbox.example.com/api/test/' -Method GET
                }
                finally {
                    $script:NbxConfig = $savedConfig
                }
            }
            Should -Invoke -ModuleName NetboxTools -CommandName Invoke-RestMethod -Times 1
        }

        It "Should use token from NbxConfig when Token parameter is not passed" {
            Mock -ModuleName NetboxTools -CommandName Invoke-RestMethod -MockWith {
                return [pscustomobject]@{ id = 1 }
            }
            InModuleScope NetboxTools {
                $savedConfig = $script:NbxConfig.Clone()
                $script:NbxConfig.AuthenticationType = 'Token'
                $script:NbxConfig.Token = 'abc123'
                try {
                    InvokeNbxRestMethod -Uri 'https://netbox.example.com/api/test/' -Method GET
                }
                finally {
                    $script:NbxConfig = $savedConfig
                }
            }
            Should -Invoke -ModuleName NetboxTools -CommandName Invoke-RestMethod -Times 1
        }

        It "Should use token from parameter when Token is passed explicitly" {
            Mock -ModuleName NetboxTools -CommandName Invoke-RestMethod -MockWith {
                return [pscustomobject]@{ id = 1 }
            }
            InModuleScope NetboxTools {
                $savedConfig = $script:NbxConfig.Clone()
                $script:NbxConfig.AuthenticationType = 'Token'
                try {
                    InvokeNbxRestMethod -Uri 'https://netbox.example.com/api/test/' -Method GET -Token 'explicit-token'
                }
                finally {
                    $script:NbxConfig = $savedConfig
                }
            }
            Should -Invoke -ModuleName NetboxTools -CommandName Invoke-RestMethod -Times 1
        }

        It "Should throw when Token auth is set but no token is available" {
            InModuleScope NetboxTools {
                $savedConfig = $script:NbxConfig.Clone()
                $script:NbxConfig.AuthenticationType = 'Token'
                $script:NbxConfig.Remove('Token')
                $script:NbxConfig.Token = $null
                try {
                    { InvokeNbxRestMethod -Uri 'https://netbox.example.com/api/test/' -Method GET } | Should -Throw '*provide a valid token*'
                }
                finally {
                    $script:NbxConfig = $savedConfig
                }
            }
        }
    }

    Context "Query string building" {

        BeforeAll {
            Mock -ModuleName NetboxTools -CommandName Invoke-RestMethod -MockWith {
                return [pscustomobject]@{ id = 1 }
            }
        }

        It "Should build query string from hashtable" {
            InModuleScope NetboxTools {
                $savedConfig = $script:NbxConfig.Clone()
                $script:NbxConfig.AuthenticationType = 'Anonymous'
                try {
                    InvokeNbxRestMethod -Uri 'https://netbox.example.com/api/test/' -Method GET -Query @{ name = 'test' }
                }
                finally {
                    $script:NbxConfig = $savedConfig
                }
            }
            Should -Invoke -ModuleName NetboxTools -CommandName Invoke-RestMethod -Times 1 -ParameterFilter {
                $Uri -like '*?name=test*'
            }
        }

        It "Should build query string with multiple parameters" {
            InModuleScope NetboxTools {
                $savedConfig = $script:NbxConfig.Clone()
                $script:NbxConfig.AuthenticationType = 'Anonymous'
                try {
                    InvokeNbxRestMethod -Uri 'https://netbox.example.com/api/test/' -Method GET -Query @{ name = 'test'; status = 'active' }
                }
                finally {
                    $script:NbxConfig = $savedConfig
                }
            }
            Should -Invoke -ModuleName NetboxTools -CommandName Invoke-RestMethod -Times 1 -ParameterFilter {
                $Uri -like '*?*' -and $Uri -like '*name=test*' -and $Uri -like '*status=active*'
            }
        }
    }

    Context "Response handling" {

        It "Should extract results when response has results property" {
            Mock -ModuleName NetboxTools -CommandName Invoke-RestMethod -MockWith {
                $obj = [pscustomobject]@{ results = @([pscustomobject]@{ id = 1; name = 'Test' }) }
                return $obj
            }
            InModuleScope NetboxTools {
                $savedConfig = $script:NbxConfig.Clone()
                $script:NbxConfig.AuthenticationType = 'Anonymous'
                try {
                    $result = InvokeNbxRestMethod -Uri 'https://netbox.example.com/api/test/' -Method GET
                    $result.id | Should -Be 1
                    $result.name | Should -Be 'Test'
                }
                finally {
                    $script:NbxConfig = $savedConfig
                }
            }
        }

        It "Should return full object when response has no results property" {
            Mock -ModuleName NetboxTools -CommandName Invoke-RestMethod -MockWith {
                return [pscustomobject]@{ id = 1; name = 'Direct' }
            }
            InModuleScope NetboxTools {
                $savedConfig = $script:NbxConfig.Clone()
                $script:NbxConfig.AuthenticationType = 'Anonymous'
                try {
                    $result = InvokeNbxRestMethod -Uri 'https://netbox.example.com/api/test/' -Method GET
                    $result.name | Should -Be 'Direct'
                }
                finally {
                    $script:NbxConfig = $savedConfig
                }
            }
        }

        It "Should return full response when FullResponse switch is used" {
            Mock -ModuleName NetboxTools -CommandName Invoke-RestMethod -MockWith {
                return [pscustomobject]@{ id = 1 }
            }
            InModuleScope NetboxTools {
                $savedConfig = $script:NbxConfig.Clone()
                $script:NbxConfig.AuthenticationType = 'Anonymous'
                try {
                    $result = InvokeNbxRestMethod -Uri 'https://netbox.example.com/api/test/' -Method GET -FullResponse
                    $result.Keys | Should -Contain 'Content'
                    $result.Keys | Should -Contain 'Headers'
                    $result.Keys | Should -Contain 'StatusCode'
                }
                finally {
                    $script:NbxConfig = $savedConfig
                }
            }
        }
    }

    Context "Body handling" {

        BeforeAll {
            Mock -ModuleName NetboxTools -CommandName Invoke-RestMethod -MockWith {
                return [pscustomobject]@{ id = 1 }
            }
        }

        It "Should include body in request when Body parameter is provided" {
            InModuleScope NetboxTools {
                $savedConfig = $script:NbxConfig.Clone()
                $script:NbxConfig.AuthenticationType = 'Anonymous'
                try {
                    InvokeNbxRestMethod -Uri 'https://netbox.example.com/api/test/' -Method POST -Body '{"name":"test"}'
                }
                finally {
                    $script:NbxConfig = $savedConfig
                }
            }
            Should -Invoke -ModuleName NetboxTools -CommandName Invoke-RestMethod -Times 1 -ParameterFilter {
                $Body -eq '{"name":"test"}'
            }
        }
    }
}
