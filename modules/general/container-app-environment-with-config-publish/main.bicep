// <copyright file="container_app_environment_with_config_publish.bicep" company="Endjin Limited">
// Copyright (c) Endjin Limited. All rights reserved.
// </copyright>

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


targetScope = 'resourceGroup'


// ContainerApp hosting environment
module app_environment '../container-app-environment/main.bicep' = {
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

module kubeenv_app_config_key '../set-app-configuration-keys/main.bicep' = {
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

module aikey_secret '../key-vault-secret/main.bicep' = {
  name: 'aiKeySecretDeploy'
  params: {
    keyVaultName: keyVaultName
    secretName: 'AppInsightsInstrumentationKey'
    contentValue: app_environment.outputs.appinsights_instrumentation_key
    contentType: 'text/plain'
  }
}


// ContainerApp hosting environment outputs
@description('The resource ID of the container app environment')
output id string = app_environment.outputs.id
@description('The name of the container app environment')
output name string = app_environment.name
@description('An object representing the container app environment resource')
output appEnvironmentResource object = app_environment.outputs.appEnvironmentResource

// ACR outputs
@description('The resource ID of the container registry')
output acrId string = createContainerRegistry ? app_environment.outputs.acrId : ''
@description('The admin username for the container registry')
output acrUsername string = createContainerRegistry ? app_environment.outputs.acrUsername : ''
@description('The login server for the container registry')
output acrLoginServer string = createContainerRegistry ? app_environment.outputs.acrLoginServer : ''
