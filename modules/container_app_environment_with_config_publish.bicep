@description('The name of the container app hosting environment')
param name string

@description('The location of the container app hosting environment')
param location string

@description('When true, an Azure Container Registry will be provisioned')
param createContainerRegistry bool

@description('The name of the container registry')
param containerRegistryName string

@description('The SKU for the container registry')
param containerRegistrySku string

@description('When true, the details of an existing container app hosting environment will be returned; When false, the container app hosting environment will be created/updated')
param useExisting bool

@description('The name of the app configuration store where the config will be published')
param appConfigurationStoreName string

@description('The resource group for the app configuration store where the config will be published')
param appConfigurationStoreResourceGroupName string

@description('The subscription for the app configuration store where the config will be published')
param appConfigurationStoreSubscription string

@description('The app configuration label to apply to the published config')
param appConfigurationLabel string

@description('The name of the key vault where the app insights instrumentation key will be published')
param keyVaultName string

@description('The resource tags applied to resources')
param resourceTags object = {}


// ContainerApp hosting environment
module app_environment 'br:endjintestacr.azurecr.io/bicep/modules/container_app_environment:0.1.0-beta.01' = {
  name: 'containerAppEnv'
  params: {
    name: name
    appInsightsName: '${name}ai'
    logAnalyticsName: '${name}la'
    location: location
    createContainerRegistry: createContainerRegistry
    containerRegistryName: containerRegistryName
    containerRegistrySku: containerRegistrySku
    useExisting: useExisting
    resourceTags: resourceTags
  }
}

module kubeenv_app_config_key 'br:endjintestacr.azurecr.io/bicep/modules/set_app_configuration_keys:0.1.0-beta.01' = {
  scope: resourceGroup(appConfigurationStoreSubscription, appConfigurationStoreResourceGroupName)
  name: 'kubeenvAppConfigKeyDeploy'
  params: {
    appConfigStoreName: appConfigurationStoreName
    label: appConfigurationLabel
    entries: [
      {
        name: 'ContainerAppEnvironmentResourceId'
        value: app_environment.outputs.id
      }
    ]
  }
}

module aikey_secret 'br:endjintestacr.azurecr.io/bicep/modules/key_vault_secret:0.1.0-beta.01' = {
  name: 'aiKeySecretDeploy'
  params: {
    keyVaultName: keyVaultName
    secretName: 'AppInsightsInstrumentationKey'
    contentValue: app_environment.outputs.appinsights_instrumentation_key
    contentType: 'text/plain'
  }
}

output id string = app_environment.outputs.id
output name string = app_environment.name
output acrId string = createContainerRegistry ? app_environment.outputs.acrId : ''
output acrUsername string = createContainerRegistry ? app_environment.outputs.acrUsername : ''
output acrLoginServer string = createContainerRegistry ? app_environment.outputs.acrLoginServer : ''

output appEnvironmentResource object = app_environment.outputs.appEnvironmentResource

