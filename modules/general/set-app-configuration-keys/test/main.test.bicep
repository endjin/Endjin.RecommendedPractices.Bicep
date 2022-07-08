param prefix string = uniqueString(resourceGroup().id)
param location string = resourceGroup().location

resource app_config 'Microsoft.AppConfiguration/configurationStores@2021-10-01-preview' = {
  name: '${prefix}-appconfig'
  location: location
  sku: {
    name: 'standard'
  }
}

module single_config_key '../main.bicep' = {
  name: 'configKeyDeploy'
  params: {
    appConfigStoreName: app_config.name
    entries: [
      {
        name: 'foo'
        value: 'bar'
      }
    ]
  }
}
