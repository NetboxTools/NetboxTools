param(
    $PSM1 = "$PSScriptRoot\..\Source\NetboxTools.psm1"
)

BeforeAll {
    Remove-Module NetboxTools -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
    . "$PSScriptRoot\TestHelpers.ps1"
    Initialize-NbxTestConnection

    function global:New-NbxTestHttpError {
        param ([int]$StatusCode, [string]$Content)
        $Response = [System.Net.Http.HttpResponseMessage]::new([System.Net.HttpStatusCode]$StatusCode)
        $Exception = [Microsoft.PowerShell.Commands.HttpResponseException]::new("Response status code does not indicate success: $StatusCode.", $Response)
        $Record = [System.Management.Automation.ErrorRecord]::new($Exception, 'WebCmdletWebResponseException', 'InvalidOperation', $null)
        $Record.ErrorDetails = [System.Management.Automation.ErrorDetails]::new($Content)
        $Record
    }
}

Describe 'InvokeNbxRestMethod' {
    BeforeEach {
        Initialize-NbxTestConnection
        Mock Invoke-RestMethod -ModuleName NetboxTools -MockWith { New-NbxTestResponse -Uri $Uri -Method $Method -Body $Body }
    }

    Context 'Requests' {
        It 'Throws a terminating error when not connected' {
            Disconnect-NbxAPI
            { InModuleScope NetboxTools { InvokeNbxRestMethod -Endpoint 'dcim/sites/' } } | Should -Throw '*Not connected*'
            Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 0 -Exactly
        }

        It 'Sends the token, timeout and JSON content type' {
            InModuleScope NetboxTools { InvokeNbxRestMethod -Endpoint 'dcim/sites/1/' }
            Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
                $Headers.Authorization -eq 'Token 0123456789abcdef' -and $TimeoutSec -eq 30 -and $ContentType -like 'application/json*'
            }
        }

        It 'Does not send an Authorization header for anonymous connections' {
            InModuleScope NetboxTools { $script:NbxConfig.AuthenticationType = 'Anonymous' }
            InModuleScope NetboxTools { InvokeNbxRestMethod -Endpoint 'dcim/sites/1/' }
            Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
                -not $Headers.ContainsKey('Authorization')
            }
        }

        It 'Converts the body to JSON' {
            InModuleScope NetboxTools { InvokeNbxRestMethod -Endpoint 'dcim/sites/' -Method POST -Body @{ name = 'Site'; tags = @(1, 2) } }
            Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
                $Json = $Body | ConvertFrom-Json
                $Json.name -eq 'Site' -and $Json.tags.Count -eq 2
            }
        }

        It 'Merges the invoke parameters into the request' {
            InModuleScope NetboxTools { $script:NbxConfig.InvokeParams = @{ SkipCertificateCheck = $true } }
            InModuleScope NetboxTools { InvokeNbxRestMethod -Endpoint 'dcim/sites/1/' }
            Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter { $SkipCertificateCheck -eq $true }
        }

        It 'Adds the type name to returned objects' {
            $Result = InModuleScope NetboxTools { InvokeNbxRestMethod -Endpoint 'dcim/sites/1/' -TypeName 'NetboxTools.Test' }
            $Result.PSObject.TypeNames[0] | Should -Be 'NetboxTools.Test'
        }

        It 'Returns nothing for empty responses' {
            InModuleScope NetboxTools { InvokeNbxRestMethod -Endpoint 'dcim/sites/1/' -Method DELETE } | Should -BeNullOrEmpty
        }
    }

    Context 'Pagination' {
        BeforeEach {
            # Three pages of two objects, the next link uses another host like NetBox behind a proxy can
            Mock Invoke-RestMethod -ModuleName NetboxTools -MockWith {
                $Offset = if ($Uri.Query -match 'offset=(\d+)') { [int]$Matches[1] } else { 0 }
                $Next = if ($Offset -lt 4) { "http://internal:8080/api/dcim/sites/?limit=2&offset=$($Offset + 2)" } else { $null }
                [pscustomobject]@{
                    count   = 6
                    next    = $Next
                    results = @(
                        [pscustomobject]@{ id = $Offset + 1 }
                        [pscustomobject]@{ id = $Offset + 2 }
                    )
                }
            }
        }

        It 'Returns the objects of all pages' {
            $Result = InModuleScope NetboxTools { InvokeNbxRestMethod -Endpoint 'dcim/sites/' }
            $Result.id | Should -Be 1, 2, 3, 4, 5, 6
            Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 3 -Exactly
        }

        It 'Requests the next pages on the configured host' {
            InModuleScope NetboxTools { InvokeNbxRestMethod -Endpoint 'dcim/sites/' }
            Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
                $Uri.AbsoluteUri -eq 'https://netbox.example.com/api/dcim/sites/?limit=2&offset=2'
            }
            Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 0 -Exactly -ParameterFilter { $Uri.Host -eq 'internal' }
        }

        It 'Stops at the limit' {
            $Result = InModuleScope NetboxTools { InvokeNbxRestMethod -Endpoint 'dcim/sites/' -Limit 3 }
            $Result.id | Should -Be 1, 2, 3
            Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 2 -Exactly
        }

        It 'Does not paginate when the query has a limit or offset' {
            $Result = InModuleScope NetboxTools { InvokeNbxRestMethod -Endpoint 'dcim/sites/' -Query @{ limit = 2; offset = 2 } }
            $Result.id | Should -Be 3, 4
            Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly
        }
    }

    Context 'Errors' {
        It 'Writes a non-terminating error with the message from NetBox' {
            Mock Invoke-RestMethod -ModuleName NetboxTools -MockWith { throw (New-NbxTestHttpError -StatusCode 400 -Content '{"name":["This field is required."]}') }
            $Result = InModuleScope NetboxTools { InvokeNbxRestMethod -Endpoint 'dcim/sites/' -Method POST -Body @{} -ErrorAction SilentlyContinue -ErrorVariable NbxError; $NbxError }
            $Last = $Result | Select-Object -Last 1
            $Last.Exception.Message | Should -BeLike '*POST*dcim/sites/*400*This field is required.*'
            $Last.CategoryInfo.Category | Should -Be 'InvalidArgument'
            $Last.FullyQualifiedErrorId | Should -BeLike 'NbxApiError400*'
        }

        It 'Uses the detail of NetBox errors' {
            Mock Invoke-RestMethod -ModuleName NetboxTools -MockWith { throw (New-NbxTestHttpError -StatusCode 404 -Content '{"detail":"No Site matches the given query."}') }
            { InModuleScope NetboxTools { InvokeNbxRestMethod -Endpoint 'dcim/sites/99/' -ErrorAction Stop } } |
                Should -Throw '*404*No Site matches the given query.'
        }

        It 'Continues with the next object in the pipeline after an error' {
            Mock Invoke-RestMethod -ModuleName NetboxTools -MockWith { throw (New-NbxTestHttpError -StatusCode 404 -Content '{"detail":"Not found."}') } -ParameterFilter { $Uri -like '*/1/' }
            $Result = 1, 2 | Get-NbxDCIMSite -ErrorAction SilentlyContinue
            $Result.id | Should -Be 2
        }

        It 'Reports errors without a response' {
            Mock Invoke-RestMethod -ModuleName NetboxTools -MockWith { throw [System.Net.Http.HttpRequestException]::new('No such host is known.') }
            { Get-NbxDCIMSite -ErrorAction Stop } | Should -Throw '*No such host is known.*'
        }
    }
}

