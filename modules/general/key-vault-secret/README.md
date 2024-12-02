# Adds or updates a Key Vault secret

Adds or updates a Key Vault secret

## Details

Deploys a secret to an existing Key Vault and returns its URI. If the secret is expected to already exist, the `useExisting` flag can be used to obtain the URI without modifying the underlying secret.

## Parameters

| Name           | Type           | Required | Description                                       |
| :------------- | :------------: | :------: | :------------------------------------------------ |
| `secretName`   | `string`       | Yes      | Enter the secret name.                            |
| `contentType`  | `string`       | No       | Type of the secret                                |
| `contentValue` | `securestring` | No       | Value of the secret                               |
| `keyVaultName` | `string`       | Yes      | Name of the vault                                 |
| `useExisting`  | `bool`         | No       | When true, a pre-existing secret will be returned |

## Outputs

| Name                   | Type     | Description                                         |
| :--------------------- | :------: | :-------------------------------------------------- |
| `secretUriWithVersion` | `string` | The key vault URI linking to the new/updated secret |

## Examples

### Example 1

```bicep
```

### Example 2

```bicep
```