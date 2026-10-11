param(
    $PSM1 = "$PSScriptRoot\..\Source\NetboxTools.psm1"
)

BeforeAll {
    Remove-Module NetboxTools -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
    . "$PSScriptRoot\TestHelpers.ps1"
    Initialize-NbxTestConnection
}

Describe 'ConvertToNbxBody' {
    BeforeEach {
        Mock Invoke-RestMethod -ModuleName NetboxTools -MockWith { New-NbxTestResponse -Uri $Uri -Method $Method -Body $Body }
    }

    It 'Uses the NetBox field names from the parameter aliases' {
        New-NbxDCIMSite -Name 'Site' -TimeZone 'Europe/Stockholm' -PhysicalAddress 'Street 1'
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Json = $Body | ConvertFrom-Json
            $Json.time_zone -eq 'Europe/Stockholm' -and $Json.physical_address -eq 'Street 1' -and $Json.name -eq 'Site'
        }
    }

    It 'Does not send parameters that are not specified' {
        New-NbxDCIMSite -Name 'Site' -Slug 'site'
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            @(($Body | ConvertFrom-Json).PSObject.Properties).Count -eq 2
        }
    }

    It 'Lets named parameters take precedence over OptionalAttribute' {
        New-NbxDCIMSite -Name 'Site' -Description 'Named' -OptionalAttribute @{ description = 'Optional'; facility = 'F1' }
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Json = $Body | ConvertFrom-Json
            $Json.description -eq 'Named' -and $Json.facility -eq 'F1'
        }
    }

    It 'Does not reuse values from a previous pipeline object' {
        # PowerShell keeps values of the previous pipeline object in $PSBoundParameters
        [pscustomobject]@{ name = 'First'; description = 'Only the first' }, [pscustomobject]@{ name = 'Second' } | New-NbxDCIMSite
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Json = $Body | ConvertFrom-Json
            $Json.name -eq 'Second' -and $Json.PSObject.Properties.Name -notcontains 'description'
        }
    }

    It 'Ignores $null values of pipeline objects' {
        [pscustomobject]@{ name = 'Site'; tenant = $null; region = $null } | New-NbxDCIMSite
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Json = $Body | ConvertFrom-Json
            $Json.PSObject.Properties.Name -notcontains 'tenant' -and $Json.PSObject.Properties.Name -notcontains 'region'
        }
    }

    It 'Converts NetBox objects returned by the API into IDs and values' {
        $Site = [pscustomobject]@{
            id            = 10
            url           = 'https://netbox.example.com/api/dcim/sites/10/'
            name          = 'Copy'
            slug          = 'copy'
            status        = [pscustomobject]@{ value = 'planned'; label = 'Planned' }
            tenant        = [pscustomobject]@{ id = 3; url = 'https://netbox.example.com/api/tenancy/tenants/3/'; name = 'Tenant' }
            tags          = @([pscustomobject]@{ id = 4; url = 'https://netbox.example.com/api/extras/tags/4/'; name = 'Tag' })
            custom_fields = [pscustomobject]@{ owner = 'IT' }
            created       = '2026-01-01T00:00:00Z'
        }
        $Site | New-NbxDCIMSite
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Json = $Body | ConvertFrom-Json
            $Json.status -eq 'planned' -and $Json.tenant -eq 3 -and $Json.tags[0] -eq 4 -and
            $Json.custom_fields.owner -eq 'IT' -and $Json.PSObject.Properties.Name -notcontains 'created'
        }
    }

    It 'Accepts the previous parameter names as aliases' {
        Set-NbxDCIMDevice -Id 1 -Device_Role 2 -Device_Type 3 -Asset_Tag 'A1' -Custom_Fields @{ a = 1 } -Confirm:$false
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Json = $Body | ConvertFrom-Json
            $Json.role -eq 2 -and $Json.device_type -eq 3 -and $Json.asset_tag -eq 'A1' -and $Json.custom_fields.a -eq 1
        }
    }
}

Describe 'ConvertToNbxSlug' {
    It 'Creates a slug from <Name>' -TestCases @(
        @{ Name = 'Stockholm DC 1'; Slug = 'stockholm-dc-1' }
        @{ Name = '  Main/Office  '; Slug = 'main-office' }
        @{ Name = 'core_switch-01'; Slug = 'core_switch-01' }
        @{ Name = 'Åre (Sweden)'; Slug = 're-sweden' }
    ) {
        param ($Name, $Slug)
        InModuleScope NetboxTools -Parameters @{ Name = $Name; Slug = $Slug } {
            param ($Name, $Slug)
            ConvertToNbxSlug -Name $Name | Should -Be $Slug
        }
    }

    It 'Limits the slug to 100 characters' {
        InModuleScope NetboxTools { (ConvertToNbxSlug -Name ('a' * 150)).Length | Should -Be 100 }
    }
}

Describe 'Pipeline input from Import-Csv' {
    BeforeEach {
        Initialize-NbxTestConnection
        Mock Invoke-RestMethod -ModuleName NetboxTools -MockWith { New-NbxTestResponse -Uri $Uri -Method $Method -Body $Body }
    }

    It 'Does not send empty cells' {
        "name,slug,status,tenant,latitude`nSite A,,,," | ConvertFrom-Csv | New-NbxDCIMSite
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Json = $Body | ConvertFrom-Json
            $Names = $Json.PSObject.Properties.Name
            $Json.name -eq 'Site A' -and $Json.slug -eq 'site-a' -and
            $Names -notcontains 'status' -and $Names -notcontains 'tenant' -and $Names -notcontains 'latitude'
        }
    }

    It 'Converts boolean text to booleans' {
        "device,name,type,enabled,mgmt_only`n5,eth0,virtual,true,no" | ConvertFrom-Csv | New-NbxDCIMInterface
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Json = $Body | ConvertFrom-Json
            $Json.enabled -eq $true -and $Json.mgmt_only -eq $false -and $Json.device -eq 5
        }
    }

    It 'Writes an error for an invalid reference and continues with the next object' {
        $Rows = @(
            [pscustomobject]@{ a_terminations = [pscustomobject]@{ name = 'not a NetBox object' }; b_terminations = 2 }
            [pscustomobject]@{ a_terminations = 3; b_terminations = 4 }
        )
        $Rows | New-NbxDCIMCable -ErrorVariable CableErrors -ErrorAction SilentlyContinue
        $CableErrors | Should -Not -BeNullOrEmpty
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            ($Body | ConvertFrom-Json).a_terminations[0].object_id -eq 3
        }
    }
}
