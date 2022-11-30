# Storage Account

Deploys a storage account or returns a reference to an existing one.

## Description

Deploys a storage account or returns a reference to an existing one - typically only used where scoping constraints prevent direct use of the raw resource.

## Parameters

| Name                                 | Type     | Required | Description                                                                                                                                                                                                  |
| :----------------------------------- | :------: | :------: | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `name`                               | `string` | Yes      | The name of the storage account                                                                                                                                                                              |
| `location`                           | `string` | No       | The location of the storage account                                                                                                                                                                          |
| `sku`                                | `string` | No       | The SKU of the storage account                                                                                                                                                                               |
| `kind`                               | `string` | No       | The kind of the storage account                                                                                                                                                                              |
| `tlsVersion`                         | `string` | No       | The minimum TLS version required by the storage account                                                                                                                                                      |
| `httpsOnly`                          | `bool`   | No       | When true, disables access to the storage account via unencrypted HTTP connections                                                                                                                           |
| `accessTier`                         | `string` | No       | The access tier of the storage account                                                                                                                                                                       |
| `isHnsEnabled`                       | `bool`   | No       | When true, enables Hierarchical Namespace feature, i.e. enabling Azure Data Lake Storage Gen2 capabilities                                                                                                   |
| `isSftpEnabled`                      | `bool`   | No       | When true, enables SFTP feature. `isHnsEnabled` must also be set to true.                                                                                                                                    |
| `networkAcls`                        | `object` | No       | The optional network rules securing access to the storage account (ref: https://learn.microsoft.com/en-us/azure/templates/microsoft.storage/storageaccounts?pivots=deployment-language-bicep#networkruleset) |
| `saveAccessKeyToKeyVault`            | `bool`   | No       | When true, the primary storage access key will be written to the specified key vault                                                                                                                         |
| `saveConnectionStringToKeyVault`     | `bool`   | No       | When true, the default connection string using the primary storage access key will be written to the specified key vault                                                                                     |
| `keyVaultName`                       | `string` | No       | The name of the key vault used to store the access key                                                                                                                                                       |
| `keyVaultResourceGroupName`          | `string` | No       | The resource group containing the key vault used to store the access key                                                                                                                                     |
| `keyVaultSubscriptionId`             | `string` | No       | The ID of the subscription containing the key vault used to store the access key                                                                                                                             |
| `keyVaultAccessKeySecretName`        | `string` | No       | The key vault secret name used to store the access key                                                                                                                                                       |
| `keyVaultConnectionStringSecretName` | `string` | No       | The key vault secret name used to store the connection string                                                                                                                                                |
| `useExisting`                        | `bool`   | No       | When true, the details of an existing storage account will be returned; When false, the storage account is created/updated                                                                                   |
| `resource_tags`                      | `object` | No       | The resource tags applied to resources                                                                                                                                                                       |

## Outputs

| Name                   | Type   | Description                                         |
| :--------------------- | :----: | :-------------------------------------------------- |
| id                     | string | The resource ID of the storage account              |
| name                   | string | The name of the storage account                     |
| storageAccountResource | object | An object representing the storage account resource |

## Examples

### Storage with defaults

```bicep
module storage 'br:<registry-fqdn>/bicep/general/storage-account:<version>' = {
  name: 'storage'
  params: {
    name: 'mystorage'
    location: location
  }
}
```

### Storage with hierarchical namespaces (ADLS gen2)

```bicep
module storage_with_hns 'br:<registry-fqdn>/bicep/general/storage-account:<version>' = {
  name: 'storageWithHns'
  params: {
    name: 'mystorage'
    location: location
    isHnsEnabled: true
  }
}
```

### Storage with network access controls

```bicep
resource vnet 'Microsoft.Network/virtualNetworks@2021-08-01' existing = {
    name: 'myvirtualnetwork'
    scope: resourceGroup('my-networking-resource-group')
}
resource subnet 'Microsoft.Network/virtualNetworks/subnets@2021-08-01' existing = {
    name: 'default'
    parent: vnet
}

module storage 'br:<registry-fqdn>/bicep/general/storage-account:<version>' = {
  name: 'storageWithNetworkAcls'
  params: {
    name: 'mystorage'
    location: location
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
      ipRule: [                 // ref: https://learn.microsoft.com/en-us/azure/templates/microsoft.storage/storageaccounts?pivots=deployment-language-bicep#iprule
        '90.255.204.0/24'
      ]
      virtualNetworkRules: [   // ref: https://learn.microsoft.com/en-us/azure/templates/microsoft.storage/storageaccounts?pivots=deployment-language-bicep#virtualnetworkrule
        {
          id: '${vnet.id}/subnets/${subnetName}'
          ignoreMissingVnetServiceEndpoint: false
        }
      ]
    }
  }
}
```