#
# Use this file to customise the build process
#

# Synopsis: Lints the Bicep files and builds the ARM template
task ValidateBicepFiles {

    $failBuild = $false
    $filesToValidate = gci -recurse -filter *.bicep -path ./modules

    foreach ($bicepFile in $filesToValidate) {
        Write-Build Green "Building $bicepFile..."
        & az bicep build -f $bicepFile
        if ($LASTEXITCODE -ne 0)
        {
            $failBuild = $true
        }
    }

    if ($failBuild) {
        throw "Bicep build error(s) - check preceeding log messages"
    }
    else {
        Write-Build Green "Bicep files OK"
    }
}

# Synopsis: Runs all the available Pester tests
task RunPester {
    [array]$existingModule = Get-Module -ListAvailable Pester
    if (!$existingModule -or ($existingModule.Version -notcontains $pesterVer)) {
        Install-Module Pester -RequiredVersion $pesterVer -Force -Scope CurrentUser -SkipPublisherCheck
    }
    Import-Module Pester
    $results = Invoke-Pester (Join-Path $mdpCorePath "tools") `
                        -OutputFormat $pesterOutputFormat `
                        -OutputFile $pesterOutputFilePath `
                        -PassThru `
                        -Show Summary,Fails

    if ($results.FailedCount -gt 0) {
        throw ("{0} out of {1} tests failed - check previous logging for more details" -f $results.FailedCount, $results.TotalCount)
    }
}