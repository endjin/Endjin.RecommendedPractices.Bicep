# Key Vault with group-based access policy

Deploys a Key Vault with a secrets access policy managed via group membership

## Description

Deploys a Key Vault with a secrets access policy managed via group membership. This does **not** use Key Vault's Azure RBAC feature, instead it generates a suitable Key Vault Access Policy that grants the relevant permissions to the specified Azure Active Directory groups.

This module can also be used to optionally configure:

* Azure Storage based diagnostic settings
* Network access control lists

## Parameters

| Name                               | Type     | Required | Description                                                                                                                                                   |
| :--------------------------------- | :------: | :------: | :------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `name`                             | `string` | Yes      | The name of the key vault                                                                                                                                     |
| `sku`                              | `string` | No       | SKU for the key vault                                                                                                                                         |
| `secretsReadersGroupObjectId`      | `string` | Yes      | The AzureAD objectId for the group to be granted "get" access to secrets                                                                                      |
| `secretsReadersPermissions`        | `array`  | No       | The list of secret permissions granted to the "reader" group                                                                                                  |
| `secretsContributorsGroupObjectId` | `string` | Yes      | The AzureAD objectId for the group to be granted "get" & "set" access to secrets                                                                              |
| `secretsContributorsPermissions`   | `array`  | No       | The list of secret permissions granted to the "contributors" group                                                                                            |
| `tenantId`                         | `string` | Yes      | The Azure tenantId of the key vault                                                                                                                           |
| `networkAcls`                      | `object` | No       | The optional network rules securing access to the key vault (ref: https://learn.microsoft.com/en-us/azure/templates/microsoft.keyvault/vaults#networkruleset) |
| `enabledForDeployment`             | `bool`   | No       | When true, the key vault will be accessible by deployments                                                                                                    |
| `enabledForDiskEncryption`         | `bool`   | No       | When true, the key vault will be accessible for disk encryption                                                                                               |
| `enabledForTemplateDeployment`     | `bool`   | No       | When true, the key vault will be accessible by ARM deployments                                                                                                |
| `enableSoftDelete`                 | `bool`   | Yes      | When true, 'soft delete' functionality is enabled for this key vault. Once set to true, it cannot be reverted to false.                                       |
| `softDeleteRetentionInDays`        | `int`    | No       | Sets the retention policy if this key vault is soft deleted                                                                                                   |
| `enableDiagnostics`                | `bool`   | Yes      | When true, diagnostics settings will be enabled for the key vault                                                                                             |
| `diagnosticsStorageAccountName`    | `string` | No       | The storage account name to be used for key vault diagnostic settings                                                                                         |
| `useExistingStorageAccount`        | `bool`   | No       | When true, an existing storage account be used for diagnotics settings; When false, the storage account is created/updated                                    |
| `diagnosticsRetentionDays`         | `int`    | No       | Sets the retention policy for diagnostics settings data, in days                                                                                              |
| `location`                         | `string` | No       | The location of the key vault                                                                                                                                 |
| `resourceTags`                     | `object` | No       | The resource tags applied to resources                                                                                                                        |

## Outputs

| Name             | Type   | Description                                   |
| :--------------- | :----: | :-------------------------------------------- |
| id               | string | The objectId of the key vault                 |
| name             | string | The name of the key vault                     |
| keyVaultResource | object | An object representing the key vault resource |

## Examples

### Basic Key Vault scenario

```bicep
module keyvault 'br:<registry-fqdn>/bicep/general/key-vault-with-secrets-access-via-groups:<version>' = {
  name: 'keyVaultDeploy'
  params: {
    enableDiagnostics: false
    name: 'mykeyvault'
    secretsContributorsGroupObjectId: 'b25d487e-5d8a-4831-a999-d7188af2de6a'        // my-secrets-contributors-group
    secretsReadersGroupObjectId: 'eb8de687-f669-40bf-9c84-cecce0799d74'             // my-secrets-readers-group
    tenantId: '<azure-tenant-id>'
    location: location
    enableSoftDelete: false
  }
}
```

### Key Vault with diagnostics & network access controls

```bicep
resource vnet 'Microsoft.Network/virtualNetworks@2021-08-01' existing = {
  name: 'myvirtualnetwork'
  scope: resourceGroup('my-networking-resource-group')
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2021-08-01' existing = {
    name: 'default'
    parent: vnet
}

module keyvault 'br:<registry-fqdn>/bicep/general/key-vault-with-secrets-access-via-groups:<version>' = {
  name: 'keyVaultDeploy'
  params: {
    enableDiagnostics: true
    name: 'mykeyvault'
    secretsContributorsGroupObjectId: 'b25d487e-5d8a-4831-a999-d7188af2de6a'        // my-secrets-contributors-group
    secretsReadersGroupObjectId: 'eb8de687-f669-40bf-9c84-cecce0799d74'             // my-secrets-readers-group
    tenantId: '<azure-tenant-id>'
    location: location
    enableSoftDelete: false
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