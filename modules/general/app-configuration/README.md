# App Configuration

Azure App Configuration

## Description

Deploys an instance of Azure App Configuration, optionally storing the primary connection strings in Azure Key Vault.

## Parameters

| Name                                         | Type     | Required | Description                                                                                                                                |
| :------------------------------------------- | :------: | :------: | :----------------------------------------------------------------------------------------------------------------------------------------- |
| `name`                                       | `string` | Yes      | The name of the app configuration store                                                                                                    |
| `location`                                   | `string` | Yes      | The location of the app configuration store                                                                                                |
| `enablePublicNetworkAccess`                  | `bool`   | No       | When false, the app configuration store will be inaccessible via its public IP address                                                     |
| `sku`                                        | `string` | No       | SKU for the app configuration store                                                                                                        |
| `saveConnectionStringsToKeyVault`            | `bool`   | No       | When true, the primary connection strings (read/write and read-only) will be written to the specified key vault                            |
| `keyVaultName`                               | `string` | No       | The name of the key vault used to store the connection strings                                                                             |
| `keyVaultResourceGroupName`                  | `string` | No       | The resource group containing the key vault used to store the connection strings                                                           |
| `keyVaultSubscriptionId`                     | `string` | No       | The ID of the subscription containing the key vault used to store the connection strings                                                   |
| `keyVaultConnectionStringSecretName`         | `string` | No       | The key vault secret name used to store the read/write connection string                                                                   |
| `keyVaultReadOnlyConnectionStringSecretName` | `string` | No       | The key vault secret name used to store the read-only connection string                                                                    |
| `useExisting`                                | `bool`   | No       | When true, the details of an existing app configuration store will be returned; When false, the app configuration store is created/updated |
| `resourceTags`                               | `object` | No       | The resource tags applied to resources                                                                                                     |

## Outputs

| Name                   | Type   | Description                                                 |
| :--------------------- | :----: | :---------------------------------------------------------- |
| id                     | string | The resource ID of the app configuration store              |
| name                   | string | The name of the app configuration store                     |
| appConfigStoreResource | object | An object representing the app configuration store resource |

## Examples

### Deploy a standard App Configuration instance

```bicep
module appconfig 'br:<registry-fqdn>/bicep/general/app-configuration:<version>'  = {
  name: 'appConfig'
  params: {
    name: 'myappconfig'
    location: location
    sku: 'Standard
  }
}
```

### Deploy App Configuration and save connection strings in Key Vault

```bicep
module appconfig 'br:<registry-fqdn>/bicep/general/app-configuration:<version>'  = {
  name: 'appConfig'
  params: {
    name: 'myappconfig'
    location: location
    saveConnectionStringsToKeyVault: true
    keyVaultSubscriptionId: subscription().subscriptionId
    keyVaultResourceGroupName: 'my-key-vault-resource-group'
    keyVaultName: 'mykeyvault'
    keyVaultConnectionStringSecretName: 'AppConfigConnectionString'
    keyVaultReadOnlyConnectionStringSecretName: 'AppConfigReadOnlyConnectionString'
  }
}
```