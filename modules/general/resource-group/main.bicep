// <copyright file="resource_group.bicep" company="Endjin Limited">
// Copyright (c) Endjin Limited. All rights reserved.
// </copyright>

@description('The name of the resource group')
param name string

@description('The location of the resource group')
param location string

@description('When true, the details of an existing resource group will be returned; When false, the resource group is created/udpated')
param useExisting bool = false

@description('The resource tags applied to resources')
param resourceTags object = {}


targetScope = 'subscription'


resource existing_rg 'Microsoft.Resources/resourceGroups@2021-04-01' existing = if (useExisting) {
  name: name
}

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = if (!useExisting) {
  name: name
  location: location
  tags: resourceTags
}

@description('The resource ID of the resource group')
output id string = useExisting ?  existing_rg.id : rg.id
@description('The name of the resource group')
output name string = name

@description('An object representing the resource group resource')
output resourceGroupResource object = useExisting ? existing_rg : rg
