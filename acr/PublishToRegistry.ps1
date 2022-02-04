<#
    This script publishes Bicep modules to a given Azure Container Registry instance.

    The registry must exist.

#>

param (
    # Overrides the default path to bicep modules, located at ../modules/
    # NOTE: the path should be an absolute path AND end with a trailing slash
    [Parameter()]
    [string]
    $BicepPath,

    # Version tag
    # TODO: Automatic versioning?
    [Parameter(Mandatory = $true)]
    [string]
    $Tag,

    # The name of the ACR container to deploy
    [Parameter(Mandatory = $true)]
    [string]
    $AcrName,

    [Parameter()]
    [switch]
    $WhatIf
)

$ErrorActionPreference = $ErrorAction ? $ErrorAction : 'Stop';
$InformationPreference = $InformationAction ? $InformationAction : 'Continue';
# Either specify an absolute path to override default path

if (!$BicepPath) {
    $BicepPath = Join-Path $PSScriptRoot "../modules/" | Resolve-Path 
}


try {
    # Recursively check for *.bicep files under bicep module path.
    # The default will be set to the root of the bicep modules
    # If I find a bicep file then push to ACR under `/modules/<path>/<to>/<module>:<tag>`

    $treeDir = Get-ChildItem -Path $BicepPath -Filter "*.bicep" -Recurse;
    foreach ($bicepFile in $treeDir) {
        if (Test-Path $bicepFile) {
            # Repository components must match `[a-z0-9]+([._-][a-z0-9]+)*`
            $acrPath = $bicepFile.FullName.Replace($BicepPath, "").Replace("\", "/").Replace(".bicep", "").ToLower()

            $artifactRef = "br:$($AcrName).azurecr.io/bicep/modules/$($acrPath):$($Tag)";
            if (!$WhatIf) {
                bicep publish $bicepFile --target $artifactRef;
            }
            Write-Output $artifactRef;
        }   
    }
}
catch {
    Write-Error $_.Exception.Message -ErrorAction Continue;
    Write-Warning $_.ScriptStackTrace;
    Write-Error "Unhandled exception - check previous messages - processing will continue" -ErrorAction Continue;
}
finally {

}