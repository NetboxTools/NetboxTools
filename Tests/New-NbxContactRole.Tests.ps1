param(
    $PSM1 = "$PSScriptRoot\..\Source\NetboxTools.psm1"
)

BeforeAll {
    Remove-Module NetboxTools -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
    . "$PSScriptRoot\TestHelpers.ps1"
    Initialize-NbxTestConnection
}

Describe 'New-NbxContactRole' {
    BeforeEach {
        Mock Invoke-RestMethod -ModuleName NetboxTools -MockWith { New-NbxTestResponse -Uri $Uri -Method $Method -Body $Body }
    }

    It 'Creates the contact role with a POST request' {
        $Result = New-NbxContactRole -Name 'Administrative'
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Method -eq 'POST' -and $Uri -eq 'https://netbox.example.com/api/tenancy/contact-roles/'
        }
        $Result.PSObject.TypeNames | Should -Contain 'NetboxTools.ContactRole'
    }

    It 'Sends the parameters with NetBox field names' {
        New-NbxContactRole -Name 'Administrative'
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Body = $Body | ConvertFrom-Json
            $Body.name | Should -Be 'Administrative'
            $true
        }
    }

    It 'Merges OptionalAttribute into the body' {
        New-NbxContactRole -Name 'Administrative' -OptionalAttribute @{ custom_fields = @{ owner = 'IT' } }
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            ($Body | ConvertFrom-Json).custom_fields.owner -eq 'IT'
        }
    }

    It 'Accepts NetBox objects from the pipeline' {
        $InputObject = [pscustomobject]@{
            id = 99
            url = 'https://netbox.example.com/api/tenancy/contact-roles/99/'
            name = 'Administrative'
        }
        $InputObject | New-NbxContactRole
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Body = $Body | ConvertFrom-Json
            $Body.name | Should -Be 'Administrative'
            $Body.PSObject.Properties.Name -notcontains 'id'
        }
    }

    It 'Creates one contact role per pipeline object' {
        $InputObject = [pscustomobject]@{
            name = 'Administrative'
        }
        $InputObject, $InputObject | New-NbxContactRole
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 2 -Exactly
    }

    It 'Does not send the request with -WhatIf' {
        New-NbxContactRole -Name 'Administrative' -WhatIf
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 0 -Exactly
    }

    It 'Generates the slug from the name' {
        New-NbxContactRole -Name 'My Example 1'
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            ($Body | ConvertFrom-Json).slug -eq 'my-example-1'
        }
    }
}
