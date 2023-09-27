<#
.SYNOPSIS
    Runs a Bicep Module flavoured build process.
.DESCRIPTION
    This script was scaffolded using a template from the Endjin.RecommendedPractices.Build PowerShell module.
    It uses the InvokeBuild module to orchestrate an opinonated build process for publishing Bicep modules.
.EXAMPLE
    PS C:\> ./build.ps1
    Downloads any missing module dependencies (Endjin.RecommendedPractices.Build & InvokeBuild) and executes
    the build process.
.PARAMETER Tasks
    Optionally override the default task executed as the entry-point of the build.
.PARAMETER SourcesDir
    The path where the Bicep 'modules' folder structure is located, defaults to the current working directory.
.PARAMETER LogLevel
    The logging verbosity.
.PARAMETER BuildModulePath
    The path to import the Endjin.RecommendedPractices.Build module from. This is useful when
    testing pre-release versions of the Endjin.RecommendedPractices.Build that are not yet
    available in the PowerShell Gallery.
.PARAMETER BuildModuleVersion
    The version of the Endjin.RecommendedPractices.Build module to import. This is useful when
    testing pre-release versions of the Endjin.RecommendedPractices.Build that are not yet
    available in the PowerShell Gallery.
#>
[CmdletBinding()]
param (
    [Parameter(Position=0)]
    [string[]] $Tasks = @("."),

    [Parameter()]
    [string] $SourcesDir = $PWD,

    [Parameter()]
    [ValidateSet("minimal","normal","detailed")]
    [string] $LogLevel = "minimal",

    [Parameter()]
    [string] $BuildModulePath,

    [Parameter()]
    [version] $BuildModuleVersion = "1.3.11"
)

$ErrorActionPreference = $ErrorActionPreference ? $ErrorActionPreference : 'Stop'
$InformationPreference = 'Continue'

$here = Split-Path -Parent $PSCommandPath

#region InvokeBuild setup
if (!(Get-Module -ListAvailable InvokeBuild)) {
    Install-Module InvokeBuild -RequiredVersion 5.7.1 -Scope CurrentUser -Force -Repository PSGallery
}
Import-Module InvokeBuild
# This handles calling the build engine when this file is run like a normal PowerShell script
# (i.e. avoids the need to have another script to setup the InvokeBuild environment and issue the 'Invoke-Build' command )
if ($MyInvocation.ScriptName -notlike '*Invoke-Build.ps1') {
    try {
        Invoke-Build $Tasks $MyInvocation.MyCommand.Path @PSBoundParameters
    }
    catch {
        $_.ScriptStackTrace
        throw
    }
    return
}
#endregion

#region Import shared tasks and initialise build framework
if (!($BuildModulePath)) {
    if (!(Get-Module -ListAvailable Endjin.RecommendedPractices.Build | ? { $_.Version -eq $BuildModuleVersion })) {
        Write-Information "Installing 'Endjin.RecommendedPractices.Build' module..."
        Install-Module Endjin.RecommendedPractices.Build -RequiredVersion $BuildModuleVersion -Scope CurrentUser -Force -Repository PSGallery
    }
    $BuildModulePath = "Endjin.RecommendedPractices.Build"
}
else {
    Write-Information "BuildModulePath: $BuildModulePath"
}
Import-Module $BuildModulePath -RequiredVersion $BuildModuleVersion -Force

# Load the build process & tasks
. Endjin.RecommendedPractices.Build.tasks
#endregion


#
# Build process control options
#
$SkipInit = $false
$SkipVersion = $true    # Disables repo-level versiong. Bicep modules use the 'nbgv' tool to version individual modules
$SkipBuild = $false
$CleanBuild = $false
$SkipTest = $false
$SkipTestReport = $false
$SkipPackage = $false
$SkipPublish = $false

#
# Build process configuration
#
$RequiredBicepCliVersion = "0.15.31"               # ensures the build uses a consistent version of the Bicep tooling
$BicepModulesDir = Join-Path $SourcesDir "modules" # sets location of folder containing the Bicep modules
$BaseBranch = "origin/main"                        # sets the branch used to compare which Bicep modules have changed for local builds
$BicepRegistryFqdn = "endjintestacr.azurecr.io"    # the ACR used when publishing modules from local builds
$RegistryPath = "bicep"                            # sets the base path in the registry where Bicep modules will be published
$OverwriteTag = $false                             # when true, existing git tags for a given module will be updated
$AlwaysTag = $false                                # when true, overrides default behaviour of only tagging stable version numbers

# Synopsis: Build and Validate modules, regenerate module documentation
task . LocalBicepBuild

# build extensibility tasks
task RunFirst {}
task PreInit {}
task PostInit {}
task PreBuild {}
task PostBuild {}
task PreTest {}
task PostTest {}
task PreTestReport {}
task PostTestReport {}
task PrePackage {}
task PostPackage {}
task PrePublish {}
task PostPublish {}
task RunLast {}
