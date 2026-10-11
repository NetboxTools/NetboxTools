param(
    $PSM1 = "$PSScriptRoot\..\Source\NetboxTools.psm1"
)

BeforeAll {
    Remove-Module NetboxTools -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
    . "$PSScriptRoot\TestHelpers.ps1"
    Initialize-NbxTestConnection
}

Describe 'New-NbxDCIMCable' {
    BeforeEach {
        Mock Invoke-RestMethod -ModuleName NetboxTools -MockWith { New-NbxTestResponse -Uri $Uri -Method $Method -Body $Body }
    }

    It 'Creates the cable with a POST request' {
        $Result = New-NbxDCIMCable -ATermination 1 -BTermination 2
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Method -eq 'POST' -and $Uri -eq 'https://netbox.example.com/api/dcim/cables/'
        }
        $Result.PSObject.TypeNames | Should -Contain 'NetboxTools.DCIMCable'
    }

    It 'Sends the parameters with NetBox field names' {
        New-NbxDCIMCable -ATermination 1 -BTermination 2
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Body = $Body | ConvertFrom-Json
            $Body.a_terminations[0].object_type | Should -Be 'dcim.interface'
            $Body.a_terminations[0].object_id | Should -Be 1
            $Body.b_terminations[0].object_type | Should -Be 'dcim.interface'
            $Body.b_terminations[0].object_id | Should -Be 2
            $true
        }
    }

    It 'Merges OptionalAttribute into the body' {
        New-NbxDCIMCable -ATermination 1 -BTermination 2 -OptionalAttribute @{ custom_fields = @{ owner = 'IT' } }
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            ($Body | ConvertFrom-Json).custom_fields.owner -eq 'IT'
        }
    }

    It 'Accepts NetBox objects from the pipeline' {
        $InputObject = [pscustomobject]@{
            id = 99
            url = 'https://netbox.example.com/api/dcim/cables/99/'
            a_terminations = @([pscustomobject]@{ object_type = 'dcim.interface'; object_id = 7 })
            b_terminations = @([pscustomobject]@{ object_type = 'dcim.interface'; object_id = 7 })
        }
        $InputObject | New-NbxDCIMCable
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Body = $Body | ConvertFrom-Json
            $Body.a_terminations[0].object_id | Should -Be 7
            $Body.b_terminations[0].object_id | Should -Be 7
            $Body.PSObject.Properties.Name -notcontains 'id'
        }
    }

    It 'Creates one cable per pipeline object' {
        $InputObject = [pscustomobject]@{
            a_terminations = @([pscustomobject]@{ object_type = 'dcim.interface'; object_id = 7 })
            b_terminations = @([pscustomobject]@{ object_type = 'dcim.interface'; object_id = 7 })
        }
        $InputObject, $InputObject | New-NbxDCIMCable
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 2 -Exactly
    }

    It 'Does not send the request with -WhatIf' {
        New-NbxDCIMCable -ATermination 1 -BTermination 2 -WhatIf
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 0 -Exactly
    }

    It 'Derives the termination type from objects' {
        New-NbxDCIMCable -ATermination ([pscustomobject]@{ id = 3; url = 'https://netbox.example.com/api/dcim/front-ports/3/' }) -BTermination ([pscustomobject]@{ id = 4; url = 'https://netbox.example.com/api/circuits/circuit-terminations/4/' })
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Body = $Body | ConvertFrom-Json
            $Body.a_terminations[0].object_type -eq 'dcim.frontport' -and $Body.b_terminations[0].object_type -eq 'circuits.circuittermination'
        }
    }
}
