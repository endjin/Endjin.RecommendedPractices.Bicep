
@description('The name of the key vault')
param name string

@description('The AzureAD objectId for the group to be granted "get" access to secrets')
param secretsReadersGroupObjectId string

@description('The AzureAD objectId for the group to be granted "get" & "set" access to secrets')
param secretsContributorsGroupObjectId string

@description('The Azure tenantId of the key vault')
param tenantId string

@description('When true, the key vault will be accessible by deployments')
param enabledForDeployment bool = false

@description('When true, the key vault will be accessible for disk encryption')
param enabledForDiskEncryption bool = false

@description('When true, the key vault will be accessible by ARM deployments')
param enabledForTemplateDeployment bool = false

@description('When true, diagnostics settings will be enabled for the key vault')
param enableDiagnostics bool
// TODO: Support shipping diagnostics to log analytics?

@description('The storage account name to be used for key vault diagnostic settings')
param diagnosticsStorageAccountName string = ''

@description('When true, an existing storage account be used for diagnotics settings; When false, the storage account is created/updated')
param useExistingStorageAccount bool = false

@description('Sets the retention policy for diagnostics settings data, in days')
param diagnosticsRetentionDays int = 30

@description('The resource tags applied to resources')
param resourceTags object = {}


targetScope = 'resourceGroup'


var readerAccessPolicy = (!empty(secretsReadersGroupObjectId)) ? {
  objectId: secretsReadersGroupObjectId
  tenantId: tenantId
  permissions: {
    secrets: [
      'get'
    ]
  }
} : {}

var contributorAccessPolicy = (!empty(secretsContributorsGroupObjectId)) ? {
  objectId: secretsContributorsGroupObjectId
  tenantId: tenantId
  permissions: {
    secrets: [
      'get'
      'set'
    ]
  }
} : {}

var accessPolicies = [
  readerAccessPolicy
  contributorAccessPolicy
]


module key_vault 'key_vault.bicep' = {
  name: 'keyVault-${name}'
  params: {
    name: name
    enableDiagnostics: enableDiagnostics
    diagnosticsStorageAccountName: diagnosticsStorageAccountName
    useExistingStorageAccount: useExistingStorageAccount
    diagnosticsRetentionDays: diagnosticsRetentionDays
    accessPolicies: accessPolicies
    enabledForDeployment: enabledForDeployment
    enabledForDiskEncryption: enabledForDiskEncryption
    enabledForTemplateDeployment: enabledForTemplateDeployment
    tenantId: tenantId
    useExisting: false
    resourceTags: resourceTags
  }
}

output id string = key_vault.outputs.id
output name string = key_vault.outputs.name

output keyVaultResource object =  key_vault.outputs.keyVaultResource
