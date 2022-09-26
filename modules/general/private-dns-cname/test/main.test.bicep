param prefix string = uniqueString(resourceGroup().id)
param location string = resourceGroup().location

var virtualNetworkName = '${prefix}vnet'
var virtualNetworkResourceGroupName = resourceGroup().name

resource vnet 'Microsoft.Network/virtualNetworks@2021-08-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
  }
}

var sqlPrivateLinkFqdn = 'privatelink${environment().suffixes.sqlServerHostname}'

module privatedns_zones '../../private-dns-zone/main.bicep' = {
  name: 'privateDnsDeploy'
  params: {
    zoneName: sqlPrivateLinkFqdn
    virtualNetworkResourceGroupName: virtualNetworkResourceGroupName
    virtualNetworkName: virtualNetworkName
    autoRegistrationEnabled: false
  }
  dependsOn: [
    vnet
  ]
}

var synapseWorkspaceName = '${prefix}synapse'

module privatedns_cnamerecord '../main.bicep' = {
  name: 'cnameRecordDeploy'
  params: {
    recordName: synapseWorkspaceName
    recordValue: '${synapseWorkspaceName}.privatelink.sql.azuresynapse.net'
    zoneName: sqlPrivateLinkFqdn
    recordMetadata: {
      creator: 'Created to support private endpoint access to Azure Synapse SQL Pools'
    }
  }
}
