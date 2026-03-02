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
            (Get-Command "Add-NbxDCIMFrontPort").Parameters["Device"].Attributes.Where({ $_.TypeID.Name -eq 'ParameterAttribute' }).Mandatory | Should -Contain $true
        }
        
        It "Should have Name parameter as mandatory" {
            (Get-Command "Add-NbxDCIMFrontPort").Parameters["Name"].Attributes.Where({ $_.TypeID.Name -eq 'ParameterAttribute' }).Mandatory | Should -Contain $true
        }
        
        It "Should have Type parameter as mandatory" {
            (Get-Command "Add-NbxDCIMFrontPort").Parameters["Type"].Attributes.Where({ $_.TypeID.Name -eq 'ParameterAttribute' }).Mandatory | Should -Contain $true
        }
        
        It "Should have Rear_Port parameter as mandatory" {
            (Get-Command "Add-NbxDCIMFrontPort").Parameters["Rear_Port"].Attributes.Where({ $_.TypeID.Name -eq 'ParameterAttribute' }).Mandatory | Should -Contain $true
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

    Context "Function behavior" {

        BeforeAll {
            Mock -ModuleName NetboxTools -CommandName InvokeNbxRestMethod -MockWith {
                return [pscustomobject]@{ id = 1; name = 'FrontPort1' }
            }

        }

        It "Should call InvokeNbxRestMethod with POST method" {
            Add-NbxDCIMFrontPort -Device 1 -Name 'FrontPort1' -Type '8p8c' -Rear_Port 1
            Should -Invoke -ModuleName NetboxTools -CommandName InvokeNbxRestMethod -Times 1 -ParameterFilter {
                $Method -eq 'POST' -and $Uri -like '*/dcim/front-ports/*'
            }
        }

        It "Should not throw with valid parameters" {
            { Add-NbxDCIMFrontPort -Device 1 -Name 'FrontPort1' -Type '8p8c' -Rear_Port 1 } | Should -Not -Throw
        }

        AfterAll {
            InModuleScope NetboxTools {
                $script:NbxConfig.Remove('URI')
            }
        }
    }

}
