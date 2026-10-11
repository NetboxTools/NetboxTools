param(
    $PSM1 = "$PSScriptRoot\..\Source\NetboxTools.psm1"
)

BeforeAll {
    Remove-Module NetboxTools -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
    . "$PSScriptRoot\TestHelpers.ps1"
    Initialize-NbxTestConnection
}

Describe 'New-NbxIPAMVLAN' {
    BeforeEach {
        Mock Invoke-RestMethod -ModuleName NetboxTools -MockWith { New-NbxTestResponse -Uri $Uri -Method $Method -Body $Body }
    }

    It 'Creates the VLAN with a POST request' {
        $Result = New-NbxIPAMVLAN -VID 100 -Name 'Servers'
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Method -eq 'POST' -and $Uri -eq 'https://netbox.example.com/api/ipam/vlans/'
        }
        $Result.PSObject.TypeNames | Should -Contain 'NetboxTools.IPAMVLAN'
    }

    It 'Sends the parameters with NetBox field names' {
        New-NbxIPAMVLAN -VID 100 -Name 'Servers'
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Body = $Body | ConvertFrom-Json
            $Body.vid | Should -Be 100
            $Body.name | Should -Be 'Servers'
            $true
        }
    }

    It 'Merges OptionalAttribute into the body' {
        New-NbxIPAMVLAN -VID 100 -Name 'Servers' -OptionalAttribute @{ custom_fields = @{ owner = 'IT' } }
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            ($Body | ConvertFrom-Json).custom_fields.owner -eq 'IT'
        }
    }

    It 'Accepts NetBox objects from the pipeline' {
        $InputObject = [pscustomobject]@{
            id = 99
            url = 'https://netbox.example.com/api/ipam/vlans/99/'
            vid = 100
            name = 'Servers'
        }
        $InputObject | New-NbxIPAMVLAN
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Body = $Body | ConvertFrom-Json
            $Body.vid | Should -Be 100
            $Body.name | Should -Be 'Servers'
            $Body.PSObject.Properties.Name -notcontains 'id'
        }
    }

    It 'Creates one VLAN per pipeline object' {
        $InputObject = [pscustomobject]@{
            vid = 100
            name = 'Servers'
        }
        $InputObject, $InputObject | New-NbxIPAMVLAN
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 2 -Exactly
    }

    It 'Does not send the request with -WhatIf' {
        New-NbxIPAMVLAN -VID 100 -Name 'Servers' -WhatIf
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 0 -Exactly
    }
}
