param prefix string = uniqueString(resourceGroup().id)
param location string = resourceGroup().location

module keyvault_with_diagnostics '../main.bicep' = {
  name: 'keyVaultDeploy'
  params: {
    enableDiagnostics: true
    name: '${prefix}kv'
    tenantId: tenant().tenantId
    location: location
  }
}
