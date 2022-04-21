/*
Write deployment tests in this file. Any module that references the main
module file is a deployment test. Make sure at least one test is added.
*/
param location string = resourceGroup().location

module appconfig '../main.bicep' = {
  name: 'appCcnfig'
  params: {
    name: 'foo'
    location: location
  }
}
