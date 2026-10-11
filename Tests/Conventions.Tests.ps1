param(
    $PSM1 = "$PSScriptRoot\..\Source\NetboxTools.psm1"
)

<#
    Conventions that apply to all public cmdlets, so that all cmdlets work the same way.
#>

BeforeDiscovery {
    Remove-Module NetboxTools -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force

    $Commands = Get-Command -Module NetboxTools -CommandType Function | ForEach-Object {
        @{ Name = $_.Name; Verb = $_.Verb }
    }
    $ChangingCommands = $Commands | Where-Object { $_.Verb -in 'New', 'Set', 'Remove' -and $_.Name -ne 'Set-NbxCipherSSL' }
    $IdCommands = $Commands | Where-Object { (Get-Command $_.Name).Parameters.ContainsKey('Id') -and $_.Verb -ne 'Get' -or
        ($_.Verb -eq 'Get' -and (Get-Command $_.Name).ParameterSets.Name -contains 'Id') }
    # All New cmdlets create NetBox objects, Set cmdlets with -Id update NetBox objects
    $NewCommands = $Commands | Where-Object Verb -EQ 'New'
    $RemoveCommands = $Commands | Where-Object Verb -EQ 'Remove'
    $SetObjectCommands = $Commands | Where-Object { $_.Verb -eq 'Set' -and (Get-Command $_.Name).Parameters.ContainsKey('Id') }

    $Groups = @(
        @{ Group = 'all'; Count = @($Commands).Count }
        @{ Group = 'state changing'; Count = @($ChangingCommands).Count }
        @{ Group = 'Id'; Count = @($IdCommands).Count }
        @{ Group = 'New'; Count = @($NewCommands).Count }
        @{ Group = 'Remove'; Count = @($RemoveCommands).Count }
        @{ Group = 'Set'; Count = @($SetObjectCommands).Count }
    )
}

Describe 'Conventions test discovery' {
    It 'Finds cmdlets for the <Group> conventions' -ForEach $Groups {
        $Count | Should -BeGreaterThan 0 -Because 'an empty group silently skips its conventions'
    }
}

BeforeAll {
    Remove-Module NetboxTools -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force

    function Get-CmdletBinding ($Name) {
        (Get-Command $Name).ScriptBlock.Attributes.Where({ $_ -is [System.Management.Automation.CmdletBindingAttribute] })[0]
    }
}

Describe 'Conventions for <Name>' -ForEach $Commands {
    BeforeAll {
        $Command = Get-Command $Name
        $Help = Get-Help $Name -Full
        # Hidden parameters (DontShow) are only kept for backward compatibility
        $Parameters = $Command.Parameters.Values | Where-Object {
            $_.Name -notin [System.Management.Automation.Cmdlet]::CommonParameters + [System.Management.Automation.Cmdlet]::OptionalCommonParameters -and
            -not $_.Attributes.Where({ $_ -is [System.Management.Automation.ParameterAttribute] -and $_.DontShow })
        }
    }

    It 'Uses an approved verb' {
        $Verb | Should -BeIn (Get-Verb).Verb
    }

    It 'Uses the Nbx prefix and a singular noun' {
        $Command.Noun | Should -Match '^Nbx[A-Z]'
        $Command.Noun | Should -Not -Match '(?<!s)s$' -Because 'nouns should be singular'
    }

    It 'Is an advanced function' {
        Get-CmdletBinding $Name | Should -Not -BeNullOrEmpty
    }

    It 'Declares its output type' {
        $Command.OutputType | Should -Not -BeNullOrEmpty
    }

    It 'Has a synopsis, a description and an example' {
        $Help.Synopsis | Should -Not -BeNullOrEmpty
        $Help.Synopsis | Should -Not -Match "^\s*$Name\s"
        ($Help.description.Text -join '') | Should -Not -BeNullOrEmpty
        @($Help.examples.example).Count | Should -BeGreaterThan 0
    }

    It 'Documents all parameters' {
        foreach ($Parameter in $Parameters) {
            $ParameterHelp = $Help.parameters.parameter | Where-Object Name -EQ $Parameter.Name
            ($ParameterHelp.description.Text -join '') | Should -Not -BeNullOrEmpty -Because "parameter '$($Parameter.Name)' should be documented"
        }
    }

    It 'Has PascalCase parameter names without underscores' {
        foreach ($Parameter in $Parameters) {
            $Parameter.Name | Should -MatchExactly '^[A-Z][A-Za-z0-9]*$'
        }
    }

    It 'Has a test file' {
        Test-Path -Path "$PSScriptRoot\$Name.Tests.ps1" -PathType Leaf | Should -BeTrue
    }
}

Describe 'Cmdlets that change state: <Name>' -ForEach $ChangingCommands {
    It 'Supports -WhatIf and -Confirm' {
        (Get-CmdletBinding $Name).SupportsShouldProcess | Should -BeTrue
    }
}

Describe 'Remove cmdlets: <Name>' -ForEach $RemoveCommands {
    It 'Has a high confirm impact and a -Force parameter' {
        (Get-CmdletBinding $Name).ConfirmImpact | Should -Be 'High'
        Get-Command $Name | Should -HaveParameter 'Force' -Type [switch]
    }
}

Describe 'Pipeline input by Id: <Name>' -ForEach $IdCommands {
    It 'Accepts IDs and NetBox objects from the pipeline' {
        $Id = (Get-Command $Name).Parameters['Id']
        $Id.Attributes.Where({ $_ -is [System.Management.Automation.ParameterAttribute] }).ValueFromPipeline | Should -Contain $true
        $Id.Attributes.Where({ $_.GetType().Name -eq 'NbxIdTransformation' }) | Should -Not -BeNullOrEmpty
    }
}

Describe 'New cmdlets: <Name>' -ForEach $NewCommands {
    It 'Accepts objects with matching properties from the pipeline' {
        $Pipeline = (Get-Command $Name).Parameters.Values | Where-Object {
            $_.Attributes.Where({ $_ -is [System.Management.Automation.ParameterAttribute] -and $_.ValueFromPipelineByPropertyName })
        }
        $Pipeline | Should -Not -BeNullOrEmpty
    }

    It 'Has an OptionalAttribute parameter for fields without a parameter' {
        Get-Command $Name | Should -HaveParameter 'OptionalAttribute' -Type [hashtable]
    }
}

Describe 'Set cmdlets: <Name>' -ForEach $SetObjectCommands {
    It 'Has -PassThru, -Force and -OptionalAttribute parameters' {
        Get-Command $Name | Should -HaveParameter 'PassThru' -Type [switch]
        Get-Command $Name | Should -HaveParameter 'Force' -Type [switch]
        Get-Command $Name | Should -HaveParameter 'OptionalAttribute' -Type [hashtable]
    }
}

Describe 'PSScriptAnalyzer' -Tag 'ScriptAnalyzer' {
    BeforeDiscovery {
        $AnalyzerAvailable = [bool](Get-Module -ListAvailable PSScriptAnalyzer)
    }

    It 'Reports no errors or warnings for the source' -Skip:(-not $AnalyzerAvailable) {
        $SourcePath = Split-Path -Path $PSM1 -Parent
        $Results = Invoke-ScriptAnalyzer -Path $SourcePath -Recurse -Severity Error, Warning
        $Results | ForEach-Object { "$($_.ScriptName):$($_.Line) $($_.RuleName) $($_.Message)" } | Should -BeNullOrEmpty
    }
}
