@description('The name of the App Configuration Store.')
param appConfigStoreName string

@description('The name of the Key Vault instance.')
param keyVaultName string

@description('Optional label attribute to apply to the App Configuration key-values.')
param label string = ''

@description('An array of the key-value secrets to create/update. Expected properties for each item are `appConfigKey`, `secretName`, `secretValue`. See examples for more details.')
param keyValueSecrets array

resource app_config_store 'Microsoft.AppConfiguration/configurationStores@2020-06-01' existing = {
  name: appConfigStoreName
}

resource key_vault 'Microsoft.KeyVault/vaults@2021-06-01-preview' existing = {
  name: keyVaultName
}

module key_value_secrets '../app-config-key-vault-secret/main.bicep' = [for kvs in keyValueSecrets: {
  name: 'key_value_secret_${replace(kvs.secretName, ':', '--')}'
  params: {
    appConfigStoreName: app_config_store.name
    appConfigKey: kvs.appConfigKey
    secretName: kvs.secretName
    secretValue: kvs.secretValue
    keyVaultName: key_vault.name
    label: label
  }
}]

@description('An array containing each secret URI (with version) for all App Config key-values created/updated.')
output secretUris array = [for (kv, index) in keyValueSecrets: {
  appConfigKey: key_value_secrets[index].outputs.appConfigKey
  secretUriWithVersion: key_value_secrets[index].outputs.secretUriWithVersion
}]
