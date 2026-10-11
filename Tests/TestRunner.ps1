#Requires -Modules @{ ModuleName = 'Pester'; ModuleVersion = '6.0.0' }

param (
    [Parameter(Mandatory)]
    [string]$ModuleLoadPath,
    
    [string[]]$TestsPath = $PSScriptRoot,
    
    [string]$Verbosity = 'Detailed',

    [string[]]$CodeCoveragePath,

    [switch]$TestResults,

    [switch]$PassThru
)

[array]$AllTests = Get-ChildItem -Path $TestsPath -Filter *.Tests.ps1 | Select-Object -ExpandProperty FullName

$PesterConfiguration = New-PesterConfiguration
$PesterConfiguration.Output.Verbosity = $Verbosity

if ($PassThru.IsPresent) {
    # The caller inspects the result
    $pesterConfiguration.Run.PassThru = $True
}
else {
    # Fail the build and the CI run when tests fail, Invoke-Pester does not by default
    $PesterConfiguration.Run.Throw = $true
}

$ModuleLoadData = @{
    PSM1 = Get-Item $ModuleLoadPath | Select-Object -ExpandProperty FullName
}

$container = New-PesterContainer -Path $AllTests -Data $ModuleLoadData
$PesterConfiguration.Run.Container = $container

if ($CodeCoveragePath) {      
    [array]$AllCodeCoverageFiles = Get-ChildItem -Path $CodeCoveragePath | Select-Object -ExpandProperty FullName

    $PesterConfiguration.CodeCoverage.Enabled = $true
    $PesterConfiguration.CodeCoverage.Path = $AllCodeCoverageFiles
    $PesterConfiguration.CodeCoverage.CoveragePercentTarget = 75
    $PesterConfiguration.CodeCoverage.OutputPath = "./coverage.xml"
    $PesterConfiguration.CodeCoverage.OutputFormat = 'Cobertura'
}

if ($TestResults.IsPresent) {
    $PesterConfiguration.TestResult.Enabled = $true
    $PesterConfiguration.TestResult.OutputFormat = 'JUnitXml'
}

Invoke-Pester -Configuration $PesterConfiguration 