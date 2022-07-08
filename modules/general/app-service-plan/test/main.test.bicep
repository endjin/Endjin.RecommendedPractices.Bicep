param prefix string = uniqueString(resourceGroup().id)
param location string = resourceGroup().location

module appServicePlan '../main.bicep' = {
  name: 'appServicePlan'
  params: {
    location: location
    name: '${prefix}plan'
    skuName: 'Standard'
    skuTier: 'S1'
  }
}
