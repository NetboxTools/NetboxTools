# Contributing to NetboxTools

You are more than welcome to contribute to the NetboxTools module, whether it is [Pull Requests](#pull-requests), [Feature Suggestions](#feature-suggestions) or [Bug Reports](#bug-reports)!

## Getting Started

- Fork this repo (see [this forking guide](https://guides.github.com/activities/forking/) for more information).
- Checkout the repo locally with `git clone git@github.com:{your_username}/NetboxTools.git`.
- If you haven't already, you will need the [Microsoft.Powershell.PlatyPS](https://github.com/PowerShell/platyPS) PowerShell Module to generate command help and docs.

## Developing

### Structure

The repo is organized as below:

- **Private** (`Source/Private`): All private functions used by the module.
- **Public** (`Source/Public`): All functions exported by the module.
- **Classes** (`Source/Classes`): All classes by the module.
- **Tests** (`Tests`): Pester tests executed at Pull Request.
- **Help** (`Docs\Help`): Markdown help files for external help.

### Running the module locally

- Import the module:

```powershell
Import-Module .\Source\NetboxTools.psd1
```

### Cmdlet conventions

All cmdlets work the same way, see [Working with the cmdlets](README.md#working-with-the-cmdlets). When adding a cmdlet,
start from an existing cmdlet of the same verb, for example `Get-NbxDCIMSite`, `New-NbxDCIMSite`, `Set-NbxDCIMSite` and
`Remove-NbxDCIMSite`, and keep the same structure:

- `Get-*` has an `Id` parameter set (`-Id`, from the pipeline) and a `Query` parameter set (`-Name` or the main field,
  `-Query`, `-Limit`).
- `New-*` binds parameters by property name from the pipeline (`ValueFromPipelineByPropertyName`) and has `-OptionalAttribute`.
- `Set-*` takes `-Id` from the pipeline and has `-OptionalAttribute`, `-PassThru` and `-Force`.
- `Remove-*` takes `-Id` from the pipeline, has `ConfirmImpact = 'High'` and `-Force`.
- `New-*`, `Set-*` and `Remove-*` support `-WhatIf` and `-Confirm` (`SupportsShouldProcess`).
- Parameter names are PascalCase without underscores. When the NetBox field name differs from the lower cased parameter
  name, the first alias is the NetBox field name, e.g. `[Alias('device_type')]` on `-DeviceType`. The request body is
  built from these names by `ConvertToNbxBody`. Aliases kept for backward compatibility must not be all lower case.
- References to other objects use `[NbxIdTransformation('<endpoint>')]`, so they accept IDs and NetBox objects, and
  objects of another type are rejected. Choice fields use `[NbxChoiceTransformation()]` with `[ArgumentCompletions()]`
  instead of `[ValidateSet()]`, as NetBox choices can be extended.
- All requests go through the private function `InvokeNbxRestMethod`, which handles authentication, pagination and errors.
- Fields and endpoints are verified against the NetBox API serializers of the supported NetBox version.

### Tests

The NetboxTools module is developed using Test-driven development(TDD) where we aim for full test coverage for all our functions. Make sure that all new features and updates are covered by Pester tests. All tests will be executed when a Pull Request is submitted as a build validation step. PRs with failing tests will not be approved.

[Pester](https://github.com/pester/Pester) is the ubiquitous test and mock framework for PowerShell. The tests require Pester 6.

```powershell
Install-Module -Name Pester -MinimumVersion 6.0.0 -Scope CurrentUser
.\Tests\TestRunner.ps1 -ModuleLoadPath .\Source\NetboxTools.psm1 -CodeCoveragePath .\Source\Public
```

- Every public function has a test file `Tests\<Function>.Tests.ps1`.
- Tests mock `Invoke-RestMethod`, the boundary to the NetBox API, and not the module's own functions, so that the URIs,
  query strings and request bodies sent to NetBox are tested. `Tests\TestHelpers.ps1` sets up a test connection
  (`Initialize-NbxTestConnection`) and returns responses like NetBox does (`New-NbxTestResponse`).
- `Tests\Conventions.Tests.ps1` checks the cmdlet conventions above for all public functions, including comment-based
  help for every parameter and PSScriptAnalyzer.

Exclusion of standard tests can be done using the SkipTest attribute.

```PowerShell
[SkipTest('TestName')]
```

Introducing additional exclusions should be discussed in a GitHub issue before implementation.

### Microsoft.Powershell.PlatyPS

[Microsoft.Powershell.PlatyPS](https://github.com/PowerShell/platyPS) is used to write the external help in markdown. When contributing always make sure that the changes are added to the help file.

#### Quickstart

- Install the Microsoft.Powershell.PlatyPS module from the [PowerShell Gallery](https://powershellgallery.com):

```powershell
Install-Module -Name Microsoft.Powershell.PlatyPS -Scope CurrentUser
Import-Module Microsoft.Powershell.PlatyPS
```

Write the help as comment-based help in the function (synopsis, description, every parameter, examples, inputs and
outputs) and generate the markdown from it.

- Create initial Markdown help file for `NetboxTools` module (This will only create help files for new commands, existing files will not be overwritten):

```powershell
# you should have module imported in the session
Import-Module .\Source\NetboxTools.psd1
New-MarkdownCommandHelp -CommandInfo (Get-Command My-NewCommand) -OutputFolder .\Docs\Help
```
Move the newly created markdown from `.\Docs\Help\NetboxTools` to `.\Docs\Help` folder and populate `{{ ... }}` placeholders with missed help content, such as the INPUTS and OUTPUTS descriptions and the ALIASES section.

- If you've made a lot of changes to the module code, you can easily update the markdown file(s) automatically with:

```powershell
# re-import your module with latest changes
Import-Module .\Source\NetboxTools.psd1 -Force
Update-MarkdownCommandHelp -Path .\Docs\Help\*.md
```

## Releasing

Publishing a GitHub release runs the `build and release` workflow, which builds, tests and publishes the module to the
PowerShell Gallery. The version is taken from the release tag:

- `v2.0.0` publishes version 2.0.0.
- `v2.0.0-preview1` publishes the prerelease version 2.0.0-preview1. Mark the GitHub release as a pre-release.
  Prerelease labels may only contain letters and digits (`preview1`, not `preview.1`). Prereleases are only installed
  with `Install-Module NetboxTools -AllowPrerelease`.

Versions published to the PowerShell Gallery can be unlisted but not deleted, and a version number can not be reused.

## Pull Requests

If you like to start contributing to the NetboxTools module. Please make sure that there is a related issue to link to your PR.

- Make sure that the issue is tagged in the PR, e.g. "fixes #45"
- Write a short but informative commit message, it will be added to the release notes.

## Feature Suggestions

- Please first search [Open Issues](https://github.com/NetboxTools/NetboxTools/issues) before opening an issue to check whether your feature has already been suggested. If it has, feel free to add your own comments to the existing issue.
- Ensure you have included a "What?" - what your feature entails, being as specific as possible, and giving mocked-up syntax examples where possible.
- Ensure you have included a "Why?" - what the benefit of including this feature will be.
- Use the "Feature Request" issue template [here](https://github.com/NetboxTools/NetboxTools/issues/new/choose) to submit your request.

## Bug Reports

- Please first search [Open Issues](https://github.com/NetboxTools/NetboxTools/issues) before opening an issue, to see if it has already been reported.
- Try to be as specific as possible, including the version of the NetboxTools PowerShell module, PowerShell version and OS used to reproduce the issue, and any example files or snippets of NetboxTools code needed to reproduce it.
- Use the "Bug Report" issue template [here](https://github.com/NetboxTools/NetboxTools/issues/new/choose) to submit your request.
