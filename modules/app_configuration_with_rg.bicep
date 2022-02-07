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

@description('When true, the details of an existing app configuration store will be returned; When false, the app configuration store is created/udpated')
param useExisting bool = false

@description('The resource tags applied to resources')
param resourceTags object = {}


targetScope = 'subscription'


resource app_config_rg 'Microsoft.Resources/resourceGroups@2021-04-01' = if (!useExisting) {
  name: resourceGroupName
  location: location
}

module app_config 'br:endjintestacr.azurecr.io/bicep/modules/app_configuration:0.1.0-beta.01' = {
  name: 'appConfigDeploy'
  scope: useExisting ? resourceGroup(resourceGroupName) : app_config_rg
  params: {
    name: name
    location: location
    sku: sku
    useExisting: useExisting
    resourceTags: resourceTags
  }
}

output id string = app_config.outputs.id
output name string = app_config.outputs.name

output appConfigStoreResource object = app_config.outputs.appConfigStoreResource
