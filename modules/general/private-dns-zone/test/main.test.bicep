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

module privatedns_zones '../main.bicep' = {
  name: 'privateDnsDeploy'
  params: {
    zoneName: 'privatelink${environment().suffixes.sqlServerHostname}'
    virtualNetworkResourceGroupName: virtualNetworkResourceGroupName
    virtualNetworkName: virtualNetworkName
    autoRegistrationEnabled: false
  }
  dependsOn: [
    vnet
  ]
}
