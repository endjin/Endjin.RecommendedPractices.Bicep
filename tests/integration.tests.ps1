# Placeholder file for integrating Pester tests with the build process

# TODO: Run the Bicep module tests as part of the build process - although this will be slow
Describe "Bicep Module Integration Tests" {
    Context "Dummy Module" {
        It "should be true" {
            $true | should -Be $true
        }
    }
}