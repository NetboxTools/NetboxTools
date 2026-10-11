param(
    $PSM1 = "$PSScriptRoot\..\Source\NetboxTools.psm1"
)

BeforeAll {
    Remove-Module NetboxTools -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
    . "$PSScriptRoot\TestHelpers.ps1"
    Initialize-NbxTestConnection
}

Describe 'New-NbxIPAMPrefix' {
    BeforeEach {
        Mock Invoke-RestMethod -ModuleName NetboxTools -MockWith { New-NbxTestResponse -Uri $Uri -Method $Method -Body $Body }
    }

    It 'Creates the prefix with a POST request' {
        $Result = New-NbxIPAMPrefix -Prefix '192.0.2.0/24'
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Method -eq 'POST' -and $Uri -eq 'https://netbox.example.com/api/ipam/prefixes/'
        }
        $Result.PSObject.TypeNames | Should -Contain 'NetboxTools.IPAMPrefix'
    }

    It 'Sends the parameters with NetBox field names' {
        New-NbxIPAMPrefix -Prefix '192.0.2.0/24'
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Body = $Body | ConvertFrom-Json
            $Body.prefix | Should -Be '192.0.2.0/24'
            $true
        }
    }

    It 'Merges OptionalAttribute into the body' {
        New-NbxIPAMPrefix -Prefix '192.0.2.0/24' -OptionalAttribute @{ custom_fields = @{ owner = 'IT' } }
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            ($Body | ConvertFrom-Json).custom_fields.owner -eq 'IT'
        }
    }

    It 'Accepts NetBox objects from the pipeline' {
        $InputObject = [pscustomobject]@{
            id = 99
            url = 'https://netbox.example.com/api/ipam/prefixes/99/'
            prefix = '192.0.2.0/24'
        }
        $InputObject | New-NbxIPAMPrefix
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Body = $Body | ConvertFrom-Json
            $Body.prefix | Should -Be '192.0.2.0/24'
            $Body.PSObject.Properties.Name -notcontains 'id'
        }
    }

    It 'Creates one prefix per pipeline object' {
        $InputObject = [pscustomobject]@{
            prefix = '192.0.2.0/24'
        }
        $InputObject, $InputObject | New-NbxIPAMPrefix
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 2 -Exactly
    }

    It 'Does not send the request with -WhatIf' {
        New-NbxIPAMPrefix -Prefix '192.0.2.0/24' -WhatIf
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 0 -Exactly
    }

    It 'Scopes the prefix to a site object' {
        New-NbxIPAMPrefix -Prefix '192.0.2.0/24' -Scope ([pscustomobject]@{ id = 3; url = 'https://netbox.example.com/api/dcim/sites/3/' })
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Body = $Body | ConvertFrom-Json
            $Body.scope_type -eq 'dcim.site' -and $Body.scope_id -eq 3
        }
    }
}
