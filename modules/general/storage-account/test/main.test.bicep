param prefix string = uniqueString(resourceGroup().id)
param location string = resourceGroup().location

module storage '../main.bicep' = {
  name: 'storageDeploy'
  params: {
    name: '${prefix}sa'
    location: location
  }
}
