param prefix string = uniqueString(resourceGroup().id)
param location string = resourceGroup().location

module appServicePlan '../main.bicep' = {
  name: 'appServicePlan'
  params: {
    kind: 'app'
    location: location
    name: '${prefix}appplan'
    skuName: 'S1'
    skuCapacity: 1
  }
}

module functionAppServicePlan '../main.bicep' = {
  name: 'functionAppServicePlan'
  params: {
    kind: 'functionapp'
    location: location
    name: '${prefix}functionappplan'
    skuName: 'Y1'
    skuCapacity: 1
  }
}

module linuxAppServicePlan '../main.bicep' = {
  name: 'linuxAppServicePlan'
  params: {
    kind: 'linux'
    location: location
    name: '${prefix}linuxplan'
    skuName: 'B1'
    skuCapacity: 1
  }
}
