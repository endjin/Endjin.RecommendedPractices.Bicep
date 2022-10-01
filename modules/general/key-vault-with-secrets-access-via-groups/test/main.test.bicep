param prefix string = uniqueString(resourceGroup().id)
param location string = resourceGroup().location

// TODO: Create temporary groups?

module keyvault_no_groups '../main.bicep' = {
  name: 'keyVaultDeploy'
  params: {
    enableDiagnostics: false
    name: '${prefix}kv'
    secretsContributorsGroupObjectId: '00000000-0000-0000-0000-000000000000'
    secretsReadersGroupObjectId: '00000000-0000-0000-0000-000000000000'
    tenantId: '00000000-0000-0000-0000-000000000000'
    location: location
    enableSoftDelete: false
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
              service: 'Microsoft.KeyVault'
            }
          ]
        }
      }
    ]
  }
}

module keyvault_with_networkacls '../main.bicep' = {
  name: 'keyVaultWithNetworkAclDeploy'
  params: {
    enableDiagnostics: false
    name: '${prefix}kv'
    secretsContributorsGroupObjectId: '00000000-0000-0000-0000-000000000000'
    secretsReadersGroupObjectId: '00000000-0000-0000-0000-000000000000'
    tenantId: '00000000-0000-0000-0000-000000000000'
    location: location
    enableSoftDelete: false
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
      ipRule: [                 // ref: https://learn.microsoft.com/en-us/azure/templates/microsoft.keyvault/vaults#iprule
        '90.255.204.0/24'
      ]
      virtualNetworkRules: [   // ref: https://learn.microsoft.com/en-us/azure/templates/microsoft.keyvault/vaults#virtualnetworkrule
        {
          id: '${vnet.id}/subnets/${subnetName}'
          ignoreMissingVnetServiceEndpoint: false
        }
      ]
    }
  }
}
