@description('The name of the app insights workspace')
param name string

@description('The resource group of the app insights workspace. When ')
param resourceGroupName string

@description('The location of the app insights workspace')
param location string

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

@description('The resource tags applied to resources')
param resourceTags object = {}


targetScope = 'subscription'


resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

module app_insights 'app_insights.bicep' = {
  name: 'appInsightsWithRg'
  scope: rg
  params:{
    name: name
    applicationType: applicationType
    flowType: flowType
    kind: kind
    requestSource: requestSource
    useExisting: false
    location: location
    resourceTags: resourceTags
  }
}


output id string = app_insights.outputs.id
output instrumentationKey string = app_insights.outputs.instrumentationKey

output appInsightsWorkspaceResource object = app_insights.outputs.appInsightsWorkspaceResource
