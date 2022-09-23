# App Configuration Key Vault Secret

Adds or updates an App Configuration key-value backed by an Azure Key Vault secret.

## Description

Adds or updates an App Configuration key-value with a reference to an Azure Key Vault secret and sets the relevant content-type (`application/vnd.microsoft.appconfig.keyvaultref+json;charset=utf-8`).

Some libraries and tools can understand the linked secret reference and retrieve the underlying secret value for the given App Configuration key (e.g. see [ASP.NET Core example](https://learn.microsoft.com/en-us/azure/azure-app-configuration/use-key-vault-references-dotnet-core)).

This module allows for either using existing Key Vault secrets and for automatically creating new secrets with a given value.

## Parameters

| Name                 | Type           | Required | Description                                                                                                                  |
| :------------------- | :------------: | :------: | :--------------------------------------------------------------------------------------------------------------------------- |
| `appConfigKey`       | `string`       | No       | Optional value for the key in App Configuration. If left blank, the key will be set to the (sanitized) secret name.          |
| `secretName`         | `string`       | Yes      | The name of the secret in Key Vault (either existing or to be created).                                                      |
| `secretValue`        | `secureString` | No       | Optional value to set as the secret. If left blank, a secret with the provided `secretName` must already exist in Key Vault. |
| `appConfigStoreName` | `string`       | Yes      | The name of the App Configuration Store.                                                                                     |
| `keyVaultName`       | `string`       | Yes      | The name of the Key Vault instance.                                                                                          |
| `label`              | `string`       | No       | Optional label attribute to apply to the App Configuration key-value.                                                        |

## Outputs

| Name                 | Type   | Description                                                                          |
| :------------------- | :----: | :----------------------------------------------------------------------------------- |
| secretUriWithVersion | string | The secret URI (with version) of the secret backing the App Configuration key-value. |
| appConfigKey         | string | The key for the App Configuration key-value.                                         |

## Examples

### Create key-value with new secret

```bicep
module ackvs 'br:<registry-fqdn>/bicep/general/app-config-key-vault-secret:<version>' = {
  name: 'ackvs'
  params: {
    appConfigStoreName: 'myappconfigstore'
    keyVaultName: 'mykeyvault'
    secretName: 'mysecret'
    secretValue: 's3cr3t!'
  }
}
```

### Create key-value using an existing secret

```bicep
module ackvs 'br:<registry-fqdn>/bicep/general/app-config-key-vault-secret:<version>' = {
  name: 'ackvs'
  params: {
    appConfigStoreName: 'myappconfigstore'
    keyVaultName: 'mykeyvault'
    secretName: 'mysecret' // This secret must already exist in the 'mykeyvault' Key Vault
  }
}
```