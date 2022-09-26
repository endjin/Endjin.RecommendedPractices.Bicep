param prefix string = uniqueString(resourceGroup().id)
param location string = resourceGroup().location

module storage '../main.bicep' = {
  name: 'storageDeploy'
  params: {
    name: '${prefix}sa'
    location: location
  }
}

module storage_with_hns '../main.bicep' = {
  name: 'storageWithHnsDeploy'
  params: {
    name: '${prefix}hnssa'
    location: location
    isHnsEnabled: true
  }
}

var subnetName = 'default'
resource vnet 'Microsoft.Network/virtualNetworks@2021-08-01' = {
  name: '${prefix}vnet'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: '10.0.0.0/24'
          serviceEndpoints: [
            {
              locations: [
                location
              ]
              service: 'Microsoft.Storage'
            }
          ]
        }
      }
    ]
  }
}

module storage_with_network_acls '../main.bicep' = {
  name: 'storageWithNetworkAclsDeploy'
  params: {
    name: '${prefix}aclssa'
    location: location
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
      ipRule: [                 // ref: https://learn.microsoft.com/en-us/azure/templates/microsoft.storage/storageaccounts?pivots=deployment-language-bicep#iprule
        '90.255.204.0/24'
      ]
      virtualNetworkRules: [   // ref: https://learn.microsoft.com/en-us/azure/templates/microsoft.storage/storageaccounts?pivots=deployment-language-bicep#virtualnetworkrule
        {
          id: '${vnet.id}/subnets/${subnetName}'
          ignoreMissingVnetServiceEndpoint: false
        }
      ]
    }
  }
}
