@description('The name of the app service plan')
param name string

@description('SKU for the app service plan')
param skuName string

@description('SKU tier for the app service plan')
param skuTier string

@description('The location of the app service plan')
param location string

@description('')
param targetWorkerCount int = 0

@description('')
param targetWorkerSizeId int = 0

@description('')
param elasticScaleEnabled bool = false

@description('')
param maximumElasticWorkerCount int = 1

@description('')
param hyperV bool = false

@description('')
param isSpot bool = false

@description('')
param isXenon bool = false

@description('')
param perSiteScaling bool = false

@description('')
param reserved bool = false

@description('')
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
    // capacity: int
    // family: 'string'
    name: skuName
    // size: 'string'
    tier: skuTier
  }
  kind: 'string'
  properties: {
    elasticScaleEnabled: elasticScaleEnabled
    hyperV: hyperV
    isSpot: isSpot
    isXenon: isXenon
    maximumElasticWorkerCount: maximumElasticWorkerCount
    perSiteScaling: perSiteScaling
    reserved: reserved
    targetWorkerCount: targetWorkerCount
    targetWorkerSizeId: targetWorkerSizeId
    zoneRedundant: zoneRedundant
    // freeOfferExpirationTime: 'string'
    // hostingEnvironmentProfile: {
    //   id: 'string'
    // }
    // hostingEnvironmentProfile: { 
    //   id: 'string'
    // }
    // kubeEnvironmentProfile: {
    //   id: 'string'
    // }
    // spotExpirationTime: 'string'
    // workerTierName: 'string'
  }
  tags: resourceTags
}

output id string = useExisting ? existing_hosting_plan.id : hosting_plan.id

output appServicePlanResource object = useExisting ? existing_hosting_plan : hosting_plan
