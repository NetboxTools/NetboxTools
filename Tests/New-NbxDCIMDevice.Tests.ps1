param(
    $PSM1 = "$PSScriptRoot\..\Source\NetboxTools.psm1"
)

BeforeAll {
    Remove-Module NetboxTools -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
    . "$PSScriptRoot\TestHelpers.ps1"
    Initialize-NbxTestConnection
}

Describe 'New-NbxDCIMDevice' {
    BeforeEach {
        Mock Invoke-RestMethod -ModuleName NetboxTools -MockWith { New-NbxTestResponse -Uri $Uri -Method $Method -Body $Body }
    }

    It 'Creates the device with a POST request' {
        $Result = New-NbxDCIMDevice -Role 1 -DeviceType 1 -Site 1
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Method -eq 'POST' -and $Uri -eq 'https://netbox.example.com/api/dcim/devices/'
        }
        $Result.PSObject.TypeNames | Should -Contain 'NetboxTools.DCIMDevice'
    }

    It 'Sends the parameters with NetBox field names' {
        New-NbxDCIMDevice -Role 1 -DeviceType 1 -Site 1
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Body = $Body | ConvertFrom-Json
            $Body.role | Should -Be 1
            $Body.device_type | Should -Be 1
            $Body.site | Should -Be 1
            $true
        }
    }

    It 'Merges OptionalAttribute into the body' {
        New-NbxDCIMDevice -Role 1 -DeviceType 1 -Site 1 -OptionalAttribute @{ custom_fields = @{ owner = 'IT' } }
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            ($Body | ConvertFrom-Json).custom_fields.owner -eq 'IT'
        }
    }

    It 'Accepts NetBox objects from the pipeline' {
        $InputObject = [pscustomobject]@{
            id = 99
            url = 'https://netbox.example.com/api/dcim/devices/99/'
            role = [pscustomobject]@{ id = 7; url = 'https://netbox.example.com/api/dcim/device-roles/7/' }
            device_type = [pscustomobject]@{ id = 7; url = 'https://netbox.example.com/api/dcim/device-types/7/' }
            site = [pscustomobject]@{ id = 7; url = 'https://netbox.example.com/api/dcim/sites/7/' }
        }
        $InputObject | New-NbxDCIMDevice
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Body = $Body | ConvertFrom-Json
            $Body.role | Should -Be 7
            $Body.device_type | Should -Be 7
            $Body.site | Should -Be 7
            $Body.PSObject.Properties.Name -notcontains 'id'
        }
    }

    It 'Creates one device per pipeline object' {
        $InputObject = [pscustomobject]@{
            role = [pscustomobject]@{ id = 7; url = 'https://netbox.example.com/api/dcim/device-roles/7/' }
            device_type = [pscustomobject]@{ id = 7; url = 'https://netbox.example.com/api/dcim/device-types/7/' }
            site = [pscustomobject]@{ id = 7; url = 'https://netbox.example.com/api/dcim/sites/7/' }
        }
        $InputObject, $InputObject | New-NbxDCIMDevice
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 2 -Exactly
    }

    It 'Does not send the request with -WhatIf' {
        New-NbxDCIMDevice -Role 1 -DeviceType 1 -Site 1 -WhatIf
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 0 -Exactly
    }
}
