# Storage Account RBAC

Applies an RBAC role to a storage account

## Description

Applies an RBAC role to an existing storage account. Currently supports the following roles:

- Owner
- Contributor
- Reader
- Storage Blob Data Owner
- Storage Blob Data Contributor
- Storage Blob Data Reader

## Parameters

| Name                 | Type     | Required | Description                                                                                                                                              |
| :------------------- | :------: | :------: | :------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `storageAccountName` | `string` | Yes      | The name of the storage account to apply the role assignement.                                                                                           |
| `role`               | `string` | Yes      | The name of the role to grant the assignee on the storage account. See: https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles |
| `assigneeObjectId`   | `string` | Yes      | The object ID of the assignee Azure AD group / service principal / user.                                                                                 |
| `principalType`      | `string` | Yes      | The assignee's type of Azure AD principal.                                                                                                               |
| `roleAssignmentId`   | `string` | No       | A GUID to use as the role assignment resource name, if omitted, one will be generated based on the storage account, role and assignee                    |

## Outputs

| Name             | Type   | Description                              |
| :--------------- | :----: | :--------------------------------------- |
| roleAssignmentId | string | The resource ID of the role assignement. |

## Examples

### Assign 'Reader' role to a group

```bicep
module storage_rbac_group_reader 'br:<registry-fqdn>/bicep/general/storage-account-rbac:<version>' = {
  name: 'storageRbacGroupReader'
  params: {
    assigneeObjectId: '00000000-0000-0000-0000-000000000000' // replace with Azure AD group ID
    principalType: 'Group'
    role: 'Reader'
    storageAccountName: 'mystorageaccount'
  }
}
```

### Assign 'Storage Blob Data Contributor' role to a managed identity service principal

```bicep
resource managed_identity 'Microsoft.ManagedIdentity/userAssignedIdentities@2021-09-30-preview' = {
  name: 'mymanagedidentity'
  location: location
}

module storage_rbac_mi_sbdc 'br:<registry-fqdn>/bicep/general/storage-account-rbac:<version>' = {
  name: 'storageRbacMiSbdc'
  params: {
    assigneeObjectId: managed_identity.properties.principalId
    principalType: 'ServicePrincipal'
    role: 'Storage Blob Data Contributor'
    storageAccountName: 'mystorageaccount'
  }
}
```