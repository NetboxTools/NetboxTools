param(
    $PSM1 = "$PSScriptRoot\..\Source\NetboxTools.psm1"
)

BeforeAll {
    Remove-Module NetboxTools -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
    . "$PSScriptRoot\TestHelpers.ps1"
    Initialize-NbxTestConnection
}

Describe 'New-NbxDCIMFrontPort' {
    BeforeEach {
        Mock Invoke-RestMethod -ModuleName NetboxTools -MockWith { New-NbxTestResponse -Uri $Uri -Method $Method -Body $Body }
    }

    It 'Creates the front port with a POST request' {
        $Result = New-NbxDCIMFrontPort -Device 1 -Name 'FP1' -Type '8p8c'
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Method -eq 'POST' -and $Uri -eq 'https://netbox.example.com/api/dcim/front-ports/'
        }
        $Result.PSObject.TypeNames | Should -Contain 'NetboxTools.DCIMFrontPort'
    }

    It 'Sends the parameters with NetBox field names' {
        New-NbxDCIMFrontPort -Device 1 -Name 'FP1' -Type '8p8c'
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Body = $Body | ConvertFrom-Json
            $Body.device | Should -Be 1
            $Body.name | Should -Be 'FP1'
            $Body.type | Should -Be '8p8c'
            $true
        }
    }

    It 'Merges OptionalAttribute into the body' {
        New-NbxDCIMFrontPort -Device 1 -Name 'FP1' -Type '8p8c' -OptionalAttribute @{ custom_fields = @{ owner = 'IT' } }
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            ($Body | ConvertFrom-Json).custom_fields.owner -eq 'IT'
        }
    }

    It 'Accepts NetBox objects from the pipeline' {
        $InputObject = [pscustomobject]@{
            id = 99
            url = 'https://netbox.example.com/api/dcim/front-ports/99/'
            device = [pscustomobject]@{ id = 7; url = 'https://netbox.example.com/api/dcim/devices/7/' }
            name = 'FP1'
            type = [pscustomobject]@{ value = '8p8c'; label = 'Label' }
        }
        $InputObject | New-NbxDCIMFrontPort
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Body = $Body | ConvertFrom-Json
            $Body.device | Should -Be 7
            $Body.name | Should -Be 'FP1'
            $Body.type | Should -Be '8p8c'
            $Body.PSObject.Properties.Name -notcontains 'id'
        }
    }

    It 'Creates one front port per pipeline object' {
        $InputObject = [pscustomobject]@{
            device = [pscustomobject]@{ id = 7; url = 'https://netbox.example.com/api/dcim/devices/7/' }
            name = 'FP1'
            type = [pscustomobject]@{ value = '8p8c'; label = 'Label' }
        }
        $InputObject, $InputObject | New-NbxDCIMFrontPort
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 2 -Exactly
    }

    It 'Does not send the request with -WhatIf' {
        New-NbxDCIMFrontPort -Device 1 -Name 'FP1' -Type '8p8c' -WhatIf
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 0 -Exactly
    }

    It 'Maps the front port to a rear port' {
        New-NbxDCIMFrontPort -Device 1 -Name 'FP1' -Type '8p8c' -RearPort ([pscustomobject]@{ id = 9; url = 'https://netbox.example.com/api/dcim/rear-ports/9/' }) -RearPortPosition 2
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Mapping = ($Body | ConvertFrom-Json).rear_ports[0]
            $Mapping.rear_port -eq 9 -and $Mapping.rear_port_position -eq 2 -and $Mapping.position -eq 1
        }
    }
}
