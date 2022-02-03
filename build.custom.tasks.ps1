#
# Use this file to customise the build process
#

# Synopsis: Lints the Bicep files and builds the ARM template
task ValidateBicepFiles {

    $filesToLint = gci -recurse -filter *.bicep -path ./modules

    foreach ($bicepFile in $filesToLint) {
        # Make Bicep treat warnings as errors without having to provide custom config files
        $ErrorActionPreference = "Continue"
        Invoke-Expression "az bicep build -f $bicepFile 2>''" -ErrorVariable bicepBuildLog
        $ErrorActionPreference = "Stop"
        $warningMessages = $bicepBuildLog | ? { $_.Exception.Message -imatch "\) : Warning " }
        $warningMessages | % { Write-Build Red $_ }
    }

    # if ($LASTEXITCODE -ne 0 ) {
    #     Write-Build Red $bicepBuildLog
    #     throw "Bicep build error - checks preceeding log messages"
    # }
    # elseif ($warningMessages) {
    #     Write-Build Yellow $bicepBuildLog
    #     throw "Treating Bicep warnings as errors - checks preceeding log messages"
    # }
    # else {
    #     Write-Build Green "Bicep files OK"
    # }
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