param(
    $PSM1 = "$PSScriptRoot\..\Source\NetboxTools.psm1"
)

BeforeAll {
    Remove-Module NetboxTools -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
    . "$PSScriptRoot\TestHelpers.ps1"
    Initialize-NbxTestConnection
}

Describe 'New-NbxDCIMSite' {
    BeforeEach {
        Mock Invoke-RestMethod -ModuleName NetboxTools -MockWith { New-NbxTestResponse -Uri $Uri -Method $Method -Body $Body }
    }

    It 'Creates the site with a POST request' {
        $Result = New-NbxDCIMSite -Name 'Stockholm'
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Method -eq 'POST' -and $Uri -eq 'https://netbox.example.com/api/dcim/sites/'
        }
        $Result.PSObject.TypeNames | Should -Contain 'NetboxTools.DCIMSite'
    }

    It 'Sends the parameters with NetBox field names' {
        New-NbxDCIMSite -Name 'Stockholm'
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Body = $Body | ConvertFrom-Json
            $Body.name | Should -Be 'Stockholm'
            $true
        }
    }

    It 'Merges OptionalAttribute into the body' {
        New-NbxDCIMSite -Name 'Stockholm' -OptionalAttribute @{ custom_fields = @{ owner = 'IT' } }
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            ($Body | ConvertFrom-Json).custom_fields.owner -eq 'IT'
        }
    }

    It 'Accepts NetBox objects from the pipeline' {
        $InputObject = [pscustomobject]@{
            id = 99
            url = 'https://netbox.example.com/api/dcim/sites/99/'
            name = 'Stockholm'
        }
        $InputObject | New-NbxDCIMSite
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Body = $Body | ConvertFrom-Json
            $Body.name | Should -Be 'Stockholm'
            $Body.PSObject.Properties.Name -notcontains 'id'
        }
    }

    It 'Creates one site per pipeline object' {
        $InputObject = [pscustomobject]@{
            name = 'Stockholm'
        }
        $InputObject, $InputObject | New-NbxDCIMSite
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 2 -Exactly
    }

    It 'Does not send the request with -WhatIf' {
        New-NbxDCIMSite -Name 'Stockholm' -WhatIf
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 0 -Exactly
    }

    It 'Generates the slug from the name' {
        New-NbxDCIMSite -Name 'My Example 1'
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            ($Body | ConvertFrom-Json).slug -eq 'my-example-1'
        }
    }
}
