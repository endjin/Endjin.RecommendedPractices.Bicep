[CmdletBinding(SupportsShouldProcess)]
param (
    [Parameter(Mandatory = $true)]
    [string] $DisplayName,

    [Parameter()]
    [string] $ReplyUrlsDelimited,

    [Parameter(Mandatory = $true)]
    [string] $AadTenantId,

    [string] $Delimeter = ",",

    [Parameter()]
    [string] $AppUri,

    [Parameter()]
    [bool] $EnableAccessTokenIssuance = $false,

    [Parameter()]
    [bool] $EnableIdTokenIssuance = $false,

    [Parameter()]
    [string] $MicrosoftGraphScopeIdsToGrantDelimited,

    [Parameter()]
    [string] $MicrosoftGraphAppRoleIdsToGrantDelimited,

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
$splitReplyUrls = $ReplyUrlsDelimited -split $Delimeter
$ReplyUrls = $splitReplyUrls[0] -eq "" ? @() : $splitReplyUrls

$splitScopeIdGrants = $MicrosoftGraphScopeIdsToGrantDelimited -split $Delimeter
$MicrosoftGraphScopeIdsToGrant = $splitScopeIdGrants[0] -eq "" ? @() : $splitScopeIdGrants

$splitAppRoleIdGrants = $MicrosoftGraphAppRoleIdsToGrantDelimited -split $Delimeter
$MicrosoftGraphAppRoleIdsToGrant = $splitAppRoleIdGrants[0] -eq "" ? @() : $splitAppRoleIdGrants

# Configure the Azure App Registration
$app = Assert-CorvusAzureAdApp `
            -DisplayName $DisplayName `
            -ReplyUrls $ReplyUrls `
            -AppUri $AppUri `
            -EnableAccessTokenIssuance:$EnableAccessTokenIssuance `
            -EnableIdTokenIssuance:$EnableIdTokenIssuance `
            -Verbose

# Configure any required MS Graph API permissions
if ($MicrosoftGraphScopeIdsToGrant -or $MicrosoftGraphAppRoleIdsToGrant) {
    Write-Host "Configuring API permissions"
    $msGraphAccessRequirements = @()
    foreach ($scopeId in $MicrosoftGraphScopeIdsToGrant) {
        $msGraphAccessRequirements += @{
            Id = $scopeId
            Type = "Scope"
        }
    }
    foreach ($appRoleId in $MicrosoftGraphAppRoleIdsToGrant) {
        $msGraphAccessRequirements += @{
            Id = $appRoleId
            Type = "Role"
        }
    }
    Write-Verbose "msGraphAccessRequirements: $($msGraphAccessRequirements | ConvertTo-Json -Depth 10)"
    
    $app = $app | Assert-CorvusRequiredResourceAccessContains `
                        -ResourceAppId "00000003-0000-0000-c000-000000000000" `
                        -AccessRequirements $msGraphAccessRequirements 
}

Write-Host "App Registration Details:"
$app | ConvertTo-Json -Depth 100 | Write-Host

# Set the deployment script outputs
$DeploymentScriptOutputs = @{
    applicationId = $app.AppId
    objectId      = $app.Id
}