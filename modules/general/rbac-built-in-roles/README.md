# RBAC built-in roles

Provides a dictionary of role name to role definition ID for built-in RBAC roles.

## Details

Azure RBAC has several Azure built-in roles that you can assign to users, groups, service principals, and managed identities. The full list can be viewed [here](https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles).

This module has a single output which returns a dictionary of role name to role definition ID for the built-in roles.

It contains all built-in roles as of October 2022.

## Parameters

| Name | Type | Required | Description |
| :--- | :--: | :------: | :---------- |

## Outputs

| Name                | Type     | Description                                    |
| :------------------ | :------: | :--------------------------------------------- |
| `roleDefinitionIds` | `object` | Dictionary of role name to role definition ID. |

## Examples

### Using the module to provide a role definition ID for a role assignment

```bicep
module rbac_built_in_roles 'br:<registry-fqdn>/bicep/general/rbac-built-in-roles:<version>' = {
  name: 'rbacBuiltInRoles'
}

resource mi 'Microsoft.ManagedIdentity/userAssignedIdentities@2021-09-30-preview' = {
  name: 'mymanagedidentity'
  location: location
}

var principalId = mi.properties.principalId

var roleName = 'Storage Account Contributor'
var roleDefinitionId = rbac_built_in_roles.outputs.roleDefinitionIds[roleName]

resource role_assignment 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
  name: guid(resourceGroup().id, mi.name, roleName)
  properties: {
    principalId: principalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: roleDefinitionId
  }
  scope: resourceGroup()
}
```