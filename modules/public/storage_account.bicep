param name string
param location string = resourceGroup().location
param sku string = 'Standard_LRS'
param kind string = 'StorageV2'
param tlsVersion string = 'TLS1_2'
param httpsOnly bool = true
param accessTier string = 'Hot'
param saveAccessKeyToKeyVault bool = false
param keyVaultResourceGroupName string = ''
param keyVaultName string = ''
param keyVaultSecretName string = ''
param useExisting bool = false
param resource_tags object = {}

targetScope = 'resourceGroup'

resource existing_storage_account 'Microsoft.Storage/storageAccounts@2021-06-01' existing = if (useExisting) {
  name: name
}

resource storage_account 'Microsoft.Storage/storageAccounts@2021-06-01' = if (!useExisting) {
  name: name
  location: location
  sku: {
    name: sku
  }
  kind: kind
  properties: {
    minimumTlsVersion: tlsVersion
    supportsHttpsTrafficOnly: httpsOnly
    accessTier: accessTier
  }
  tags: resource_tags
}

module storage_access_key_secret 'key_vault_secret.bicep' = if (saveAccessKeyToKeyVault) {
  name: 'storageSecretDeploy'
  scope: resourceGroup(keyVaultResourceGroupName) 
  params: {
    keyVaultName: keyVaultName
    secretName: keyVaultSecretName
    contentValue: useExisting ? existing_storage_account.listKeys().keys[0].value : storage_account.listKeys().keys[0].value
  }
}

output id string = useExisting ? existing_storage_account.id : storage_account.id
output name string = useExisting ? existing_storage_account.name : storage_account.name

output storageAccountResource object = useExisting ? existing_storage_account : storage_account
