param prefix string = uniqueString(resourceGroup().id)
param location string = resourceGroup().location

module appconfig '../main.bicep' = {
  name: 'appConfig'
  params: {
    name: '${prefix}appconfig'
    location: location
  }
}
