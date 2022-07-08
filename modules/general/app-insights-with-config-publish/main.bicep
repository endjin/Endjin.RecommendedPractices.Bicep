// <copyright file="app-insights-with-config-publish.bicep" company="Endjin Limited">
// Copyright (c) Endjin Limited. All rights reserved.
// </copyright>

@description('The name of the app insights workspace')
param name string

@description('The subscription of the existing app insights workspace')
param subscriptionId string = subscription().subscriptionId

@description('The location of the app insights workspace')
param location string

@description('The key vault name where the instrumentation key will be stored')
param keyVaultName string

@description('The resource group of the key vault where the instrumentation key will be stored')
param keyVaultResourceGroupName string

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

@description('When true, the details of an existing app configuration store will be returned; When false, the app configuration store is created/updated')
param useExisting bool = false

@description('The resource tags applied to resources')
param resourceTags object = {}


targetScope = 'resourceGroup'


module app_insights '../app-insights/main.bicep' = {
  name: 'appInsightsWithConfigPublish'
  params:{
    name: name
    applicationType: applicationType
    kind: kind
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
    contentValue: app_insights.outputs.appInsightsWorkspaceResource.properties.InstrumentationKey
    contentType: 'text/plain'
  }
}

// Template outputs
@description('The resource ID of the app insights workspace')
output id string = app_insights.outputs.id
@description('The name of the app insights workspace')
output name string = app_insights.outputs.name

// Returns the full AppInsights wWrkspace resource object (workaround whilst resource types cannot be returned directly)
@description('An object representing the app insights workspace resource')
output appInsightsWorkspaceResource object = app_insights.outputs.appInsightsWorkspaceResource
