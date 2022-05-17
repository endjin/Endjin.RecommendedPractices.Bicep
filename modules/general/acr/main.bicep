// <copyright file="acr.bicep" company="Endjin Limited">
// Copyright (c) Endjin Limited. All rights reserved.
// </copyright>

@description('The name of the container registry')
param name string

@description('The location of the container registry')
param location string

@description('SKU for the container registry')
@allowed([
  'Basic'
  'Standard'
  'Premium'
])
param sku string

@description('When true, admin access via the ACR key is enabled; When false, access is via RBAC')
param adminUserEnabled bool = false

@description('When true, the details of an existing ACR will be returned; When false, the ACR is created/updated')
param useExisting bool = false

@description('The resource tags applied to resources')
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

@description('The resource ID of the container registry')
output id string = useExisting ? existing_acr.id : acr.id
@description('The name of the container registry')
output name string = useExisting ? existing_acr.name : acr.name
@description('The admin username of the container registry')
output loginServer string = useExisting ? existing_acr.properties.loginServer : acr.properties.loginServer

@description('An object representing the container registry resource')
output acrResource object = useExisting ? existing_acr : acr
