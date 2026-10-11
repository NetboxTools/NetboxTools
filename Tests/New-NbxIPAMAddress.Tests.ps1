param(
    $PSM1 = "$PSScriptRoot\..\Source\NetboxTools.psm1"
)

BeforeAll {
    Remove-Module NetboxTools -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
    . "$PSScriptRoot\TestHelpers.ps1"
    Initialize-NbxTestConnection
}

Describe 'New-NbxIPAMAddress' {
    BeforeEach {
        Mock Invoke-RestMethod -ModuleName NetboxTools -MockWith { New-NbxTestResponse -Uri $Uri -Method $Method -Body $Body }
    }

    It 'Creates the IP address with a POST request' {
        $Result = New-NbxIPAMAddress -Address '192.0.2.10/24'
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Method -eq 'POST' -and $Uri -eq 'https://netbox.example.com/api/ipam/ip-addresses/'
        }
        $Result.PSObject.TypeNames | Should -Contain 'NetboxTools.IPAMAddress'
    }

    It 'Sends the parameters with NetBox field names' {
        New-NbxIPAMAddress -Address '192.0.2.10/24'
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Body = $Body | ConvertFrom-Json
            $Body.address | Should -Be '192.0.2.10/24'
            $true
        }
    }

    It 'Merges OptionalAttribute into the body' {
        New-NbxIPAMAddress -Address '192.0.2.10/24' -OptionalAttribute @{ custom_fields = @{ owner = 'IT' } }
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            ($Body | ConvertFrom-Json).custom_fields.owner -eq 'IT'
        }
    }

    It 'Accepts NetBox objects from the pipeline' {
        $InputObject = [pscustomobject]@{
            id = 99
            url = 'https://netbox.example.com/api/ipam/ip-addresses/99/'
            address = '192.0.2.10/24'
        }
        $InputObject | New-NbxIPAMAddress
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Body = $Body | ConvertFrom-Json
            $Body.address | Should -Be '192.0.2.10/24'
            $Body.PSObject.Properties.Name -notcontains 'id'
        }
    }

    It 'Creates one IP address per pipeline object' {
        $InputObject = [pscustomobject]@{
            address = '192.0.2.10/24'
        }
        $InputObject, $InputObject | New-NbxIPAMAddress
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 2 -Exactly
    }

    It 'Does not send the request with -WhatIf' {
        New-NbxIPAMAddress -Address '192.0.2.10/24' -WhatIf
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 0 -Exactly
    }

    It 'Assigns the IP address to an interface object' {
        New-NbxIPAMAddress -Address '192.0.2.10/24' -AssignedObject ([pscustomobject]@{ id = 3; url = 'https://netbox.example.com/api/virtualization/interfaces/3/' })
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Body = $Body | ConvertFrom-Json
            $Body.assigned_object_type -eq 'virtualization.vminterface' -and $Body.assigned_object_id -eq 3
        }
    }
}
