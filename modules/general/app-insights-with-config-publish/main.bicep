// <copyright file="app_insights_with_config_publish.bicep" company="Endjin Limited">
// Copyright (c) Endjin Limited. All rights reserved.
// </copyright>

@description('The name of the app insights workspace')
param name string

@description('The resource group of the app insights workspace. When ')
param resourceGroupName string

@description('The subscription of the existing app insights workspace')
param subscriptionId string = subscription().subscriptionId

@description('The location of the app insights workspace')
param location string

@description('The key vault name where the instrumentation key will be stored')
param keyVaultName string

@description('The resource group of the key vault where the instrumentation key will be stored')
param keyVaultResourceGroupName string = resourceGroupName

@description('The subscription of the key vault where the instrumentation key will be stored')
param keyVaultSubscriptionId string = subscriptionId

@description('The kind of application using the workspace')
@allowed([
  'web'
  'ios'
  'other'
  'store'
  'java'
  'phone'
])
param kind string = 'web'

@description('The type of application using the workspace')
@allowed([
  'other'
  'web'
])
param applicationType string = 'web'

param flowType string = 'Redfield'
param requestSource string = 'CustomDeployment'

@description('When true, the details of an existing app configuration store will be returned; When false, the app configuration store is created/udpated')
param useExisting bool = false

@description('The resource tags applied to resources')
param resourceTags object = {}


targetScope = 'resourceGroup'


module app_insights '../app-insights/main.bicep' = {
  name: 'appInsightsWithConfigPublish'
  params:{
    name: name
    applicationType: applicationType
    flowType: flowType
    kind: kind
    requestSource: requestSource
    useExisting: useExisting
    location: location
    resourceTags: resourceTags
  }
}

module aikey_secret '../key-vault-secret/main.bicep' = {
  name: 'appInsightsKeySecret'
  scope: resourceGroup(keyVaultSubscriptionId, keyVaultResourceGroupName)
  params: {
    keyVaultName: keyVaultName
    secretName: 'AppInsightsInstrumentationKey'
    contentValue: app_insights.outputs.instrumentationKey
    contentType: 'text/plain'
  }
}

output id string = app_insights.outputs.id
output instrumentationKey string = app_insights.outputs.instrumentationKey

output appInsightsWorkspaceResource object = app_insights.outputs.appInsightsWorkspaceResource
