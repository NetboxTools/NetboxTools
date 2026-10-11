#Requires -Modules 'InvokeBuild', 'Microsoft.Powershell.PlatyPS', @{ ModuleName = 'Pester'; ModuleVersion = '6.0.0' }, 'PsScriptAnalyzer'

param (
    [string]$Version = '1.0.0',

    # Prerelease label such as 'preview1', publishes the module as a prerelease version (e.g. 2.0.0-preview1)
    [ValidatePattern('^([0-9A-Za-z]+)?$')]
    [string]$Prerelease = ''
)

[string]$ModuleName = 'NetboxTools'
[string]$ModuleSourcePath = "$PSScriptRoot\Source"
[string]$HelpSourcePath = "$PSScriptRoot\Docs\Help"
[string]$BuildSourcePath = "$PSScriptRoot"
[string]$OutputPath = "$PSScriptRoot\Bin\$ModuleName\$Version"

task Clean {
    If (Test-Path -Path $OutputPath) {
        "Removing existing files and folders in $OutputPath"
        Get-ChildItem $OutputPath | Remove-Item -Force -Recurse
    }
    Else {
        "$OutputPath is not present, nothing to clean up."
        $Null = New-Item -ItemType Directory -Path $OutputPath
    }
}

task Unit_Tests {
    .$PSScriptRoot\Tests\TestRunner.ps1 -ModuleLoadPath "$PSScriptRoot\Source\NetboxTools.psm1" -Verbosity Normal -CodeCoveragePath "$PSScriptRoot\Source\Public" 
}

task Unit_Tests_Compiled {
    .$PSScriptRoot\Tests\TestRunner.ps1 -ModuleLoadPath "$OutputPath\NetboxTools.psm1" -Verbosity Normal -CodeCoveragePath "$OutputPath\NetboxTools.psm1"
}

task RunScriptAnalyzer {
    Invoke-ScriptAnalyzer -Path $ModuleSourcePath -Recurse -Severity Error -EnableExit
}

Task Build_Documentation {
    # New-ExternalHelp -Path $HelpSourcePath -OutputPath "$OutputPath\en-US"
    $mdfiles = Measure-PlatyPSMarkdown -Path ".\Docs\Help\*.md"
    $mdfiles | Where-Object Filetype -match 'CommandHelp' |
    Import-MarkdownCommandHelp -Path { $_.FilePath } |
    Export-MamlCommandHelp -OutputFolder "$OutputPath\en-US"
    Move-Item -Path "$OutputPath\en-US\NetboxTools\NetboxTools-Help.xml" -Destination "$OutputPath\en-US\NetboxTools-Help.xml" -Force
    Remove-Item "$OutputPath\en-US\NetboxTools" -Force
}

task Compile_Module {
    $PSM1Name = "$ModuleName.psm1"
    New-Item -Name $PSM1Name -Path $OutputPath -ItemType File -Force 
    $PSM1Path = (Join-Path -Path $OutputPath -ChildPath $PSM1Name)
    
    $PSD1Name = "$ModuleName.psd1"
    New-Item -Name $PSD1Name -Path $OutputPath -ItemType File -Force 
    $PSD1Path = (Join-Path -Path $OutputPath -ChildPath $PSD1Name)

    $ExportedFunctionList = [System.Collections.Generic.List[string]]::new()

    # PreCode
    Get-ChildItem "$BuildSourcePath\Tools\_PreModule*.ps1" | ForEach-Object {
        $FileContent = Get-Content $_.FullName
        "#region PreCode $($_.BaseName)`n"    | Out-File $PSM1Path -Append
        $FileContent                          | Out-File $PSM1Path -Append
        "#endregion PreCode $($_.BaseName)`n" | Out-File $PSM1Path -Append
    }

    # Classes
    Get-ChildItem "$ModuleSourcePath\Classes" *.ps1 | ForEach-Object {
        $FileContent = Get-Content $_.FullName
        "#region $($_.BaseName)`n"      | Out-File $PSM1Path -Append
        $FileContent                    | Out-File $PSM1Path -Append
        "#endregion $($_.BaseName)`n"   | Out-File $PSM1Path -Append
    }

    # Private functions
    Get-ChildItem "$ModuleSourcePath\Private" *.ps1 | ForEach-Object {
        $FileContent = Get-Content $_.FullName
        "#region $($_.BaseName)`n"      | Out-File $PSM1Path -Append
        $FileContent                    | Out-File $PSM1Path -Append
        "#endregion $($_.BaseName)`n"   | Out-File $PSM1Path -Append
    }

    # Public functions
    Get-ChildItem "$ModuleSourcePath\Public" *.ps1 | ForEach-Object {
        $ExportedFunctionList.Add($_.BaseName)

        $FileContent = Get-Content $_.FullName
        "#region $($_.BaseName)`n" | Out-File $PSM1Path -Append
        $FileContent | Out-File $PSM1Path -Append
        "#endregion $($_.BaseName)`n" | Out-File $PSM1Path -Append
    }

    # PostCode
    Get-ChildItem "$BuildSourcePath\Tools\_PostModule*.ps1" | ForEach-Object {
        $FileContent = Get-Content $_.FullName
        "#region PostCode $($_.BaseName)`n"    | Out-File $PSM1Path -Append
        $FileContent                           | Out-File $PSM1Path -Append
        "#endregion PostCode $($_.BaseName)`n" | Out-File $PSM1Path -Append
    }
    
    # Manifest, aliases are defined by the module itself in Tools\_PostModule.ps1
    $ExportedAliasList = @((Import-Module "$ModuleSourcePath\$ModuleName.psm1" -Force -PassThru).ExportedAliases.Keys | Sort-Object)
    Remove-Module $ModuleName -Force
    # Update a copy in the output folder, so the version and prerelease label are never written to the source manifest
    # Update-ModuleManifest requires the version to match the version folder, so set it in the copy first
    (Get-Content -Path "$ModuleSourcePath\$ModuleName.psd1" -Raw) -replace "(?m)^ModuleVersion = '[^']*'", "ModuleVersion = '$Version'" |
        Set-Content -Path $PSD1Path -NoNewline
    $ManifestParameters = @{
        Path              = $PSD1Path
        ModuleVersion     = $Version
        FunctionsToExport = $ExportedFunctionList
        AliasesToExport   = $ExportedAliasList
    }
    if ($Prerelease) {
        $ManifestParameters['Prerelease'] = $Prerelease
    }
    Update-ModuleManifest @ManifestParameters
}

Get-Module -Name $ModuleName | Remove-Module -Force
# Default task :
task . Clean,
Unit_Tests,
RunScriptAnalyzer,
Build_Documentation,
Compile_Module,
Unit_Tests_Compiled