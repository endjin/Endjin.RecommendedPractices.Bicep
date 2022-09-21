param prefix string = uniqueString(resourceGroup().id)
param location string = resourceGroup().location

module keyvault_with_diagnostics '../main.bicep' = {
  name: 'keyVaultWithDiagsDeploy'
  params: {
    enableDiagnostics: true
    name: '${prefix}kv'
    tenantId: tenant().tenantId
    location: location
    enableSoftDelete: false
  }
}

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
        name: 'default'
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
    name: '${prefix}aclskv'
    tenantId: tenant().tenantId
    location: location
    enableSoftDelete: false
    enableRbacAuthorization: false
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
      ipRule: [                 // ref: https://learn.microsoft.com/en-us/azure/templates/microsoft.keyvault/vaults#iprule
        '90.255.204.0/24'
      ]
      virtualNetworkRules: [   // ref: https://learn.microsoft.com/en-us/azure/templates/microsoft.keyvault/vaults#virtualnetworkrule
        {
          id: vnet.id
          ignoreMissingVnetServiceEndpoint: false
        }
      ]
    }
  }
}
