param(
    $PSM1 = "$PSScriptRoot\..\Source\NetboxTools.psm1"
)

BeforeAll {
    Remove-Module NetboxTools -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
    . "$PSScriptRoot\TestHelpers.ps1"
    Initialize-NbxTestConnection
}

Describe 'New-NbxCircuit' {
    BeforeEach {
        Mock Invoke-RestMethod -ModuleName NetboxTools -MockWith { New-NbxTestResponse -Uri $Uri -Method $Method -Body $Body }
    }

    It 'Creates the circuit with a POST request' {
        $Result = New-NbxCircuit -CID 'CID-1001' -Provider 1 -Type 1
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Method -eq 'POST' -and $Uri -eq 'https://netbox.example.com/api/circuits/circuits/'
        }
        $Result.PSObject.TypeNames | Should -Contain 'NetboxTools.Circuit'
    }

    It 'Sends the parameters with NetBox field names' {
        New-NbxCircuit -CID 'CID-1001' -Provider 1 -Type 1
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Body = $Body | ConvertFrom-Json
            $Body.cid | Should -Be 'CID-1001'
            $Body.provider | Should -Be 1
            $Body.type | Should -Be 1
            $true
        }
    }

    It 'Merges OptionalAttribute into the body' {
        New-NbxCircuit -CID 'CID-1001' -Provider 1 -Type 1 -OptionalAttribute @{ custom_fields = @{ owner = 'IT' } }
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            ($Body | ConvertFrom-Json).custom_fields.owner -eq 'IT'
        }
    }

    It 'Accepts NetBox objects from the pipeline' {
        $InputObject = [pscustomobject]@{
            id = 99
            url = 'https://netbox.example.com/api/circuits/circuits/99/'
            cid = 'CID-1001'
            provider = [pscustomobject]@{ id = 7; url = 'https://netbox.example.com/api/circuits/providers/7/' }
            type = [pscustomobject]@{ id = 7; url = 'https://netbox.example.com/api/circuits/circuit-types/7/' }
        }
        $InputObject | New-NbxCircuit
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Body = $Body | ConvertFrom-Json
            $Body.cid | Should -Be 'CID-1001'
            $Body.provider | Should -Be 7
            $Body.type | Should -Be 7
            $Body.PSObject.Properties.Name -notcontains 'id'
        }
    }

    It 'Creates one circuit per pipeline object' {
        $InputObject = [pscustomobject]@{
            cid = 'CID-1001'
            provider = [pscustomobject]@{ id = 7; url = 'https://netbox.example.com/api/circuits/providers/7/' }
            type = [pscustomobject]@{ id = 7; url = 'https://netbox.example.com/api/circuits/circuit-types/7/' }
        }
        $InputObject, $InputObject | New-NbxCircuit
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 2 -Exactly
    }

    It 'Does not send the request with -WhatIf' {
        New-NbxCircuit -CID 'CID-1001' -Provider 1 -Type 1 -WhatIf
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 0 -Exactly
    }
}
