// <copyright file="app_service_plan.bicep" company="Endjin Limited">
// Copyright (c) Endjin Limited. All rights reserved.
// </copyright>

@description('The name of the app service plan')
param name string

@description('SKU for the app service plan')
param skuName string

@description('SKU tier for the app service plan')
param skuTier string

@description('The location of the app service plan')
param location string

@description('The target number of workers')
param targetWorkerCount int = 0

@description('The target size of the workers')
param targetWorkerSizeId int = 0

@description('When true, elastic scale is enabled')
param elasticScaleEnabled bool = false

@description('The maximum number of elastic workers')
param maximumElasticWorkerCount int = 1

@description('When true, the app service will have zone redundancy')
param zoneRedundant bool = false

@description('The resource tags applied to resources')
param resourceTags object = {}

@description('When true, the details of an existing app service plan will be returned; When false, the app service plan is created/udpated')
param useExisting bool = false

@description('The resource group in which the existing app service plan resides')
param existingPlanResourceGroupName string = resourceGroup().name

@description('The subscription in which the existing app service plan resides')
param existingPlanResourceSubscriptionId string = subscription().subscriptionId


targetScope = 'resourceGroup'


resource existing_hosting_plan 'Microsoft.Web/serverfarms@2021-02-01' existing = if (useExisting) {
  name: name
  scope: resourceGroup(existingPlanResourceSubscriptionId, existingPlanResourceGroupName)
}

resource hosting_plan 'Microsoft.Web/serverfarms@2021-02-01' = if (!useExisting) {
  name: name
  location: location
  sku: {
    name: skuName
    tier: skuTier
  }
  kind: 'string'
  properties: {
    elasticScaleEnabled: elasticScaleEnabled
    maximumElasticWorkerCount: maximumElasticWorkerCount
    targetWorkerCount: targetWorkerCount
    targetWorkerSizeId: targetWorkerSizeId
    zoneRedundant: zoneRedundant
  }
  tags: resourceTags
}

@description('The resource ID of the app service plan')
output id string = useExisting ? existing_hosting_plan.id : hosting_plan.id
@description('The name of the app service plan')
output nmae string = useExisting ? existing_hosting_plan.name : hosting_plan.name

@description('An object representing the app configuration store resource')
output appServicePlanResource object = useExisting ? existing_hosting_plan : hosting_plan