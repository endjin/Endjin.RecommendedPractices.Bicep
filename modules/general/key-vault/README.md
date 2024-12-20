# Key Vault with optional diagnostics settings

Deploys a key vault with optional diagnostics written to blob storage.

## Details

Deploys or updates a [Key Vault](https://azure.microsoft.com/en-us/products/key-vault/) resource, supporting the following configuration options:

* Azure Storage based diagnostic settings
* Network access control lists
* Use of Azure RBAC instead of Key Vault Access Policies

If the resource is expected to already exist, the `useExisting` flag should be used. This will return the details of the resource without modifying it, but fail if the resource does not exist.

Once the Key Vault is created, secrets can be added via the [`key-vault-secret`](https://github.com/endjin/Endjin.RecommendedPractices.Bicep/tree/main/modules/general/key-vault-secret) module.

## Parameters

| Name                            | Type     | Required | Description                                                                                                                                                                                                             |
| :------------------------------ | :------: | :------: | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `name`                          | `string` | Yes      | The name of the key vault                                                                                                                                                                                               |
| `sku`                           | `string` | No       | SKU for the key vault                                                                                                                                                                                                   |
| `accessPolicies`                | `array`  | No       | The access policies for the key vault                                                                                                                                                                                   |
| `tenantId`                      | `string` | Yes      | The Azure tenantId of the key vault                                                                                                                                                                                     |
| `location`                      | `string` | Yes      | The location of the key vault                                                                                                                                                                                           |
| `networkAcls`                   | `object` | No       | The optional network rules securing access to the key vault (ref: https://learn.microsoft.com/en-us/azure/templates/microsoft.keyvault/vaults#networkruleset)                                                           |
| `enableRbacAuthorization`       | `bool`   | No       | When true, the key vault uses Azure RBAC-based access controls and any specified access policy will be ignored                                                                                                          |
| `enabledForDeployment`          | `bool`   | No       | When true, the key vault will be accessible by deployments                                                                                                                                                              |
| `enabledForDiskEncryption`      | `bool`   | No       | When true, the key vault will be accessible for disk encryption                                                                                                                                                         |
| `enabledForTemplateDeployment`  | `bool`   | No       | When true, the key vault will be accessible by ARM deployments                                                                                                                                                          |
| `enableSoftDelete`              | `bool`   | Yes      | When true, 'soft delete' functionality is enabled for this key vault. Once set to true, it cannot be reverted to false.                                                                                                 |
| `softDeleteRetentionInDays`     | `int`    | No       | Sets the retention policy if this key vault is soft deleted                                                                                                                                                             |
| `enableDiagnostics`             | `bool`   | Yes      | When true, diagnostics settings will be enabled for the key vault                                                                                                                                                       |
| `enablePublicAccess`            | `bool`   | No       | When false, the vault will not accept traffic from public internet. (i.e. all traffic except private endpoint traffic and that that originates from trusted services will be blocked, regardless of any firewall rules) |
| `enablePurgeProtection`         | `bool`   | Yes      | When true, the key vault will have purge protection enabled                                                                                                                                                             |
| `diagnosticsStorageAccountName` | `string` | No       | The storage account name to be used for key vault diagnostic settings                                                                                                                                                   |
| `useExistingStorageAccount`     | `bool`   | No       | When true, an existing storage account be used for diagnotics settings; When false, the storage account is created/updated                                                                                              |
| `diagnosticsRetentionDays`      | `int`    | No       | Sets the retention policy for diagnostics settings data, in days                                                                                                                                                        |
| `useExisting`                   | `bool`   | No       | When true, the details of an existing key vault will be returned; When false, the key vault is created/updated                                                                                                          |
| `resourceTags`                  | `object` | No       | The resource tags applied to resources                                                                                                                                                                                  |

## Outputs

| Name               | Type     | Description                                   |
| :----------------- | :------: | :-------------------------------------------- |
| `id`               | `string` | The resource ID of the key vault              |
| `name`             | `string` | The name of the key vault                     |
| `keyVaultResource` | `object` | An object representing the key vault resource |

## Examples

### Key Vault with diagnostics logs to Storage Account

```bicep
module keyvault 'br:<registry-fqdn>/bicep/general/key-vault:<version>' = {
  name: 'keyVaultWithDiagsDeploy'
  params: {
    enableDiagnostics: true
    name: 'mykeyvault'
    tenantId: tenant().tenantId
    location: location
    enableSoftDelete: false
  }
}
```

### Key Vault with network access controls

```bicep
resource vnet 'Microsoft.Network/virtualNetworks@2021-08-01' existing = {
  name: 'myvirtualnetwork'
  scope: resourceGroup('my-networking-resource-group')
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2021-08-01' existing = {
    name: 'default'
    parent: vnet
}

module keyvault 'br:<registry-fqdn>/bicep/general/key-vault:<version>' = {
  name: 'keyVaultWithNetworkAcl'
  params: {
    enableDiagnostics: false
    name: 'mykeyvault'
    tenantId: tenant().tenantId
    location: location
    enableSoftDelete: false
    enableRbacAuthorization: false
    networkAcls: {              // ref: https://learn.microsoft.com/en-us/azure/templates/microsoft.keyvault/vaults?pivots=deployment-language-bicep#networkruleset
      bypass: 'AzureServices'
      defaultAction: 'Deny'
      ipRule: [                 // ref: https://learn.microsoft.com/en-us/azure/templates/microsoft.keyvault/vaults#iprule
        '90.255.204.0/24'
        '90.255.100.2'
      ]
      virtualNetworkRules: [   // ref: https://learn.microsoft.com/en-us/azure/templates/microsoft.keyvault/vaults#virtualnetworkrule
        {
          id: subnet.id
          ignoreMissingVnetServiceEndpoint: false
        }
      ]
    }
  }
}
```