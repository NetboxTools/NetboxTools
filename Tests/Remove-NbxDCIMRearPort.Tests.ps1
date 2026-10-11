param(
    $PSM1 = "$PSScriptRoot\..\Source\NetboxTools.psm1"
)

BeforeAll {
    Remove-Module NetboxTools -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
    . "$PSScriptRoot\TestHelpers.ps1"
    Initialize-NbxTestConnection
}

Describe 'Remove-NbxDCIMRearPort' {
    BeforeEach {
        Mock Invoke-RestMethod -ModuleName NetboxTools -MockWith { New-NbxTestResponse -Uri $Uri -Method $Method -Body $Body }
    }

    It 'Has a high confirm impact' {
        (Get-Command Remove-NbxDCIMRearPort).ScriptBlock.Attributes.Where({ $_ -is [System.Management.Automation.CmdletBindingAttribute] }).ConfirmImpact |
            Should -Be 'High'
    }

    It 'Removes the rear port with a DELETE request' {
        Remove-NbxDCIMRearPort -Id 42 -Confirm:$false | Should -BeNullOrEmpty
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Method -eq 'DELETE' -and $Uri -eq 'https://netbox.example.com/api/dcim/rear-ports/42/'
        }
    }

    It 'Removes without confirmation with -Force' {
        Remove-NbxDCIMRearPort -Id 42 -Force
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly
    }

    It 'Accepts IDs and rear port objects from the pipeline' {
        41, [pscustomobject]@{ id = 42; url = 'https://netbox.example.com/api/dcim/rear-ports/42/' } | Remove-NbxDCIMRearPort -Force
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter { $Uri -eq 'https://netbox.example.com/api/dcim/rear-ports/41/' }
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter { $Uri -eq 'https://netbox.example.com/api/dcim/rear-ports/42/' }
    }

    It 'Rejects objects of another type' {
        { [pscustomobject]@{ id = 42; url = 'https://netbox.example.com/api/dcim/sites/42/' } | Remove-NbxDCIMRearPort -Force -ErrorAction Stop } | Should -Throw '*not of the expected type*'
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 0 -Exactly
    }

    It 'Does not send the request with -WhatIf' {
        Remove-NbxDCIMRearPort -Id 42 -WhatIf
        Remove-NbxDCIMRearPort -Id 42 -WhatIf -Force
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 0 -Exactly
    }
}
