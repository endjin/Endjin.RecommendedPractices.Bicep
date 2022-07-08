# Storage Account

Deploys a storage account or returns a reference to an existing one.

## Description

Deploys a storage account or returns a reference to an existing one - typically only used where scoping constraints prevent direct use of the raw resource.

## Parameters

| Name                        | Type     | Required | Description                                                                                                                |
| :-------------------------- | :------: | :------: | :------------------------------------------------------------------------------------------------------------------------- |
| `name`                      | `string` | Yes      | The name of the storage account                                                                                            |
| `location`                  | `string` | No       | The location of the storage account                                                                                        |
| `sku`                       | `string` | No       | The SKU of the storage account                                                                                             |
| `kind`                      | `string` | No       | The kind of the storage account                                                                                            |
| `tlsVersion`                | `string` | No       | The minimum TLS version required by the storage account                                                                    |
| `httpsOnly`                 | `bool`   | No       | When true, disables access to the storage account via unencrypted HTTP connections                                         |
| `accessTier`                | `string` | No       | The access tier of the storage account                                                                                     |
| `saveAccessKeyToKeyVault`   | `bool`   | No       | When true, the primary storage access key will be written to the specified key vault                                       |
| `keyVaultName`              | `string` | No       | The name of the key vault used to store the access key                                                                     |
| `keyVaultResourceGroupName` | `string` | No       | The resource group containing the key vault used to store the access key                                                   |
| `keyVaultSubscriptionName`  | `string` | No       | The subscription containing the key vault used to store the access key                                                     |
| `keyVaultSecretName`        | `string` | No       | The key vault secret name used to store the access key                                                                     |
| `useExisting`               | `bool`   | No       | When true, the details of an existing storage account will be returned; When false, the storage account is created/updated |
| `resource_tags`             | `object` | No       | The resource tags applied to resources                                                                                     |

## Outputs

| Name                   | Type   | Description                                         |
| :--------------------- | :----: | :-------------------------------------------------- |
| id                     | string | The resource ID of the storage account              |
| name                   | string | The name of the storage account                     |
| storageAccountResource | object | An object representing the storage account resource |

## Examples

### Example 1

```bicep
```

### Example 2

```bicep
```