Describe 'ConvertToNbxQueryString' {
    It 'Encodes keys and values and repeats arrays' {
        InModuleScope NetboxTools {
            ConvertToNbxQueryString -Query ([ordered]@{ q = 'a b&c'; tag = 'x', 'y'; enabled = $true }) |
                Should -Be 'q=a%20b%26c&tag=x&tag=y&enabled=true'
        }
    }

    It 'Keeps the case of values' {
        InModuleScope NetboxTools { ConvertToNbxQueryString -Query @{ name = 'SW-Core01' } | Should -Be 'name=SW-Core01' }
    }

    It 'Returns an empty string without query' {
        InModuleScope NetboxTools { ConvertToNbxQueryString -Query @{} | Should -Be '' }
    }
}

Describe 'Filter keys' {
    BeforeEach {
        Initialize-NbxTestConnection
        Mock Invoke-RestMethod -ModuleName NetboxTools -MockWith { New-NbxTestResponse -Uri $Uri -Method $Method -Body $Body }
    }

    It 'Lower cases filter keys, as NetBox ignores filters it does not recognize' {
        InModuleScope NetboxTools { ConvertToNbxQueryString -Query @{ Site = 'Lab' } | Should -Be 'site=Lab' }
    }

    It 'Sends the filter of the query and the -Name parameter in lower case' {
        Get-NbxDCIMDevice -Query @{ Site = 'lab'; Name = 'a' } -Name 'b'
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Uri.AbsoluteUri -cmatch '[?&]site=lab' -and $Uri.AbsoluteUri -cmatch '[?&]name=b' -and $Uri.AbsoluteUri -cnotmatch 'Site=|Name='
        }
    }

    It 'Accepts the hidden -All switch of earlier versions' {
        Get-NbxDCIMDevice -All
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Uri.AbsoluteUri -eq 'https://netbox.example.com/api/dcim/devices/?limit=1000'
        }
    }

    It 'Adds custom headers without replacing the Authorization header' {
        InModuleScope NetboxTools { $script:NbxConfig.InvokeParams = @{ Headers = @{ 'X-Custom' = 'yes'; Authorization = 'Basic other' } } }
        Get-NbxTag
        Should -Invoke Invoke-RestMethod -ModuleName NetboxTools -Times 1 -Exactly -ParameterFilter {
            $Headers['X-Custom'] -eq 'yes' -and $Headers.Authorization -eq 'Token 0123456789abcdef'
        }
    }
}
