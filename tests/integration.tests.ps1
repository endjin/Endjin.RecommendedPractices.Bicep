Describe "Bicep Module Integration Tests" {
    Context "Dummy Module" {
        It "should be true" {
            $true | should -Be $true
        }
    }
}