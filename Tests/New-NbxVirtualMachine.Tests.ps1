param(
    $PSM1 = "$PSScriptRoot\..\Source\NetboxTools.psm1"
)

BeforeAll {
    Remove-Module NetboxTools -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
    . "$PSScriptRoot\TestHelpers.ps1"
    Initialize-NbxTestConnection
}

Describe 'New-NbxVirtualMachine' {
    BeforeEach {
        Mock Invoke-RestMethod -ModuleName NetboxTools -MockWith { New-NbxTestResponse -Uri $Uri -Method $Method -Body $Body }
    }

    It 'Creates the virtual machine with a POST request' {
        $Result = New-NbxVirtualMachine -Name 'vm01'
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Method -eq 'POST' -and $Uri -eq 'https://netbox.example.com/api/virtualization/virtual-machines/'
        }
        $Result.PSObject.TypeNames | Should -Contain 'NetboxTools.VirtualMachine'
    }

    It 'Sends the parameters with NetBox field names' {
        New-NbxVirtualMachine -Name 'vm01'
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Body = $Body | ConvertFrom-Json
            $Body.name | Should -Be 'vm01'
            $true
        }
    }

    It 'Merges OptionalAttribute into the body' {
        New-NbxVirtualMachine -Name 'vm01' -OptionalAttribute @{ custom_fields = @{ owner = 'IT' } }
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            ($Body | ConvertFrom-Json).custom_fields.owner -eq 'IT'
        }
    }

    It 'Accepts NetBox objects from the pipeline' {
        $InputObject = [pscustomobject]@{
            id = 99
            url = 'https://netbox.example.com/api/virtualization/virtual-machines/99/'
            name = 'vm01'
        }
        $InputObject | New-NbxVirtualMachine
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Body = $Body | ConvertFrom-Json
            $Body.name | Should -Be 'vm01'
            $Body.PSObject.Properties.Name -notcontains 'id'
        }
    }

    It 'Creates one virtual machine per pipeline object' {
        $InputObject = [pscustomobject]@{
            name = 'vm01'
        }
        $InputObject, $InputObject | New-NbxVirtualMachine
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 2 -Exactly
    }

    It 'Does not send the request with -WhatIf' {
        New-NbxVirtualMachine -Name 'vm01' -WhatIf
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 0 -Exactly
    }
}
