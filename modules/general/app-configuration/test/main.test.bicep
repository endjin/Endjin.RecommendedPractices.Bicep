param prefix string = uniqueString(resourceGroup().id)
param location string = resourceGroup().location

module appconfig '../main.bicep' = {
  name: 'appConfig'
  params: {
    name: '${prefix}appconfig'
    location: location
  }
}


module key_vault '../../key-vault/main.bicep' = {
  name: 'keyVaultDeploy'
  params: {
    enableDiagnostics: false
    enableSoftDelete: false
    location: location
    name: '${prefix}kv'
    tenantId: tenant().tenantId
  }
}

module appconfig_with_connection_strings_in_kv  '../main.bicep' = {
  name: 'appConfigWithConnectionStringsInKv'
  params: {
    name: '${prefix}appconfigkv'
    location: location
    saveConnectionStringsToKeyVault: true
    keyVaultSubscriptionId: subscription().subscriptionId
    keyVaultResourceGroupName: resourceGroup().name
    keyVaultName: key_vault.outputs.name
    keyVaultConnectionStringSecretName: 'AppConfigConnectionString'
    keyVaultReadOnlyConnectionStringSecretName: 'AppConfigReadOnlyConnectionString'
  }
}

