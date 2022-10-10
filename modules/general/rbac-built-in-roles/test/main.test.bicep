param suffix string = uniqueString(resourceGroup().id)
param location string = resourceGroup().location

module rbac_built_in_roles '../main.bicep' = {
  name: 'rbacBuiltInRoles'
}

resource mi 'Microsoft.ManagedIdentity/userAssignedIdentities@2021-09-30-preview' = {
  name: 'mi${suffix}'
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
