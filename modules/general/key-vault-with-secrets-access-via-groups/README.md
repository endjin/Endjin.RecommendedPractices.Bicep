# Key Vault with group-based access policy

Deploys a Key Vault with a secrets access policy managed via group membership

## Description

{{ Add detailed description for the module. }}

## Parameters

| Name                               | Type     | Required | Description                                                                                                                |
| :--------------------------------- | :------: | :------: | :------------------------------------------------------------------------------------------------------------------------- |
| `name`                             | `string` | Yes      | The name of the key vault                                                                                                  |
| `secretsReadersGroupObjectId`      | `string` | Yes      | The AzureAD objectId for the group to be granted "get" access to secrets                                                   |
| `secretsReadersPermissions`        | `array`  | No       | The list of secret permissions granted to the "reader" group                                                               |
| `secretsContributorsGroupObjectId` | `string` | Yes      | The AzureAD objectId for the group to be granted "get" & "set" access to secrets                                           |
| `secretsContributorsPermissions`   | `array`  | No       | The list of secret permissions granted to the "contributors" group                                                         |
| `tenantId`                         | `string` | Yes      | The Azure tenantId of the key vault                                                                                        |
| `enabledForDeployment`             | `bool`   | No       | When true, the key vault will be accessible by deployments                                                                 |
| `enabledForDiskEncryption`         | `bool`   | No       | When true, the key vault will be accessible for disk encryption                                                            |
| `enabledForTemplateDeployment`     | `bool`   | No       | When true, the key vault will be accessible by ARM deployments                                                             |
| `enableDiagnostics`                | `bool`   | Yes      | When true, diagnostics settings will be enabled for the key vault                                                          |
| `diagnosticsStorageAccountName`    | `string` | No       | The storage account name to be used for key vault diagnostic settings                                                      |
| `useExistingStorageAccount`        | `bool`   | No       | When true, an existing storage account be used for diagnotics settings; When false, the storage account is created/updated |
| `diagnosticsRetentionDays`         | `int`    | No       | Sets the retention policy for diagnostics settings data, in days                                                           |
| `location`                         | `string` | No       | The location of the key vault                                                                                              |
| `resourceTags`                     | `object` | No       | The resource tags applied to resources                                                                                     |

## Outputs

| Name             | Type   | Description                                   |
| :--------------- | :----: | :-------------------------------------------- |
| id               | string | The objectId of the key vault                 |
| name             | string | The name of the key vault                     |
| keyVaultResource | object | An object representing the key vault resource |

## Examples

### Example 1

```bicep
```

### Example 2

```bicep
```