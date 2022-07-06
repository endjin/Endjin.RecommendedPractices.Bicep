# Key Vault with optional diagnostics settings

Deploys a key vault with optional diagnostics written to blob storage.

## Description

Deploys a key vault with optional diagnostics written to blob storage.

## Parameters

| Name                            | Type     | Required | Description                                                                                                                |
| :------------------------------ | :------: | :------: | :------------------------------------------------------------------------------------------------------------------------- |
| `name`                          | `string` | Yes      | The name of the key vault                                                                                                  |
| `sku`                           | `string` | No       | SKU for the key vault                                                                                                      |
| `accessPolicies`                | `array`  | No       | The access policies for the key vault                                                                                      |
| `tenantId`                      | `string` | Yes      | The Azure tenantId of the key vault                                                                                        |
| `location`                      | `string` | Yes      | The location of the key vault                                                                                              |
| `enabledForDeployment`          | `bool`   | No       | When true, the key vault will be accessible by deployments                                                                 |
| `enabledForDiskEncryption`      | `bool`   | No       | When true, the key vault will be accessible for disk encryption                                                            |
| `enabledForTemplateDeployment`  | `bool`   | No       | When true, the key vault will be accessible by ARM deployments                                                             |
| `enableDiagnostics`             | `bool`   | Yes      | When true, diagnostics settings will be enabled for the key vault                                                          |
| `diagnosticsStorageAccountName` | `string` | No       | The storage account name to be used for key vault diagnostic settings                                                      |
| `useExistingStorageAccount`     | `bool`   | No       | When true, an existing storage account be used for diagnotics settings; When false, the storage account is created/updated |
| `diagnosticsRetentionDays`      | `int`    | No       | Sets the retention policy for diagnostics settings data, in days                                                           |
| `useExisting`                   | `bool`   | No       | When true, the details of an existing key vault will be returned; When false, the key vault is created/updated             |
| `resourceTags`                  | `object` | No       | The resource tags applied to resources                                                                                     |

## Outputs

| Name             | Type   | Description                                   |
| :--------------- | :----: | :-------------------------------------------- |
| id               | string | The resource ID of the key vault              |
| name             | string | The name of the key vault                     |
| keyVaultResource | object | An object representing the key vault resource |

## Examples

### Example 1

```bicep
```

### Example 2

```bicep
```