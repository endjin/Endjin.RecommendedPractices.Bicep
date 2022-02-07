@description('The name of the app insights workspace')
param name string

@description('The resource group of the app insights workspace')
param resourceGroupName string

@description('The subscription of the app insights workspace')
param subscriptionId string

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

targetScope = 'subscription'


module non_app_environment_ai 'br:endjintestacr.azurecr.io/bicep/modules/app_insights:0.1.0-beta.01' = {
  name: 'appInsights'
  scope: resourceGroup(subscriptionId, resourceGroupName)
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

module aikey_secret 'br:endjintestacr.azurecr.io/bicep/modules/key_vault_secret:0.1.0-beta.01' = {
  name: 'aiKeySecretDeploy'
  scope: resourceGroup(keyVaultSubscriptionId, keyVaultResourceGroupName)
  params: {
    keyVaultName: keyVaultName
    secretName: 'AppInsightsInstrumentationKey'
    contentValue: non_app_environment_ai.outputs.instrumentationKey
    contentType: 'text/plain'
  }
}

output id string = non_app_environment_ai.outputs.id
output instrumentationKey string = non_app_environment_ai.outputs.instrumentationKey

output appInsightsWorkspaceResource object = non_app_environment_ai.outputs.appInsightsWorkspaceResource
