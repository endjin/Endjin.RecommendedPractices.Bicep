@description('The name of the app configuration store')
param name string

@description('The resource group name for the app configuration store')
param resourceGroupName string


targetScope = 'subscription'


resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' existing = {
  name: resourceGroupName
}

module app_config '_app_configuration.bicep' = {
  name: '_existingAppConfig-${name}'
  scope: rg
  params: {
    name: name
    useExisting: true
  }
}

output id string = app_config.outputs.id
output name string = app_config.outputs.name

output appConfigStoreResource object = app_config.outputs.appConfigStoreResource
