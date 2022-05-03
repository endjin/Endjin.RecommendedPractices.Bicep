// <copyright file="app_insights.bicep" company="Endjin Limited">
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

@description('When true, the details of an existing app configuration store will be returned; When false, the app configuration store is created/updated')
param useExisting bool = false

@description('The resource tags applied to resources')
param resourceTags object = {}


targetScope = 'resourceGroup'


resource existing_app_insights 'Microsoft.Insights/components@2020-02-02' existing = if (useExisting) {
  name: name
}

// TODO: Create LogAnalytics-linked workspace

resource app_insights 'Microsoft.Insights/components@2020-02-02' = if (!useExisting) {
  name: name
  location: location
  kind: kind
  properties: {
    Application_Type: applicationType
  }
  tags: resourceTags
}


@description('The resource ID of the app insights workspace')
output id string = useExisting ? existing_app_insights.id : app_insights.id
@description('The name of the app insights workspace')
output name string =  useExisting ? existing_app_insights.name : app_insights.name

@description('An object representing the app insights workspace resource')
output appInsightsWorkspaceResource object = useExisting ? existing_app_insights : app_insights
