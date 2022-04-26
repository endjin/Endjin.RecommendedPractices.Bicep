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
  }
}
