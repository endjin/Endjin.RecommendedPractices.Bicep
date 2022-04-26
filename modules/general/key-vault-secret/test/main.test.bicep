param prefix string = uniqueString(resourceGroup().id)
param location string = resourceGroup().location

resource key_vault 'Microsoft.KeyVault/vaults@2021-06-01-preview' = {
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

module keyvault_with_diagnostics '../main.bicep' = {
  name: 'keyVaultDeploy'
  params: {
    keyVaultName: key_vault.name
    secretName: 'TEST-SECRET-${key_vault.name}'
  }
}
