<#
    This script publishes Bicep modules to a given Azure Container Registry instance.

    The registry must exist.

#>

param (
    # Path to Bicep modules
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


try {
    # Recursively check for *.bicep files under bicep module path.
    # The default will be set to the root of the bicep modules
    # If I find a bicep file then push to ACR under `/modules/<path>/<to>/<module>:<tag>`

    $treeDir = Get-ChildItem -Path $BicepPath -Filter "*.bicep" -Recurse;
    foreach ($bicepFile in $treeDir) {
        if (Test-Path $bicepFile) {
            $acrPath = $bicepFile.FullName.Replace($BicepPath, "").Replace("\", "/").Replace(".bicep", "")

            $artifactRef = "br:$($AcrName).azurecr.io/examples/$($acrPath):$($Tag)";
            # TODO: what if we aren't on a windows machine?
            if (!$WhatIf) {
                bicep.exe publish $bicepFile --target $artifactRef;
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