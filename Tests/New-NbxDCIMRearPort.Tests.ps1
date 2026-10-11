param(
    $PSM1 = "$PSScriptRoot\..\Source\NetboxTools.psm1"
)

BeforeAll {
    Remove-Module NetboxTools -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
    . "$PSScriptRoot\TestHelpers.ps1"
    Initialize-NbxTestConnection
}

Describe 'New-NbxDCIMRearPort' {
    BeforeEach {
        Mock Invoke-RestMethod -ModuleName NetboxTools -MockWith { New-NbxTestResponse -Uri $Uri -Method $Method -Body $Body }
    }

    It 'Creates the rear port with a POST request' {
        $Result = New-NbxDCIMRearPort -Device 1 -Name 'RP1' -Type '8p8c'
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Method -eq 'POST' -and $Uri -eq 'https://netbox.example.com/api/dcim/rear-ports/'
        }
        $Result.PSObject.TypeNames | Should -Contain 'NetboxTools.DCIMRearPort'
    }

    It 'Sends the parameters with NetBox field names' {
        New-NbxDCIMRearPort -Device 1 -Name 'RP1' -Type '8p8c'
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Body = $Body | ConvertFrom-Json
            $Body.device | Should -Be 1
            $Body.name | Should -Be 'RP1'
            $Body.type | Should -Be '8p8c'
            $true
        }
    }

    It 'Merges OptionalAttribute into the body' {
        New-NbxDCIMRearPort -Device 1 -Name 'RP1' -Type '8p8c' -OptionalAttribute @{ custom_fields = @{ owner = 'IT' } }
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            ($Body | ConvertFrom-Json).custom_fields.owner -eq 'IT'
        }
    }

    It 'Accepts NetBox objects from the pipeline' {
        $InputObject = [pscustomobject]@{
            id = 99
            url = 'https://netbox.example.com/api/dcim/rear-ports/99/'
            device = [pscustomobject]@{ id = 7; url = 'https://netbox.example.com/api/dcim/devices/7/' }
            name = 'RP1'
            type = [pscustomobject]@{ value = '8p8c'; label = 'Label' }
        }
        $InputObject | New-NbxDCIMRearPort
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Body = $Body | ConvertFrom-Json
            $Body.device | Should -Be 7
            $Body.name | Should -Be 'RP1'
            $Body.type | Should -Be '8p8c'
            $Body.PSObject.Properties.Name -notcontains 'id'
        }
    }

    It 'Creates one rear port per pipeline object' {
        $InputObject = [pscustomobject]@{
            device = [pscustomobject]@{ id = 7; url = 'https://netbox.example.com/api/dcim/devices/7/' }
            name = 'RP1'
            type = [pscustomobject]@{ value = '8p8c'; label = 'Label' }
        }
        $InputObject, $InputObject | New-NbxDCIMRearPort
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 2 -Exactly
    }

    It 'Does not send the request with -WhatIf' {
        New-NbxDCIMRearPort -Device 1 -Name 'RP1' -Type '8p8c' -WhatIf
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 0 -Exactly
    }
}
