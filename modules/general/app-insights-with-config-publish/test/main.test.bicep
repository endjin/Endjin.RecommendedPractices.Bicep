/*
Write deployment tests in this file. Any module that references the main
module file is a deployment test. Make sure at least one test is added.
*/

param location string = resourceGroup().location

module appInsights '../main.bicep' = {
  name: 'appInsights'
  params: {
    keyVaultName: 'foo-kv'
    location: location
    name: 'foo'
    keyVaultResourceGroupName: resourceGroup().name
  }
}
