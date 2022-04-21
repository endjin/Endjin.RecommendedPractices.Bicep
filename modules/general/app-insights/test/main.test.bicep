/*
Write deployment tests in this file. Any module that references the main
module file is a deployment test. Make sure at least one test is added.
*/

param location string = resourceGroup().location

module appinsights '../main.bicep' = {
  name: 'appInsights'
  params: {
    location: location
    name: 'foo'
  }
}
