param(
    $PSM1 = "$PSScriptRoot\..\Source\NetboxTools.psm1"
)

BeforeAll {
    Remove-Module NetboxTools -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
    BeforeAll {

        Mock -ModuleName NetboxTools -CommandName VerifyAPIConnectivity {
            'Success'
        }

        Mock -ModuleName NetboxTools -CommandName Get-NbxCredential {
            @{
                'Username' = 'admin'
                'Password'    = 'passwordvalue'
            }
        }
    }
}

Describe "Add-NbxDCIMRearPort" {

    Context "Function structure and parameters" {

        It "Should be available as a function" {
            Get-Command -Name "Add-NbxDCIMRearPort" -ErrorAction SilentlyContinue | Should -Not -BeNullOrEmpty
        }

        It "Should have parameters (if any)" {
            (Get-Command "Add-NbxDCIMRearPort").Parameters.Keys | Should -Not -BeNullOrEmpty -Because 'most functions have parameters or at least a parameter collection'
        }

        It "Parameter names are PascalCase" {
            (Get-Command "Add-NbxDCIMRearPort").Parameters.Keys | ForEach-Object { $_ | Should -Match '^[A-Z].*' }
        }

        It "Should have required parameters" {
            (Get-Command "Add-NbxDCIMRearPort").Parameters.Keys | Should -Contain "Device"
            (Get-Command "Add-NbxDCIMRearPort").Parameters.Keys | Should -Contain "Name"
            (Get-Command "Add-NbxDCIMRearPort").Parameters.Keys | Should -Contain "Type"
        }
        
    }

    Context "Function behavior and mocking" {
        BeforeAll {
            
            Mock -ModuleName NetboxTools -CommandName InvokeNbxRequest -MockWith {
                return @'
                [
                    {
                    "id": 0,
                    "url": "string",
                    "display_url": "string",
                    "display": "string",
                    "device": {
                        "id": 0,
                        "url": "string",
                        "display": "string",
                        "name": "string",
                        "description": "string"
                    },
                    "module": {
                        "id": 0,
                        "url": "string",
                        "display": "string",
                        "device": {
                        "id": 0,
                        "url": "string",
                        "display": "string",
                        "name": "string",
                        "description": "string"
                        },
                        "module_bay": {
                        "id": 0,
                        "url": "string",
                        "display_url": "string",
                        "display": "string",
                        "name": "string"
                        }
                    },
                    "name": "string",
                    "label": "string",
                    "type": {
                        "value": "8p8c",
                        "label": "8P8C"
                    },
                    "color": "cfd75d",
                    "positions": 1024,
                    "description": "string",
                    "mark_connected": true,
                    "cable": {
                        "id": 0,
                        "url": "string",
                        "display": "string",
                        "label": "string",
                        "description": "string"
                    },
                    "cable_end": "string",
                    "link_peers": [
                        "string"
                    ],
                    "link_peers_type": "string",
                    "tags": [
                        {
                        "id": 0,
                        "url": "string",
                        "display_url": "string",
                        "display": "string",
                        "name": "string",
                        "slug": "z9PZXmnKzmlkvdgaXUK22dtKz4o-ZCZcxCkomi5sRT8T",
                        "color": "9483f5"
                        }
                    ],
                    "custom_fields": {
                        "additionalProp1": "string",
                        "additionalProp2": "string",
                        "additionalProp3": "string"
                    },
                    "created": "2026-01-07T12:37:00.148Z",
                    "last_updated": "2026-01-07T12:37:00.148Z",
                    "_occupied": true
                    }
                ]
'@ | ConvertFrom-Json
            }
        }

        It "Should call InvokeNbxRequest if used by the function" {
            {Add-NbxDCIMRearPort -Device '1' -Name 'RearPort1' -Type '8p8c'} | Should -Not -Throw
        }
    }
}
