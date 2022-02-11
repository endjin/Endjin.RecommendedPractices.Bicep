@description('The name of the app configuration store')
param name string

@description('The resource group name for the app configuration store')
param resourceGroupName string

@description('The location of the app configuration store')
param location string = deployment().location

@description('When false, the app configuration store will be inaccessible via its public IP address')
param enablePublicNetworkAccess bool = true

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


module existing_app_config '../internal/_app_configuration_existing.bicep' = if (useExisting) {
  name: '_existingAppConfig'
  params: {
    name: name
    resourceGroupName: resourceGroupName
  }
}

module app_config '../internal/_app_configuration_new.bicep' = if (!useExisting) {
  name: '_appConfig'
  params: {
    name: name
    resourceGroupName: resourceGroupName
    location: location
    sku: sku
    enablePublicNetworkAccess: enablePublicNetworkAccess
    resourceTags: resourceTags
  }
}

output id string = useExisting ? existing_app_config.outputs.id : app_config.outputs.id
output name string = useExisting ? existing_app_config.outputs.name : app_config.outputs.name

output appConfigStoreResource object = useExisting ? existing_app_config.outputs.appConfigStoreResource : app_config.outputs.appConfigStoreResource
