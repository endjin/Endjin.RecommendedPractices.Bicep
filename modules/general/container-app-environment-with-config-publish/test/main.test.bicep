param prefix string = uniqueString(resourceGroup().id)
param location string = resourceGroup().location

module appenv_with_keyvault '../main.bicep' = {
  name: 'appEnvDeploy'
  params: {
    location: location
    name: '${prefix}conappenv'
    appConfigurationLabel: 'biceptest'
    appConfigurationStoreName: '${prefix}appconfig'
    appConfigurationStoreResourceGroupName: resourceGroup().name
    appConfigurationStoreSubscription: subscription().subscriptionId
    containerRegistryName: '${prefix}acr'
    containerRegistrySku: 'Standard'
    createContainerRegistry: true
    keyVaultName: '${prefix}kv'
    useExisting: false
  }
}
