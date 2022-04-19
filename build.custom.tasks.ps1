#
# Use this file to customise the build process
#

task findAllModules {
    $script:allModules = gci ./modules/main.bicep -Recurse
}

task validateBicepModules findAllModules,{
    foreach ($module in $allModules) {
        Push-Location (Split-Path -Parent $module)
        & brm validate
    }
}