@description('Optional value for the key in App Configuration. If left blank, the key will be set to the (sanitized) secret name.')
param appConfigKey string = ''

@description('The name of the secret in Key Vault (either existing or to be created).')
param secretName string

@secure()
@description('Optional value to set as the secret. If left blank, a secret with the provided `secretName` must already exist in Key Vault.')
param secretValue string = ''

@description('The name of the App Configuration Store.')
param appConfigStoreName string

@description('The name of the Key Vault instance.')
param keyVaultName string

@description('Optional label attribute to apply to the App Configuration key-value.')
param label string = ''

resource app_config_store 'Microsoft.AppConfiguration/configurationStores@2020-06-01' existing = {
  name: appConfigStoreName
}

var secretNameSanitized = !empty(secretValue) ? replace(secretName, ':', '--') : secretName
module secret '../key-vault-secret/main.bicep' = {
  name: secretNameSanitized
  params: {
    secretName: secretNameSanitized
    keyVaultName: keyVaultName
    useExisting: empty(secretValue)
    contentValue: empty(secretValue) ? '' : secretValue
  }
}

var keyVaultSecretRef = {
    uri: secret.outputs.secretUriWithVersion
}

var sanitisedAppConfigKey = '${replace(replace(uriComponent(empty(appConfigKey) ? secretName : appConfigKey), '~', '~7E'), '%', '~')}${empty(label) ? '' : '$${label}'}'

resource key_value 'Microsoft.AppConfiguration/configurationStores/keyValues@2021-03-01-preview' = {
  name: sanitisedAppConfigKey
  parent: app_config_store
  properties: {
      contentType: 'application/vnd.microsoft.appconfig.keyvaultref+json;charset=utf-8'
      value: string(keyVaultSecretRef)
    }
}

@description('The secret URI (with version) of the secret backing the App Configuration key-value.')
output secretUriWithVersion string = secret.outputs.secretUriWithVersion
@description('The key for the App Configuration key-value.')
output appConfigKey string = sanitisedAppConfigKey
