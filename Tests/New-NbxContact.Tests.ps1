param(
    $PSM1 = "$PSScriptRoot\..\Source\NetboxTools.psm1"
)

BeforeAll {
    Remove-Module NetboxTools -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
    . "$PSScriptRoot\TestHelpers.ps1"
    Initialize-NbxTestConnection
}

Describe 'New-NbxContact' {
    BeforeEach {
        Mock Invoke-RestMethod -ModuleName NetboxTools -MockWith { New-NbxTestResponse -Uri $Uri -Method $Method -Body $Body }
    }

    It 'Creates the contact with a POST request' {
        $Result = New-NbxContact -Name 'Jane Doe'
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Method -eq 'POST' -and $Uri -eq 'https://netbox.example.com/api/tenancy/contacts/'
        }
        $Result.PSObject.TypeNames | Should -Contain 'NetboxTools.Contact'
    }

    It 'Sends the parameters with NetBox field names' {
        New-NbxContact -Name 'Jane Doe'
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Body = $Body | ConvertFrom-Json
            $Body.name | Should -Be 'Jane Doe'
            $true
        }
    }

    It 'Merges OptionalAttribute into the body' {
        New-NbxContact -Name 'Jane Doe' -OptionalAttribute @{ custom_fields = @{ owner = 'IT' } }
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            ($Body | ConvertFrom-Json).custom_fields.owner -eq 'IT'
        }
    }

    It 'Accepts NetBox objects from the pipeline' {
        $InputObject = [pscustomobject]@{
            id = 99
            url = 'https://netbox.example.com/api/tenancy/contacts/99/'
            name = 'Jane Doe'
        }
        $InputObject | New-NbxContact
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Body = $Body | ConvertFrom-Json
            $Body.name | Should -Be 'Jane Doe'
            $Body.PSObject.Properties.Name -notcontains 'id'
        }
    }

    It 'Creates one contact per pipeline object' {
        $InputObject = [pscustomobject]@{
            name = 'Jane Doe'
        }
        $InputObject, $InputObject | New-NbxContact
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 2 -Exactly
    }

    It 'Does not send the request with -WhatIf' {
        New-NbxContact -Name 'Jane Doe' -WhatIf
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 0 -Exactly
    }
}
