param prefix string = 'brmtest'
param location string = resourceGroup().location

module appenv '../main.bicep' = {
  name: 'appEnvDeploy'
  params: {
    appInsightsName: '${prefix}ai'
    location: location
    logAnalyticsName: '${prefix}la'
    name: '${prefix}containerappenv'
  }
}
