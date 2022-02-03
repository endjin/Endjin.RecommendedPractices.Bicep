param name string
param location string
param sku string
param adminUserEnabled bool = false
param useExisting bool = false
param resourceTags object = {}

targetScope = 'resourceGroup'

resource existing_acr 'Microsoft.ContainerRegistry/registries@2021-09-01' existing = if (useExisting) {
  name: name
}

resource acr 'Microsoft.ContainerRegistry/registries@2021-09-01' = if (!useExisting) {
  name: name
  location: location
  sku: {
    name: sku
  }
  properties: {
    adminUserEnabled: adminUserEnabled
  }
  tags: resourceTags
}

output id string = useExisting ? existing_acr.id : acr.id
output name string = useExisting ? existing_acr.name : acr.name
output loginServer string = useExisting ? existing_acr.properties.loginServer : acr.properties.loginServer

output acrResource object = useExisting ? existing_acr : acr
