// <copyright file="storage-account.bicep" company="Endjin Limited">
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

@description('When false, access to the storage account is only possible via Azure AD authentication')
param allowSharedKeyAccess bool = true

@description('When true, disables access to the storage account via unencrypted HTTP connections')
param httpsOnly bool = true

@description('The access tier of the storage account')
param accessTier string = 'Hot'

@description('When true, enables Hierarchical Namespace feature, i.e. enabling Azure Data Lake Storage Gen2 capabilities')
param isHnsEnabled bool = false

@description('When true, enables SFTP feature. `isHnsEnabled` must also be set to true.')
param isSftpEnabled bool = false

@description('The optional network rules securing access to the storage account (ref: https://learn.microsoft.com/en-us/azure/templates/microsoft.storage/storageaccounts?pivots=deployment-language-bicep#networkruleset)')
param networkAcls object = {}

@description('When true, the primary storage access key will be written to the specified key vault')
param saveAccessKeyToKeyVault bool = false

@description('When true, the default connection string using the primary storage access key will be written to the specified key vault')
param saveConnectionStringToKeyVault bool = false

@description('The name of the key vault used to store the access key')
param keyVaultName string = ''

@description('The resource group containing the key vault used to store the access key')
param keyVaultResourceGroupName string = resourceGroup().name

@description('The ID of the subscription containing the key vault used to store the access key')
param keyVaultSubscriptionId string = subscription().subscriptionId

@description('The key vault secret name used to store the access key')
param keyVaultAccessKeySecretName string = ''

@description('The key vault secret name used to store the connection string')
param keyVaultConnectionStringSecretName string = ''

@description('When true, the details of an existing storage account will be returned; When false, the storage account is created/updated')
param useExisting bool = false

@description('The resource tags applied to resources')
param resource_tags object = {}


targetScope = 'resourceGroup'


resource existing_storage_account 'Microsoft.Storage/storageAccounts@2022-05-01' existing = if (useExisting) {
  name: name
}

resource storage_account 'Microsoft.Storage/storageAccounts@2022-05-01' = if (!useExisting) {
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
    isHnsEnabled: isHnsEnabled
    networkAcls: networkAcls
    isSftpEnabled: isSftpEnabled
    allowSharedKeyAccess: allowSharedKeyAccess
  }
  tags: resource_tags
}

// Accessing the 'listKeys()' function requires a reference to an actual resource
// which we can't currently get from a module.  This is why we don't follow the
// same pattern as other templates where this additional functionality would be in
// a separate template from the main storage account definition
module storage_access_key_secret '../key-vault-secret/main.bicep' = if (saveAccessKeyToKeyVault) {
  name: 'storageAccessKeySecretDeploy${name}'
  scope: resourceGroup(keyVaultSubscriptionId, keyVaultResourceGroupName) 
  params: {
    keyVaultName: keyVaultName
    secretName: keyVaultAccessKeySecretName
    contentValue: useExisting ? existing_storage_account.listKeys().keys[0].value : storage_account.listKeys().keys[0].value
  }
}

module storage_connection_string_secret '../key-vault-secret/main.bicep' = if (saveConnectionStringToKeyVault) {
  name: 'storageConnectionStringSecretDeploy${name}'
  scope: resourceGroup(keyVaultSubscriptionId, keyVaultResourceGroupName) 
  params: {
    keyVaultName: keyVaultName
    secretName: keyVaultConnectionStringSecretName
    contentValue: 'DefaultEndpointsProtocol=https;AccountName=${name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${useExisting ? existing_storage_account.listKeys().keys[0].value : storage_account.listKeys().keys[0].value}'
  }
}

// Template outputs
@description('The resource ID of the storage account')
output id string = useExisting ? existing_storage_account.id : storage_account.id
@description('The name of the storage account')
output name string = useExisting ? existing_storage_account.name : storage_account.name

// Returns the full Storage Account resource object (workaround whilst resource types cannot be returned directly)
@description('An object representing the storage account resource')
output storageAccountResource object = useExisting ? existing_storage_account : storage_account
