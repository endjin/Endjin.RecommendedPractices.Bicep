param prefix string = uniqueString(resourceGroup().id)
param location string = resourceGroup().location

module appinsights '../main.bicep' = {
  name: 'appInsights'
  params: {
    location: location
    name: '${prefix}ai'
  }
}
