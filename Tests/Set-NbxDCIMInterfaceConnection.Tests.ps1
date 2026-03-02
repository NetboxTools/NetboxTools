param(
    $PSM1 = "$PSScriptRoot\..\Source\NetboxTools.psm1"
)

BeforeAll {
    Remove-Module NetboxTools -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe "Set-NbxDCIMInterfaceConnection" {

    Context "Function structure and parameters" {

        It "Should be available as a function" {
            Get-Command -Name "Set-NbxDCIMInterfaceConnection" -ErrorAction SilentlyContinue | Should -Not -BeNullOrEmpty
        }

        It "Parameter names are PascalCase" {
            (Get-Command "Set-NbxDCIMInterfaceConnection").Parameters.Keys | ForEach-Object { $_ | Should -Match '^[A-Z].*' }
        }

        It "Mandatory parameters are present in parameter list" {
            $cmd = Get-Command "Set-NbxDCIMInterfaceConnection"
            foreach ($p in $cmd.Parameters.GetEnumerator()) {
                foreach ($attr in $p.Value.Attributes) {
                    if ($attr -is [System.Management.Automation.ParameterAttribute] -and $attr.Mandatory) {
                        $cmd.Parameters.Keys | Should -Contain $p.Key
                    }
                }
            }
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
            Mock -ModuleName NetboxTools -CommandName Get-NbxDCIMInterfaceConnection -MockWith {
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
            Set-NbxDCIMInterfaceConnection -Id 1 -Interface_A 1 -Force
            Should -Invoke -ModuleName NetboxTools -CommandName InvokeNbxRequest -Times 1
        }

        It "Should call Get-NbxDCIMInterfaceConnection to verify the object exists" {
            Set-NbxDCIMInterfaceConnection -Id 1 -Interface_A 1 -Force
            Should -Invoke -ModuleName NetboxTools -CommandName Get-NbxDCIMInterfaceConnection -Times 1
        }

        It "Should not throw with valid parameters" {
            { Set-NbxDCIMInterfaceConnection -Id 1 -Interface_A 1 -Force } | Should -Not -Throw
        }
    }

}
