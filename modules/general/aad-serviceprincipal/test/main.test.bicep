param prefix string = uniqueString(resourceGroup().id)
param location string = resourceGroup().location

var keyVaultName = '${prefix}kv'
var keyVaultSecretName = 'Test_ServicePrincipal_Credentials'

// NOTE: there are deliberate placeholders in this test file as it requires
// an existing MI with AAD group membership privileges.
// To run the test deployment, replace the placeholders with appropriate values.

resource managed_identity 'Microsoft.ManagedIdentity/userAssignedIdentities@2021-09-30-preview' existing = {
  name: '<name>'
  scope: resourceGroup('<subscription-id>', '<resource-group-name>')
}

resource key_vault 'Microsoft.KeyVault/vaults@2023-02-01' = {
  name: keyVaultName
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: tenant().tenantId
  }
}

module aad_sp '../main.bicep' = {
  name: 'aadSpDeploy'
  params: {
    displayName: '${prefix}aadsp'
    location: location
    managedIdentityResourceId: managed_identity.id
    keyVaultName: keyVaultName
    keyVaultSecretName: keyVaultSecretName
    passwordLifetimeDays: 5
  }
}
