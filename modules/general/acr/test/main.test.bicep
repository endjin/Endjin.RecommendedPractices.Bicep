param prefix string = uniqueString(resourceGroup().id)
param location string = resourceGroup().location

module acr '../main.bicep' = {
  name: 'acrDeploy'
  params: {
    location: location
    name: '${prefix}acr'
    sku: 'Basic'
  }
}
