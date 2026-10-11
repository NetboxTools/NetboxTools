param(
    $PSM1 = "$PSScriptRoot\..\Source\NetboxTools.psm1"
)

BeforeAll {
    Remove-Module NetboxTools -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
    . "$PSScriptRoot\TestHelpers.ps1"
    Initialize-NbxTestConnection
}

Describe 'Set-NbxContactAssignment' {
    BeforeEach {
        Mock Invoke-RestMethod -ModuleName NetboxTools -MockWith { New-NbxTestResponse -Uri $Uri -Method $Method -Body $Body }
    }

    It 'Updates only the specified properties with a PATCH request' {
        Set-NbxContactAssignment -Id 42 -Priority 'primary' -Confirm:$false
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Body = $Body | ConvertFrom-Json
            $Method -eq 'PATCH' -and $Uri -eq 'https://netbox.example.com/api/tenancy/contact-assignments/42/' -and
            $Body.priority -eq 'primary' -and @($Body.PSObject.Properties).Count -eq 1
        }
    }


    It 'Clears a reference when $null is specified' {
        Set-NbxContactAssignment -Id 42 -Role $null -Confirm:$false
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Body -match '"role":null'
        }
    }

    It 'Accepts IDs and contact assignment objects from the pipeline' {
        41, [pscustomobject]@{ id = 42; url = 'https://netbox.example.com/api/tenancy/contact-assignments/42/' } | Set-NbxContactAssignment -Priority 'primary' -Confirm:$false
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter { $Uri -eq 'https://netbox.example.com/api/tenancy/contact-assignments/41/' }
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter { $Uri -eq 'https://netbox.example.com/api/tenancy/contact-assignments/42/' }
    }

    It 'Rejects objects of another type' {
        { [pscustomobject]@{ id = 42; url = 'https://netbox.example.com/api/dcim/sites/42/' } | Set-NbxContactAssignment -Priority 'primary' -Confirm:$false -ErrorAction Stop } | Should -Throw '*not of the expected type*'
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 0 -Exactly
    }

    It 'Returns nothing by default and the updated object with -PassThru' {
        Set-NbxContactAssignment -Id 42 -Priority 'primary' -Confirm:$false | Should -BeNullOrEmpty
        $Result = Set-NbxContactAssignment -Id 42 -Priority 'primary' -PassThru -Confirm:$false
        $Result.PSObject.TypeNames | Should -Contain 'NetboxTools.ContactAssignment'
    }

    It 'Throws when no properties are specified' {
        { Set-NbxContactAssignment -Id 42 -Confirm:$false } | Should -Throw '*at least one property*'
    }

    It 'Does not send the request with -WhatIf' {
        Set-NbxContactAssignment -Id 42 -Priority 'primary' -WhatIf
        Set-NbxContactAssignment -Id 42 -Priority 'primary' -WhatIf -Force
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 0 -Exactly
    }
}
