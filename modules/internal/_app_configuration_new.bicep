@description('The name of the app configuration store')
param name string

@description('The resource group name for the app configuration store')
param resourceGroupName string

@description('The location of the app configuration store')
param location string

@description('SKU for the app configuration store')
@allowed([
  'Free'
  'Standard'
])
param sku string = 'Standard'

@description('When false, the app configuration store will be inaccessible via its public IP address')
param enablePublicNetworkAccess bool = true

@description('The resource tags applied to resources')
param resourceTags object = {}


targetScope = 'subscription'


resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

module app_config '_app_configuration.bicep' = {
  name: '_appConfig-${name}'
  scope: rg
  params: {
    name: name
    location: location
    sku: sku
    enablePublicNetworkAccess: enablePublicNetworkAccess
    useExisting: false
    resourceTags: resourceTags
  }
}

output id string = app_config.outputs.id
output name string = app_config.outputs.name

output appConfigStoreResource object = app_config.outputs.appConfigStoreResource
