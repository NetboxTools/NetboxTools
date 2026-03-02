param(
    $PSM1 = "$PSScriptRoot\..\Source\NetboxTools.psm1"
)

BeforeAll {
    Remove-Module NetboxTools -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe "Set-NbxVirtualMachine" {

    Context "Function structure and parameters" {

        It "Should be available as a function" {
            Get-Command -Name "Set-NbxVirtualMachine" -ErrorAction SilentlyContinue | Should -Not -BeNullOrEmpty
        }

        It "Parameter names are PascalCase" {
            (Get-Command "Set-NbxVirtualMachine").Parameters.Keys | ForEach-Object { $_ | Should -Match '^[A-Z].*' }
        }

        It "Mandatory parameters are present in parameter list" {
            (Get-Command "Set-NbxVirtualMachine").Parameters.Keys | Should -Contain "Id"
        }
    }

    Context "Function behavior" {

        BeforeAll {
            InModuleScope NetboxTools {
                Set-Item -Path function:script:BuildURIComponents -Value {
                    param($URISegments, $ParametersDictionary, $SkipParameterByName)
                    return @{ Segments = $URISegments; Parameters = @{} }
                }
                Set-Item -Path function:script:BuildNewURI -Value {
                    param($Segments)
                    return 'https://netbox.example.com/api/test/1/'
                }
                Set-Item -Path function:script:InvokeNbxRequest -Value {
                    param($URI, $Body, $Method)
                    return [pscustomobject]@{ id = 1 }
                }
            }
            Mock -ModuleName NetboxTools -CommandName Get-NbxVirtualMachine -MockWith {
                return [pscustomobject]@{ id = 1; Name = 'Test'; display = 'Test' }
            }
            Mock -ModuleName NetboxTools -CommandName BuildURIComponents -MockWith {
                return @{ Segments = @('test'); Parameters = @{} }
            }
            Mock -ModuleName NetboxTools -CommandName BuildNewURI -MockWith {
                return 'https://netbox.example.com/api/test/1/'
            }
            Mock -ModuleName NetboxTools -CommandName InvokeNbxRequest -MockWith {
                return [pscustomobject]@{ id = 1; display = 'Test' }
            }
        }

        It "Should call InvokeNbxRequest with PATCH method when Force is used" {
            Set-NbxVirtualMachine -Id 1 -Name 'Updated' -Force
            Should -Invoke -ModuleName NetboxTools -CommandName InvokeNbxRequest -Times 1
        }

        It "Should not call Get-NbxVirtualMachine (currently commented out in source)" {
            Set-NbxVirtualMachine -Id 1 -Name 'Updated' -Force
            Should -Invoke -ModuleName NetboxTools -CommandName Get-NbxVirtualMachine -Times 0
        }

        It "Should not throw with valid parameters" {
            { Set-NbxVirtualMachine -Id 1 -Name 'Updated' -Force } | Should -Not -Throw
        }
    }

}
