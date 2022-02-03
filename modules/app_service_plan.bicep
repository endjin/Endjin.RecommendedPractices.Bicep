param name string
param skuName string
param skuTier string
param location string

param targetWorkerCount int = 0
param targetWorkerSizeId int = 0
param elasticScaleEnabled bool = false
param maximumElasticWorkerCount int = 1
param hyperV bool = false
param isSpot bool = false
param isXenon bool = false
param perSiteScaling bool = false
param reserved bool = false
param zoneRedundant bool = false

param resourceTags object = {}

param useExisting bool = false
param existingPlanResourceGroupName string = resourceGroup().name
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
