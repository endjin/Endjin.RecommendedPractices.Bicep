// <copyright file="app-configuration.bicep" company="Endjin Limited">
// Copyright (c) Endjin Limited. All rights reserved.
// </copyright>

@description('The name of the app configuration store')
param name string

@description('The location of the app configuration store')
param location string

@description('When false, the app configuration store will be inaccessible via its public IP address')
param enablePublicNetworkAccess bool = true

@description('SKU for the app configuration store')
@allowed([
  'Free'
  'Standard'
])
param sku string = 'Standard'

@description('When true, the primary connection strings (read/write and read-only) will be written to the specified key vault')
param saveConnectionStringsToKeyVault bool = false

@description('The name of the key vault used to store the connection strings')
param keyVaultName string = ''

@description('The resource group containing the key vault used to store the connection strings')
param keyVaultResourceGroupName string = resourceGroup().name

@description('The ID of the subscription containing the key vault used to store the connection strings')
param keyVaultSubscriptionId string = subscription().subscriptionId

@description('The key vault secret name used to store the read/write connection string')
param keyVaultConnectionStringSecretName string = ''

@description('The key vault secret name used to store the read-only connection string')
param keyVaultReadOnlyConnectionStringSecretName string = ''

@description('When true, the details of an existing app configuration store will be returned; When false, the app configuration store is created/updated')
param useExisting bool = false

@description('The resource tags applied to resources')
param resourceTags object = {}


targetScope = 'resourceGroup'


resource existing_app_config_store 'Microsoft.AppConfiguration/configurationStores@2020-06-01' existing = if (useExisting) {
  name: name
}

var publicNetworkAccess = enablePublicNetworkAccess ? 'Enabled' : 'Disabled'
resource app_config_store 'Microsoft.AppConfiguration/configurationStores@2020-06-01' = if (!useExisting) {
  name: name
  location: location
  sku: {
    name: sku
  }
  properties: {
    publicNetworkAccess: publicNetworkAccess
  }
  tags: resourceTags
}

var acsConnectionString = useExisting ? existing_app_config_store.listKeys().value[0].connectionString : app_config_store.listKeys().value[0].connectionString

module connection_string_secret '../key-vault-secret/main.bicep' = if (saveConnectionStringsToKeyVault) {
  name: 'appConfigConnStrSecretDeploy${name}'
  scope: resourceGroup(keyVaultSubscriptionId, keyVaultResourceGroupName) 
  params: {
    keyVaultName: keyVaultName
    secretName: keyVaultConnectionStringSecretName
    contentValue: acsConnectionString
  }
}

var acsReadOnlyConnectionString = useExisting ? existing_app_config_store.listKeys().value[2].connectionString : app_config_store.listKeys().value[2].connectionString

module readonly_connection_string_secret '../key-vault-secret/main.bicep' = if (saveConnectionStringsToKeyVault) {
  name: 'appConfigRoConnStrSecretDeploy${name}'
  scope: resourceGroup(keyVaultSubscriptionId, keyVaultResourceGroupName) 
  params: {
    keyVaultName: keyVaultName
    secretName: keyVaultReadOnlyConnectionStringSecretName
    contentValue: acsReadOnlyConnectionString
  }
}

// Template outputs
@description('The resource ID of the app configuration store')
output id string = useExisting ? existing_app_config_store.id : app_config_store.id
@description('The name of the app configuration store')
output name string = useExisting ? existing_app_config_store.name : app_config_store.name

// Returns the full AppConfig Store resource object (workaround whilst resource types cannot be returned directly)
@description('An object representing the app configuration store resource')
output appConfigStoreResource object = useExisting ? existing_app_config_store : app_config_store
