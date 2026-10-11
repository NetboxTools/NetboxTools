param(
    $PSM1 = "$PSScriptRoot\..\Source\NetboxTools.psm1"
)

BeforeAll {
    Remove-Module NetboxTools -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
    . "$PSScriptRoot\TestHelpers.ps1"
    Initialize-NbxTestConnection
}

Describe 'New-NbxContactAssignment' {
    BeforeEach {
        Mock Invoke-RestMethod -ModuleName NetboxTools -MockWith { New-NbxTestResponse -Uri $Uri -Method $Method -Body $Body }
    }

    It 'Creates the contact assignment with a POST request' {
        $Result = New-NbxContactAssignment -Contact 1 -ObjectType 'dcim.site' -ObjectId 1
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Method -eq 'POST' -and $Uri -eq 'https://netbox.example.com/api/tenancy/contact-assignments/'
        }
        $Result.PSObject.TypeNames | Should -Contain 'NetboxTools.ContactAssignment'
    }

    It 'Sends the parameters with NetBox field names' {
        New-NbxContactAssignment -Contact 1 -ObjectType 'dcim.site' -ObjectId 1
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Body = $Body | ConvertFrom-Json
            $Body.contact | Should -Be 1
            $true
        }
    }

    It 'Merges OptionalAttribute into the body' {
        New-NbxContactAssignment -Contact 1 -ObjectType 'dcim.site' -ObjectId 1 -OptionalAttribute @{ custom_fields = @{ owner = 'IT' } }
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            ($Body | ConvertFrom-Json).custom_fields.owner -eq 'IT'
        }
    }

    It 'Accepts NetBox objects from the pipeline' {
        $InputObject = [pscustomobject]@{
            id = 99
            url = 'https://netbox.example.com/api/tenancy/contact-assignments/99/'
            contact = [pscustomobject]@{ id = 7; url = 'https://netbox.example.com/api/tenancy/contacts/7/' }
            object_type = 'dcim.site'
            object_id = 5
        }
        $InputObject | New-NbxContactAssignment
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Body = $Body | ConvertFrom-Json
            $Body.contact | Should -Be 7
            $Body.PSObject.Properties.Name -notcontains 'id'
        }
    }

    It 'Creates one contact assignment per pipeline object' {
        $InputObject = [pscustomobject]@{
            contact = [pscustomobject]@{ id = 7; url = 'https://netbox.example.com/api/tenancy/contacts/7/' }
            object_type = 'dcim.site'
            object_id = 5
        }
        $InputObject, $InputObject | New-NbxContactAssignment
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 2 -Exactly
    }

    It 'Does not send the request with -WhatIf' {
        New-NbxContactAssignment -Contact 1 -ObjectType 'dcim.site' -ObjectId 1 -WhatIf
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 0 -Exactly
    }

    It 'Sets the object type and ID from an object' {
        New-NbxContactAssignment -Contact 1 -Object ([pscustomobject]@{ id = 5; url = 'https://netbox.example.com/api/dcim/sites/5/' })
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Body = $Body | ConvertFrom-Json
            $Body.object_type -eq 'dcim.site' -and $Body.object_id -eq 5
        }
    }

    It 'Writes an error when no object is specified' {
        { New-NbxContactAssignment -Contact 1 -ErrorAction Stop } | Should -Throw '*Specify the object*'
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 0 -Exactly
    }
}
