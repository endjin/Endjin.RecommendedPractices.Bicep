// <copyright file="app-insights.bicep" company="Endjin Limited">
// Copyright (c) Endjin Limited. All rights reserved.
// </copyright>

@description('The name of the app insights workspace')
param name string

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

@description('The name of the existing Log Analytics workspace which the data will be ingested to.')
param logAnalyticsWorkspaceName string

@description('When true, public network access is disabled for ingestion of data.')
param disablePublicNetworkAccessForIngestion bool = false

@description('When true, public network access is disabled for querying of data.')
param disablePublicNetworkAccessForQuery bool = false

@description('When true, the details of an existing app insights instance will be returned; When false, the app insights instance is created/updated')
param useExisting bool = false

@description('The resource tags applied to resources')
param resourceTags object = {}


targetScope = 'resourceGroup'


resource existing_app_insights 'Microsoft.Insights/components@2020-02-02' existing = if (useExisting) {
  name: name
}

resource log_analytics_workspace 'Microsoft.OperationalInsights/workspaces@2020-10-01' existing = {
  name: logAnalyticsWorkspaceName
}

resource app_insights 'Microsoft.Insights/components@2020-02-02-preview' = if (!useExisting) {
  name: name
  location: location
  kind: kind
  properties: {
    Application_Type: applicationType
    Flow_Type: any('Redfield')
    Request_Source: any('IbizaAIExtension')
    WorkspaceResourceId: log_analytics_workspace.id
    IngestionMode: 'LogAnalytics'
    publicNetworkAccessForIngestion: disablePublicNetworkAccessForIngestion ? 'Disabled' : 'Enabled'
    publicNetworkAccessForQuery: disablePublicNetworkAccessForQuery ? 'Disabled' : 'Enabled'
  }
  tags: resourceTags
}

// Template outputs
@description('The resource ID of the app insights workspace')
output id string = useExisting ? existing_app_insights.id : app_insights.id
@description('The name of the app insights workspace')
output name string =  useExisting ? existing_app_insights.name : app_insights.name

// Returns the full AppInsights Workspace resource object (workaround whilst resource types cannot be returned directly)
@description('An object representing the app insights workspace resource')
output appInsightsWorkspaceResource object = useExisting ? existing_app_insights : app_insights
