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


// provide a more user-friendly roleDefinitionId lookup
var roles = {
  'Owner': resourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  'Reader': resourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Contributor': resourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'Storage Blob Data Owner': resourceId('Microsoft.Authorization/roleDefinitions', 'b7e6dc6d-f1e8-4753-8033-0f276bb0955b')
  'Storage Blob Data Contributor': resourceId('Microsoft.Authorization/roleDefinitions', 'ba92f5b4-2d11-453d-a403-e96b0029c9fe')
  'Storage Blob Data Reader': resourceId('Microsoft.Authorization/roleDefinitions', '2a2b9908-6ea1-4ae2-8e65-a410df84e7d1')
}
// generate a stable Id for a given role assignment
var storageAccountId = resourceId('Microsoft.Storage/storageAccounts', storageAccountName)
var generatedRoleAssignmentId = guid('${storageAccountId}${roles[role]}${assigneeObjectId}')


resource storage_account 'Microsoft.Storage/storageAccounts@2021-02-01' existing = {
  name: storageAccountName
}

resource role_assignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: empty(roleAssignmentId) ? generatedRoleAssignmentId : roleAssignmentId
  scope: storage_account
  properties: {
    roleDefinitionId: roles[role]
    principalId: assigneeObjectId
    principalType: principalType
  }
}

@description('The resource ID of the role assignement.')
output roleAssignmentId string = role_assignment.id
