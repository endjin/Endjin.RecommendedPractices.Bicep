param storageAccountName string
@allowed([
  'reader'
  'storageBlobDataContributor'
])
param role string
param assigneeObjectId string
@allowed([
  'Group'
  'ServicePrincipal'
])
param principalType string
@description('A GUID to use as the role assignment resource name, if omitted, one will be generated based on the storage account, role and assignee')
param roleAssignmentId string = ''


targetScope = 'resourceGroup'


// provide a more user-friendly roleDefinitionId lookup
var roles = {
  reader: resourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  storageBlobDataContributor: resourceId('Microsoft.Authorization/roleDefinitions', 'ba92f5b4-2d11-453d-a403-e96b0029c9fe')
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
