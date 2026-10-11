param(
    $PSM1 = "$PSScriptRoot\..\Source\NetboxTools.psm1"
)

BeforeAll {
    Remove-Module NetboxTools -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
    . "$PSScriptRoot\TestHelpers.ps1"
    Initialize-NbxTestConnection
}

Describe 'New-NbxTenant' {
    BeforeEach {
        Mock Invoke-RestMethod -ModuleName NetboxTools -MockWith { New-NbxTestResponse -Uri $Uri -Method $Method -Body $Body }
    }

    It 'Creates the tenant with a POST request' {
        $Result = New-NbxTenant -Name 'Contoso'
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Method -eq 'POST' -and $Uri -eq 'https://netbox.example.com/api/tenancy/tenants/'
        }
        $Result.PSObject.TypeNames | Should -Contain 'NetboxTools.Tenant'
    }

    It 'Sends the parameters with NetBox field names' {
        New-NbxTenant -Name 'Contoso'
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Body = $Body | ConvertFrom-Json
            $Body.name | Should -Be 'Contoso'
            $true
        }
    }

    It 'Merges OptionalAttribute into the body' {
        New-NbxTenant -Name 'Contoso' -OptionalAttribute @{ custom_fields = @{ owner = 'IT' } }
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            ($Body | ConvertFrom-Json).custom_fields.owner -eq 'IT'
        }
    }

    It 'Accepts NetBox objects from the pipeline' {
        $InputObject = [pscustomobject]@{
            id = 99
            url = 'https://netbox.example.com/api/tenancy/tenants/99/'
            name = 'Contoso'
        }
        $InputObject | New-NbxTenant
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Body = $Body | ConvertFrom-Json
            $Body.name | Should -Be 'Contoso'
            $Body.PSObject.Properties.Name -notcontains 'id'
        }
    }

    It 'Creates one tenant per pipeline object' {
        $InputObject = [pscustomobject]@{
            name = 'Contoso'
        }
        $InputObject, $InputObject | New-NbxTenant
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 2 -Exactly
    }

    It 'Does not send the request with -WhatIf' {
        New-NbxTenant -Name 'Contoso' -WhatIf
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 0 -Exactly
    }

    It 'Generates the slug from the name' {
        New-NbxTenant -Name 'My Example 1'
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            ($Body | ConvertFrom-Json).slug -eq 'my-example-1'
        }
    }
}
