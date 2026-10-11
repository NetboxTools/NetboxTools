param(
    $PSM1 = "$PSScriptRoot\..\Source\NetboxTools.psm1"
)

BeforeAll {
    Remove-Module NetboxTools -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
    . "$PSScriptRoot\TestHelpers.ps1"
    Initialize-NbxTestConnection
}

Describe 'New-NbxDCIMInterface' {
    BeforeEach {
        Mock Invoke-RestMethod -ModuleName NetboxTools -MockWith { New-NbxTestResponse -Uri $Uri -Method $Method -Body $Body }
    }

    It 'Creates the interface with a POST request' {
        $Result = New-NbxDCIMInterface -Device 1 -Name 'eth0' -Type 'virtual'
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Method -eq 'POST' -and $Uri -eq 'https://netbox.example.com/api/dcim/interfaces/'
        }
        $Result.PSObject.TypeNames | Should -Contain 'NetboxTools.DCIMInterface'
    }

    It 'Sends the parameters with NetBox field names' {
        New-NbxDCIMInterface -Device 1 -Name 'eth0' -Type 'virtual'
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Body = $Body | ConvertFrom-Json
            $Body.device | Should -Be 1
            $Body.name | Should -Be 'eth0'
            $Body.type | Should -Be 'virtual'
            $true
        }
    }

    It 'Merges OptionalAttribute into the body' {
        New-NbxDCIMInterface -Device 1 -Name 'eth0' -Type 'virtual' -OptionalAttribute @{ custom_fields = @{ owner = 'IT' } }
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            ($Body | ConvertFrom-Json).custom_fields.owner -eq 'IT'
        }
    }

    It 'Accepts NetBox objects from the pipeline' {
        $InputObject = [pscustomobject]@{
            id = 99
            url = 'https://netbox.example.com/api/dcim/interfaces/99/'
            device = [pscustomobject]@{ id = 7; url = 'https://netbox.example.com/api/dcim/devices/7/' }
            name = 'eth0'
            type = [pscustomobject]@{ value = 'virtual'; label = 'Label' }
        }
        $InputObject | New-NbxDCIMInterface
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Body = $Body | ConvertFrom-Json
            $Body.device | Should -Be 7
            $Body.name | Should -Be 'eth0'
            $Body.type | Should -Be 'virtual'
            $Body.PSObject.Properties.Name -notcontains 'id'
        }
    }

    It 'Creates one interface per pipeline object' {
        $InputObject = [pscustomobject]@{
            device = [pscustomobject]@{ id = 7; url = 'https://netbox.example.com/api/dcim/devices/7/' }
            name = 'eth0'
            type = [pscustomobject]@{ value = 'virtual'; label = 'Label' }
        }
        $InputObject, $InputObject | New-NbxDCIMInterface
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 2 -Exactly
    }

    It 'Does not send the request with -WhatIf' {
        New-NbxDCIMInterface -Device 1 -Name 'eth0' -Type 'virtual' -WhatIf
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 0 -Exactly
    }
}
