param(
    $PSM1 = "$PSScriptRoot\..\Source\NetboxTools.psm1"
)

BeforeAll {
    Remove-Module NetboxTools -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
    . "$PSScriptRoot\TestHelpers.ps1"
    Initialize-NbxTestConnection
}

Describe 'Connect-NbxAPI' {
    BeforeEach {
        InModuleScope NetboxTools { $script:NbxConfig = NewNbxConfig }
        Mock Invoke-RestMethod -ModuleName NetboxTools -MockWith { [pscustomobject]@{ } }
    }

    AfterAll {
        Initialize-NbxTestConnection
    }

    It 'Connects with a token and verifies the connection' {
        Connect-NbxAPI -Hostname 'netbox.example.com' -Token 'abc123'
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Uri -like 'https://netbox.example.com/api/users/config/*' -and $Headers.Authorization -eq 'Token abc123'
        }
        InModuleScope NetboxTools { $script:NbxConfig.URI } | Should -Be 'https://netbox.example.com/api'
    }

    It 'Uses the Bearer keyword for v2 tokens' {
        Connect-NbxAPI -Hostname 'netbox.example.com' -Token 'nbt_key.secret'
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Headers.Authorization -eq 'Bearer nbt_key.secret'
        }
    }

    It 'Connects with the token as the password of a credential' {
        $Credential = [pscredential]::new('ignored', (ConvertTo-SecureString -String 'abc123' -AsPlainText -Force))
        Connect-NbxAPI -Hostname 'netbox.example.com' -Credential $Credential
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Headers.Authorization -eq 'Token abc123'
        }
    }

    It 'Connects anonymously without an Authorization header' {
        Connect-NbxAPI -Hostname 'netbox.example.com' -Anonymous
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Uri -like 'https://netbox.example.com/api/status/*' -and -not $Headers.ContainsKey('Authorization')
        }
    }

    It 'Accepts a URL as hostname' {
        Connect-NbxAPI -Hostname 'http://netbox.lab:8000' -Token 'abc123' -SkipVerification -WarningAction SilentlyContinue
        InModuleScope NetboxTools { $script:NbxConfig.URI } | Should -Be 'http://netbox.lab:8000/api'
    }

    It 'Uses port 80 for http by default and warns' {
        Connect-NbxAPI -Hostname 'netbox.lab' -Scheme http -Token 'abc123' -SkipVerification -WarningVariable Warnings -WarningAction SilentlyContinue
        InModuleScope NetboxTools { $script:NbxConfig.Port } | Should -Be 80
        $Warnings | Should -Not -BeNullOrEmpty
    }

    It 'Does not verify the connection with -SkipVerification' {
        Connect-NbxAPI -Hostname 'netbox.example.com' -Token 'abc123' -SkipVerification
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 0 -Exactly
    }

    It 'Configures -SkipCertificateCheck for all requests' {
        Connect-NbxAPI -Hostname 'netbox.example.com' -Token 'abc123' -SkipCertificateCheck
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter { $SkipCertificateCheck -eq $true }
    }

    It 'Keeps the configured timeout' {
        Set-NbxTimeout -TimeoutSeconds 90
        Connect-NbxAPI -Hostname 'netbox.example.com' -Token 'abc123'
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter { $TimeoutSec -eq 90 }
    }

    It 'Throws and keeps the previous connection when the verification fails' {
        Mock Invoke-RestMethod -ModuleName NetboxTools -MockWith { throw 'Invalid token' }
        { Connect-NbxAPI -Hostname 'netbox.example.com' -Token 'bad' } | Should -Throw '*Failed to connect*Invalid token*'
        InModuleScope NetboxTools { $script:NbxConfig.URI } | Should -BeNullOrEmpty
    }
}

Describe 'Connect-NbxAPI certificate validation' {
    BeforeEach {
        InModuleScope NetboxTools { $script:NbxConfig = NewNbxConfig }
        Mock Invoke-RestMethod -ModuleName NetboxTools -MockWith { [pscustomobject]@{ } }
    }

    AfterAll {
        Initialize-NbxTestConnection
    }

    It 'Validates certificates for a new connection, even when the previous connection skipped validation' {
        Connect-NbxAPI -Hostname 'lab.local' -Token 'abc' -SkipCertificateCheck -SkipVerification
        Connect-NbxAPI -Hostname 'netbox.example.com' -Token 'def'
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Uri.Host -eq 'netbox.example.com' -and $SkipCertificateCheck -eq $false
        }
    }

    It 'Keeps other invoke parameters of the previous connection' {
        Set-NbxInvokeParameter -InvokeParameter @{ MaximumRetryCount = 3 }
        Connect-NbxAPI -Hostname 'netbox.example.com' -Token 'def'
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter { $MaximumRetryCount -eq 3 }
    }
}
