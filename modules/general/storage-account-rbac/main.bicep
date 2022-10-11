@description('The name of the storage account to apply the role assignement.')
param storageAccountName string

@allowed([
  'Owner'
  'Contributor'
  'Reader'
  'Storage Blob Data Owner'
  'Storage Blob Data Contributor'
  'Storage Blob Data Reader'
])
@description('The name of the role to grant the assignee on the storage account. See: https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles')
param role string

@description('The object ID of the assignee Azure AD group / service principal / user.')
param assigneeObjectId string

@allowed([
  'Group'
  'ServicePrincipal'
  'User'
])
@description('The assignee\'s type of Azure AD principal.')
param principalType string

@description('A GUID to use as the role assignment resource name, if omitted, one will be generated based on the storage account, role and assignee')
param roleAssignmentId string = ''


targetScope = 'resourceGroup'


module role_definitions '../rbac-built-in-roles/main.bicep' = {
  name: 'roleDefinitions'
}

// generate a stable Id for a given role assignment
var storageAccountId = resourceId('Microsoft.Storage/storageAccounts', storageAccountName)
var generatedRoleAssignmentId = guid(storageAccountId, toLower(role), assigneeObjectId)


resource storage_account 'Microsoft.Storage/storageAccounts@2021-02-01' existing = {
  name: storageAccountName
}

resource role_assignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: empty(roleAssignmentId) ? generatedRoleAssignmentId : roleAssignmentId
  scope: storage_account
  properties: {
    roleDefinitionId: role_definitions.outputs.roleDefinitionIds[role]
    principalId: assigneeObjectId
    principalType: principalType
  }
}

@description('The resource ID of the role assignement.')
output roleAssignmentId string = role_assignment.id
