// <copyright file="storage_account.bicep" company="Endjin Limited">
// Copyright (c) Endjin Limited. All rights reserved.
// </copyright>

@description('The name of the storage account')
param name string

@description('The location of the storage account')
param location string = resourceGroup().location

@description('The SKU of the storage account')
param sku string = 'Standard_LRS'

@description('The kind of the storage account')
param kind string = 'StorageV2'

@description('The minimum TLS version required by the storage account')
param tlsVersion string = 'TLS1_2'

@description('When true, disables access to the storage account via unencrypted HTTP connections')
param httpsOnly bool = true

@description('The access tier of the storage account')
param accessTier string = 'Hot'

@description('When true, the primary storage access key will be written to the specified key vault')
param saveAccessKeyToKeyVault bool = false

@description('The name of the key vault used to store the access key')
param keyVaultName string = ''

@description('The resource group containing the key vault used to store the access key')
param keyVaultResourceGroupName string = resourceGroup().name

@description('The subscription containing the key vault used to store the access key')
param keyVaultSubscriptionName string = subscription().subscriptionId

@description('The key vault secret name used to store the access key')
param keyVaultSecretName string = ''

@description('When true, the details of an existing storage account will be returned; When false, the storage account is created/udpated')
param useExisting bool = false

@description('The resource tags applied to resources')
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

// Accessing the 'listKeys()' function requires a reference to an actual resource
// which we can't currently get from a module.  This is why we don't follow the
// same pattern as other templates where this additional functionality would be in
// a separate template from the main storage account definition
module storage_access_key_secret 'key_vault_secret.bicep' = if (saveAccessKeyToKeyVault) {
  name: 'storageSecretDeploy'
  scope: resourceGroup(keyVaultSubscriptionName, keyVaultResourceGroupName) 
  params: {
    keyVaultName: keyVaultName
    secretName: keyVaultSecretName
    contentValue: useExisting ? existing_storage_account.listKeys().keys[0].value : storage_account.listKeys().keys[0].value
  }
}


output id string = useExisting ? existing_storage_account.id : storage_account.id
output name string = useExisting ? existing_storage_account.name : storage_account.name

output storageAccountResource object = useExisting ? existing_storage_account : storage_account
