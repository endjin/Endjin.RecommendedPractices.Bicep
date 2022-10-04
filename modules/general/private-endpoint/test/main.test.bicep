param prefix string = uniqueString(resourceGroup().id)
param location string = resourceGroup().location

resource storage 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: prefix
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}

resource vnet 'Microsoft.Network/virtualNetworks@2021-08-01' = {
  name: prefix
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'default'
        properties: {
          addressPrefix: '10.0.0.0/24'
        }
      }
    ]
  }
}

module private_endpoint_blob '../main.bicep' = {
  name: 'privateEndpointDeployBlob'
  params: {
    enablePrivateDns: false
    location: location
    name: prefix
    serviceGroupId: 'blob'
    serviceResourceId: storage.id
    subnetName: 'default'
    virtualNetworkName: prefix
    virtualNetworkResourceGroup: resourceGroup().name
  }
}

module private_endpoint_dfs '../main.bicep' = {
  name: 'privateEndpointDeployDfs'
  params: {
    enablePrivateDns: false
    location: location
    name: prefix
    serviceGroupId: 'dfs'
    serviceResourceId: storage.id
    subnetName: 'default'
    virtualNetworkName: prefix
    virtualNetworkResourceGroup: resourceGroup().name
  }
}
