param(
    $PSM1 = "$PSScriptRoot\..\Source\NetboxTools.psm1"
)

BeforeAll {
    Remove-Module NetboxTools -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
    . "$PSScriptRoot\TestHelpers.ps1"
    Initialize-NbxTestConnection
}

Describe 'New-NbxIPAMAddressRange' {
    BeforeEach {
        Mock Invoke-RestMethod -ModuleName NetboxTools -MockWith { New-NbxTestResponse -Uri $Uri -Method $Method -Body $Body }
    }

    It 'Creates the IP range with a POST request' {
        $Result = New-NbxIPAMAddressRange -StartAddress '192.0.2.10/24' -EndAddress '192.0.2.20/24'
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Method -eq 'POST' -and $Uri -eq 'https://netbox.example.com/api/ipam/ip-ranges/'
        }
        $Result.PSObject.TypeNames | Should -Contain 'NetboxTools.IPAMAddressRange'
    }

    It 'Sends the parameters with NetBox field names' {
        New-NbxIPAMAddressRange -StartAddress '192.0.2.10/24' -EndAddress '192.0.2.20/24'
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Body = $Body | ConvertFrom-Json
            $Body.start_address | Should -Be '192.0.2.10/24'
            $Body.end_address | Should -Be '192.0.2.20/24'
            $true
        }
    }

    It 'Merges OptionalAttribute into the body' {
        New-NbxIPAMAddressRange -StartAddress '192.0.2.10/24' -EndAddress '192.0.2.20/24' -OptionalAttribute @{ custom_fields = @{ owner = 'IT' } }
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            ($Body | ConvertFrom-Json).custom_fields.owner -eq 'IT'
        }
    }

    It 'Accepts NetBox objects from the pipeline' {
        $InputObject = [pscustomobject]@{
            id = 99
            url = 'https://netbox.example.com/api/ipam/ip-ranges/99/'
            start_address = '192.0.2.10/24'
            end_address = '192.0.2.20/24'
        }
        $InputObject | New-NbxIPAMAddressRange
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Body = $Body | ConvertFrom-Json
            $Body.start_address | Should -Be '192.0.2.10/24'
            $Body.end_address | Should -Be '192.0.2.20/24'
            $Body.PSObject.Properties.Name -notcontains 'id'
        }
    }

    It 'Creates one IP range per pipeline object' {
        $InputObject = [pscustomobject]@{
            start_address = '192.0.2.10/24'
            end_address = '192.0.2.20/24'
        }
        $InputObject, $InputObject | New-NbxIPAMAddressRange
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 2 -Exactly
    }

    It 'Does not send the request with -WhatIf' {
        New-NbxIPAMAddressRange -StartAddress '192.0.2.10/24' -EndAddress '192.0.2.20/24' -WhatIf
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 0 -Exactly
    }
}
