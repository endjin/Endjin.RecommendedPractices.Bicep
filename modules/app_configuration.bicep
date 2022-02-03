@description('The name of the app configuration store')
param name string
@description('The location of the app configuration store')
param location string
@description('When false, the app configuration store will be inaccessible via its public IP address')
param enablePublicNetworkAccess bool = true

@description('SKU for the app configuration store')
@allowed([
  'Free'
  'Standard'
])
param sku string = 'Standard'
param useExisting bool = false
param resourceTags object = {}

var publicNetworkAccess = enablePublicNetworkAccess ? 'Enabled' : 'Disabled'

targetScope = 'resourceGroup'

resource existing_app_config_store 'Microsoft.AppConfiguration/configurationStores@2020-06-01' existing = if (useExisting) {
  name: name
}

resource app_config_store 'Microsoft.AppConfiguration/configurationStores@2020-06-01' = if (!useExisting) {
  name: name
  location: location
  sku: {
    name: sku
  }
  properties: {
    publicNetworkAccess: publicNetworkAccess
  }
  tags: resourceTags
}

output id string = useExisting ? existing_app_config_store.id : app_config_store.id
output name string = useExisting ? existing_app_config_store.name : app_config_store.name

output appConfigStoreResource object = useExisting ? existing_app_config_store : app_config_store
