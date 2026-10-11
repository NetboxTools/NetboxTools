param(
    $PSM1 = "$PSScriptRoot\..\Source\NetboxTools.psm1"
)

BeforeAll {
    Remove-Module NetboxTools -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
    . "$PSScriptRoot\TestHelpers.ps1"
    Initialize-NbxTestConnection
}

Describe 'New-NbxVirtualMachineInterface' {
    BeforeEach {
        Mock Invoke-RestMethod -ModuleName NetboxTools -MockWith { New-NbxTestResponse -Uri $Uri -Method $Method -Body $Body }
    }

    It 'Creates the virtual machine interface with a POST request' {
        $Result = New-NbxVirtualMachineInterface -VirtualMachine 1 -Name 'eth0'
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Method -eq 'POST' -and $Uri -eq 'https://netbox.example.com/api/virtualization/interfaces/'
        }
        $Result.PSObject.TypeNames | Should -Contain 'NetboxTools.VirtualMachineInterface'
    }

    It 'Sends the parameters with NetBox field names' {
        New-NbxVirtualMachineInterface -VirtualMachine 1 -Name 'eth0'
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Body = $Body | ConvertFrom-Json
            $Body.virtual_machine | Should -Be 1
            $Body.name | Should -Be 'eth0'
            $true
        }
    }

    It 'Merges OptionalAttribute into the body' {
        New-NbxVirtualMachineInterface -VirtualMachine 1 -Name 'eth0' -OptionalAttribute @{ custom_fields = @{ owner = 'IT' } }
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            ($Body | ConvertFrom-Json).custom_fields.owner -eq 'IT'
        }
    }

    It 'Accepts NetBox objects from the pipeline' {
        $InputObject = [pscustomobject]@{
            id = 99
            url = 'https://netbox.example.com/api/virtualization/interfaces/99/'
            virtual_machine = [pscustomobject]@{ id = 7; url = 'https://netbox.example.com/api/virtualization/virtual-machines/7/' }
            name = 'eth0'
        }
        $InputObject | New-NbxVirtualMachineInterface
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Body = $Body | ConvertFrom-Json
            $Body.virtual_machine | Should -Be 7
            $Body.name | Should -Be 'eth0'
            $Body.PSObject.Properties.Name -notcontains 'id'
        }
    }

    It 'Creates one virtual machine interface per pipeline object' {
        $InputObject = [pscustomobject]@{
            virtual_machine = [pscustomobject]@{ id = 7; url = 'https://netbox.example.com/api/virtualization/virtual-machines/7/' }
            name = 'eth0'
        }
        $InputObject, $InputObject | New-NbxVirtualMachineInterface
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 2 -Exactly
    }

    It 'Does not send the request with -WhatIf' {
        New-NbxVirtualMachineInterface -VirtualMachine 1 -Name 'eth0' -WhatIf
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 0 -Exactly
    }
}
