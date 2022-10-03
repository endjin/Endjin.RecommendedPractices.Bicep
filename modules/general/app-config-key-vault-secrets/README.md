# App Configuration Key Vault Secrets

Adds or updates multiple App Configuration key-values backed by Azure Key Vault secrets.

## Description

This module is an extension of [App Configuration Key Vault Secret](../app-config-key-vault-secret/README.md) which allows you to set multiple App Configuration key-values with references to Azure Key Vault secrets.

## Parameters

| Name                 | Type     | Required | Description                                                                                                                                                           |
| :------------------- | :------: | :------: | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `appConfigStoreName` | `string` | Yes      | The name of the App Configuration Store.                                                                                                                              |
| `keyVaultName`       | `string` | Yes      | The name of the Key Vault instance.                                                                                                                                   |
| `label`              | `string` | No       | Optional label attribute to apply to the App Configuration key-values.                                                                                                |
| `keyValueSecrets`    | `array`  | Yes      | An array of the key-value secrets to create/update. Expected properties for each item are `appConfigKey`, `secretName`, `secretValue`. See examples for more details. |

## Outputs

| Name       | Type  | Description                                                                                       |
| :--------- | :---: | :------------------------------------------------------------------------------------------------ |
| secretUris | array | An array containing each secret URI (with version) for all App Config key-values created/updated. |

## Examples

### Setting multiple key-value secrets

```bicep
module ackvs 'br:<registry-fqdn>/bicep/general/app-config-key-vault-secrets:<version>' = {
  name: 'ackvs'
  params: {
    appConfigStoreName: 'myappconfigstore'
    keyVaultName: 'mykeyvault'
    keyValueSecrets: [
      // New secret, default App Configuration key
      {
        appConfigKey: ''
        secretName: 'secret1'
        secretValue: 'p@55w0rd1!'
      }
      // New secret, custom App Configuration key
      {
        appConfigKey: 'MyPassword'
        secretName: 'secret2'
        secretValue: 'p@55w0rd2!'
      }
      // Existing secret, default App Configuration key
      {
        appConfigKey: ''
        secretName: 'secret3'
        secretValue: ''
      }
      // Existing secret, custom App Configuration key
      {
        appConfigKey: 'MyOtherPassword'
        secretName: 'secret4'
        secretValue: ''
      }
    ]
  }
}
```