[CmdletBinding(SupportsShouldProcess)]
param (
    [Parameter(Mandatory = $true)]
    [string] $AadTenantId,

    [Parameter(Mandatory = $true)]
    [string] $GroupName,

    [Parameter()]
    [string] $RequiredMembersDelimited,

    [string] $Delimeter = ",",

    [Parameter()]
    [bool] $StrictMode,

    [Parameter()]
    [string] $CorvusModulePackageVersion = "0.4.6",

    [Parameter()]
    [bool] $CorvusModuleAllowPrerelase = $false
)
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

# Debug which Az PowerShell version is being used
Get-Module Az -ListAvailable | select Name,Version | ft | out-string | write-host
Import-Module Az.Resources -PassThru | select Name,Version | ft | out-string | write-host

Install-Module Corvus.Deployment -RequiredVersion $CorvusModulePackageVersion -AllowPrerelease:$CorvusModuleAllowPrerelase -Scope CurrentUser -Repository PSGallery -Force
Import-Module Corvus.Deployment -Force -PassThru | select Name,Version | ft | out-string | write-host
Connect-CorvusAzure -SkipAzureCli -AadTenantId $AadTenantId -TenantOnly

# Parse the delimited parameter into arrays
$splitRequiredMembers = $RequiredMembersDelimited -split $Delimeter
$requiredMembers = $splitRequiredMembers[0] -eq "" ? @() : $splitRequiredMembers

# Assert group membership
Assert-CorvusAzureAdGroupMembership -Name $GroupName -RequiredMembers $requiredMembers -StrictMode $StrictMode