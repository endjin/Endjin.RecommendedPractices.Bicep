// <copyright file="app-insights-with-config-publish/main.bicep" company="Endjin Limited">
// Copyright (c) Endjin Limited. All rights reserved.
// </copyright>

metadata name = 'Application Insights with published configuration'
metadata description = 'Deploys an AppInsights workspace and publishes the instrumentation key to a Key Vault'
metadata owner = 'endjin'

@description('The name of the app insights workspace')
param name string

@description('The subscription of the existing app insights workspace')
param subscriptionId string = subscription().subscriptionId

@description('The location of the app insights workspace')
param location string

@description('The name of the existing Log Analytics workspace which the data will be ingested to.')
param logAnalyticsWorkspaceName string

@description('When true, public network access is disabled for ingestion of data.')
param disablePublicNetworkAccessForIngestion bool = false

@description('When true, public network access is disabled for querying of data.')
param disablePublicNetworkAccessForQuery bool = false

@description('The key vault name where the instrumentation key will be stored')
param keyVaultName string

@description('The resource group of the key vault where the instrumentation key will be stored')
param keyVaultResourceGroupName string

@description('The subscription of the key vault where the instrumentation key will be stored')
param keyVaultSubscriptionId string = subscriptionId

@description('The name of the key vault secret where the instrumentation key will be stored.')
param applicationInsightsKeySecretName string = 'AppInsightsInstrumentationKey'

@description('The name of the key vault secret where the connection string will be stored.')
param applicationInsightsConnectionStringSecretName string = 'AppInsightsConnectionString'

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
    logAnalyticsWorkspaceName: logAnalyticsWorkspaceName
    disablePublicNetworkAccessForIngestion: disablePublicNetworkAccessForIngestion
    disablePublicNetworkAccessForQuery: disablePublicNetworkAccessForQuery
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
    secretName: applicationInsightsKeySecretName
    contentValue: app_insights.outputs.appInsightsWorkspaceResource.properties.InstrumentationKey
    contentType: 'text/plain'
  }
}

module aiconnectionstring_secret '../key-vault-secret/main.bicep' = {
  name: 'appInsightsConnectionStringSecret'
  scope: resourceGroup(keyVaultSubscriptionId, keyVaultResourceGroupName)
  params: {
    keyVaultName: keyVaultName
    secretName: applicationInsightsConnectionStringSecretName
    contentValue: app_insights.outputs.appInsightsWorkspaceResource.properties.ConnectionString
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

@description('The name of the key vault secret where the instrumentation key will be stored.')
output appInsightsKeySecretName string = applicationInsightsKeySecretName
@description('The name of the key vault secret where the connection string will be stored.')
output appInsightsConnectionStringSecretName string = applicationInsightsConnectionStringSecretName

