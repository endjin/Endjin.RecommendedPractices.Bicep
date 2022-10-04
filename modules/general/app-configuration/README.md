# App Configuration

Azure App Configuration

## Description

Deploys or updates an [App Configuration](https://azure.microsoft.com/en-gb/products/app-configuration/) resource.

Once the App Configuration instance is created, configuration keys can be created or updated using the [set-app-configuration-keys](https://github.com/endjin/Endjin.RecommendedPractices.Bicep/tree/main/modules/general/set-app-configuration-keys) module.

Keys which should be references to Azure Key Vault secrets can be added using the [app-config-key-vault-secret](https://github.com/endjin/Endjin.RecommendedPractices.Bicep/tree/main/modules/general/app-config-key-vault-secret) module.

It you need to add multiple keys referencing KeyVault secrets, the [app-config-key-vault-secrets](https://github.com/endjin/Endjin.RecommendedPractices.Bicep/tree/main/modules/general/app-config-key-vault-secrets) module can be used. 

If the resource is expected to already exist, the `useExisting` flag should be used. This will return the details of the resource without modifying it, but fail if the resource does not exist.

## Parameters

| Name                        | Type     | Required | Description                                                                                                                                |
| :-------------------------- | :------: | :------: | :----------------------------------------------------------------------------------------------------------------------------------------- |
| `name`                      | `string` | Yes      | The name of the app configuration store                                                                                                    |
| `location`                  | `string` | Yes      | The location of the app configuration store                                                                                                |
| `enablePublicNetworkAccess` | `bool`   | No       | When false, the app configuration store will be inaccessible via its public IP address                                                     |
| `sku`                       | `string` | No       | SKU for the app configuration store                                                                                                        |
| `useExisting`               | `bool`   | No       | When true, the details of an existing app configuration store will be returned; When false, the app configuration store is created/updated |
| `resourceTags`              | `object` | No       | The resource tags applied to resources                                                                                                     |

## Outputs

| Name                   | Type   | Description                                                 |
| :--------------------- | :----: | :---------------------------------------------------------- |
| id                     | string | The resource ID of the app configuration store              |
| name                   | string | The name of the app configuration store                     |
| appConfigStoreResource | object | An object representing the app configuration store resource |

## Examples

Something here.

### Example 1

```bicep
```

### Example 2

```bicep
```