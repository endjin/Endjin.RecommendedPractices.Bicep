param prefix string = uniqueString(resourceGroup().id)
param location string = resourceGroup().location

resource key_vault 'Microsoft.KeyVault/vaults@2021-11-01-preview' = {
  name: '${prefix}kv'
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: tenant().tenantId
  }
}

module appInsights '../main.bicep' = {
  name: 'appInsights'
  params: {
    keyVaultName: key_vault.name
    location: location
    name: '${prefix}ai'
    keyVaultResourceGroupName: resourceGroup().name
  }
}
