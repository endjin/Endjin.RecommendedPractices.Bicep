// <copyright file="private-dns-zone/main.bicep" company="Endjin Limited">
// Copyright (c) Endjin Limited. All rights reserved.
// </copyright>

metadata name = 'Private DNS Zone'
metadata description = 'Adds/updates a private DNS zone and virtual network link for existing VNet'
metadata owner = 'endjin'

@description('The name for the Private DNS Zone. Must be a valid domain name. For Azure services, use the recommended zone names (ref: https://learn.microsoft.com/en-gb/azure/private-link/private-endpoint-dns#azure-services-dns-zone-configuration)')
param zoneName string

@description('When true, a DNS record gets automatically created for each virtual machine deployed in the virtual network.')
param autoRegistrationEnabled bool

@description('The resource group name of the existing VNet.')
param virtualNetworkResourceGroupName string

@description('The name of the existing VNet.')
param virtualNetworkName string

resource vnet 'Microsoft.Network/virtualNetworks@2021-08-01' existing = {
  name: virtualNetworkName
  scope: resourceGroup(virtualNetworkResourceGroupName)
}

resource privatedns_zone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: zoneName
  location: 'global'
}

resource privatedns_link 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: privatedns_zone
  name: '${privatedns_zone.name}-link'
  location: 'global'
  properties: {
    registrationEnabled: autoRegistrationEnabled
    virtualNetwork: {
      id: vnet.id
    }
  }
}

