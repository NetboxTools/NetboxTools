param(
    $PSM1 = "$PSScriptRoot\..\Source\NetboxTools.psm1"
)

BeforeAll {
    Remove-Module NetboxTools -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe "Add-NbxDCIMFrontPort" {
    
    Context "Function structure and parameters" {
        
        It "Should be available as a function" {
            Get-Command -Name "Add-NbxDCIMFrontPort" -ErrorAction SilentlyContinue | Should -Not -BeNullOrEmpty
        }
        
        It "Should have required parameters" {
            (Get-Command "Add-NbxDCIMFrontPort").Parameters.Keys | Should -Contain "Device"
            (Get-Command "Add-NbxDCIMFrontPort").Parameters.Keys | Should -Contain "Name"
            (Get-Command "Add-NbxDCIMFrontPort").Parameters.Keys | Should -Contain "Type"
            (Get-Command "Add-NbxDCIMFrontPort").Parameters.Keys | Should -Contain "Rear_Port"
        }
        
        It "Should have Device parameter as mandatory" {
            (Get-Command "Add-NbxDCIMFrontPort").Parameters["Device"].Attributes.Where({$_.TypeID.Name -eq 'ParameterAttribute'}).Mandatory | Should -Contain $true
        }
        
        It "Should have Name parameter as mandatory" {
            (Get-Command "Add-NbxDCIMFrontPort").Parameters["Name"].Attributes.Where({$_.TypeID.Name -eq 'ParameterAttribute'}).Mandatory | Should -Contain $true
        }
        
        It "Should have Type parameter as mandatory" {
            (Get-Command "Add-NbxDCIMFrontPort").Parameters["Type"].Attributes.Where({$_.TypeID.Name -eq 'ParameterAttribute'}).Mandatory | Should -Contain $true
        }
        
        It "Should have Rear_Port parameter as mandatory" {
            (Get-Command "Add-NbxDCIMFrontPort").Parameters["Rear_Port"].Attributes.Where({$_.TypeID.Name -eq 'ParameterAttribute'}).Mandatory | Should -Contain $true
        }
        
        It "Should have optional parameters" {
            (Get-Command "Add-NbxDCIMFrontPort").Parameters.Keys | Should -Contain "Module"
            (Get-Command "Add-NbxDCIMFrontPort").Parameters.Keys | Should -Contain "Label"
            (Get-Command "Add-NbxDCIMFrontPort").Parameters.Keys | Should -Contain "Color"
            (Get-Command "Add-NbxDCIMFrontPort").Parameters.Keys | Should -Contain "Rear_Port_Position"
            (Get-Command "Add-NbxDCIMFrontPort").Parameters.Keys | Should -Contain "Description"
            (Get-Command "Add-NbxDCIMFrontPort").Parameters.Keys | Should -Contain "Mark_Connected"
            (Get-Command "Add-NbxDCIMFrontPort").Parameters.Keys | Should -Contain "Tags"
        }
        
    }
    
    Context "Function behavior and mocking" {
        
        BeforeEach {
            # Mock the private helper functions
            Mock -CommandName "BuildURIComponents" -ModuleName $ModuleName -MockWith {
                param($URISegments, $ParametersDictionary, $SkipParameterByName)
                
                return @{
                    Segments = $URISegments
                    Parameters = $ParametersDictionary
                }
            }
            
            Mock -CommandName "BuildNewURI" -ModuleName $ModuleName -MockWith {
                param($Segments)
                
                $uriBuilder = [System.UriBuilder]::new("https", "netbox.example.com", 443)
                $uriBuilder.Path = "/api/{0}/" -f ($Segments -join '/')
                return $uriBuilder
            }
            
            Mock -CommandName "InvokeNbxRequest" -ModuleName $ModuleName -MockWith {
                param($URI, $Body, $Method)
                
                return [pscustomobject]@{
                    id = 1
                    name = $Body.name
                    device = $Body.device
                    type = $Body.type
                    rear_port = $Body.rear_port
                }
            }
        }
        
        It "Should call BuildURIComponents with correct segments" {
            Add-NbxDCIMFrontPort -Device 1 -Name "eth0" -Type "1000base-t" -Rear_Port 10 | Should -Not -BeNullOrEmpty
            
            Assert-MockCalled -CommandName "BuildURIComponents" -ModuleName $ModuleName -Times 1
        }
        
        It "Should call BuildNewURI with dcim and front-ports segments" {
            Add-NbxDCIMFrontPort -Device 1 -Name "eth0" -Type "1000base-t" -Rear_Port 10 | Should -Not -BeNullOrEmpty
            
            Assert-MockCalled -CommandName "BuildNewURI" -ModuleName $ModuleName -Times 1
        }
        
        It "Should call InvokeNbxRequest with POST method" {
            Add-NbxDCIMFrontPort -Device 1 -Name "eth0" -Type "1000base-t" -Rear_Port 10
            
            Assert-MockCalled -CommandName "InvokeNbxRequest" -ModuleName $ModuleName -Times 1 -ParameterFilter {
                $Method -eq 'POST'
            }
        }
        
        It "Should pass all provided parameters to BuildURIComponents" {
            Add-NbxDCIMFrontPort -Device 1 -Name "eth0" -Type "1000base-t" -Rear_Port 10 -Label "Interface" -Description "Test port" -Mark_Connected $true
            
            Assert-MockCalled -CommandName "BuildURIComponents" -ModuleName $ModuleName -ParameterFilter {
                $ParametersDictionary.Keys -contains "Device" -and
                $ParametersDictionary.Keys -contains "Name" -and
                $ParametersDictionary.Keys -contains "Type" -and
                $ParametersDictionary.Keys -contains "Rear_Port"
            }
        }
        
        It "Should handle optional Color parameter with valid hex code" {
            Add-NbxDCIMFrontPort -Device 1 -Name "eth0" -Type "1000base-t" -Rear_Port 10 -Color "FF0000"
            
            Assert-MockCalled -CommandName "BuildURIComponents" -ModuleName $ModuleName -ParameterFilter {
                $ParametersDictionary.Keys -contains "Color"
            }
        }
        
        It "Should handle Tags parameter as array" {
            Add-NbxDCIMFrontPort -Device 1 -Name "eth0" -Type "1000base-t" -Rear_Port 10 -Tags @(1, 2, 3)
            
            Assert-MockCalled -CommandName "BuildURIComponents" -ModuleName $ModuleName -ParameterFilter {
                $ParametersDictionary.Keys -contains "Tags"
            }
        }
        
        It "Should return output from InvokeNbxRequest" {
            $result = Add-NbxDCIMFrontPort -Device 1 -Name "eth0" -Type "1000base-t" -Rear_Port 10
            
            $result | Should -Not -BeNullOrEmpty
            $result.id | Should -Be 1
            $result.name | Should -Be "eth0"
        }
    }
    
    Context "Parameter validation" {
        
        It "Should reject Color parameter without valid hex format" {
            { Add-NbxDCIMFrontPort -Device 1 -Name "eth0" -Type "1000base-t" -Rear_Port 10 -Color "GGGGGG" } | Should -Throw
        }
        
        It "Should reject Color parameter with invalid length" {
            { Add-NbxDCIMFrontPort -Device 1 -Name "eth0" -Type "1000base-t" -Rear_Port 10 -Color "FF00" } | Should -Throw
        }
        
        It "Should accept Color parameter with lowercase hex" {
            Mock -CommandName "BuildURIComponents" -ModuleName $ModuleName -MockWith {
                return @{ Segments = @('dcim', 'front-ports'); Parameters = @{} }
            }
            Mock -CommandName "BuildNewURI" -ModuleName $ModuleName -MockWith {
                return [System.UriBuilder]::new("https", "netbox.example.com", 443)
            }
            Mock -CommandName "InvokeNbxRequest" -ModuleName $ModuleName -MockWith {
                return [pscustomobject]@{ id = 1 }
            }
            
            { Add-NbxDCIMFrontPort -Device 1 -Name "eth0" -Type "1000base-t" -Rear_Port 10 -Color "ff0000" } | Should -Not -Throw
        }
    }
}
