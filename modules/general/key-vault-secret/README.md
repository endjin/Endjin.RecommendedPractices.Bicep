# Adds or updates a Key Vault secret

Adds or updates a Key Vault secret

## Parameters

| Name           | Type           | Required | Description                                       |
| :------------- | :------------: | :------: | :------------------------------------------------ |
| `secretName`   | `string`       | Yes      | Enter the secret name.                            |
| `contentType`  | `string`       | No       | Type of the secret                                |
| `contentValue` | `secureString` | No       | Value of the secret                               |
| `keyVaultName` | `string`       | Yes      | Name of the vault                                 |
| `useExisting`  | `bool`         | No       | When true, a pre-existing secret will be returned |

## Outputs

| Name                 | Type   | Description                                         |
| :------------------- | :----: | :-------------------------------------------------- |
| secretUriWithVersion | string | The key vault URI linking to the new/udpated secret |

## Examples

### Example 1

```bicep
```

### Example 2

```bicep
```