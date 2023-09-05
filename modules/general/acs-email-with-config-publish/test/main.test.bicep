param suffix string = uniqueString(resourceGroup().id)
param location string = resourceGroup().location

resource key_vault 'Microsoft.KeyVault/vaults@2021-11-01-preview' = {
  name: 'kv${suffix}'
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: tenant().tenantId
    accessPolicies: []
  }
}

module acs_email_with_config_publish '../main.bicep' = {
  name: 'acsEmailWithConfigPublishDeploy'
  params: {
    communicationServiceName: 'acs-${suffix}'
    emailServiceName: 'acs-email-${suffix}'
    dataLocation: 'Switzerland'
    senderUsername: 'FooBar'
    keyVaultName: key_vault.name
    keyVaultResourceGroup: resourceGroup().name
  }
}
