param name string
param sku string = 'standard'
param accessPolicies array = []
param tenantId string
param location string = resourceGroup().location
param enabledForDeployment bool = false
param enabledForDiskEncryption bool = false
param enabledForTemplateDeployment bool = false

param enableDiagnostics bool
// TODO: Support shipping diagnostics to log analytics
param diagnosticsStorageNccountName string = ''
param useExistingStorageAccount bool = false
param diagnosticsRetentionDays int = 30

param useExisting bool = false
param resourceTags object = {}

targetScope = 'resourceGroup'

resource existing_key_vault 'Microsoft.KeyVault/vaults@2021-06-01-preview' existing = if (useExisting) {
  name: name
}

resource existing_storage_account 'Microsoft.Storage/storageAccounts@2021-06-01' existing = if (!useExisting && enableDiagnostics && useExistingStorageAccount) {
  name: diagnosticsStorageNccountName
}
module diagnostics_storage 'storage_account.bicep' = if (!useExisting && enableDiagnostics && !useExistingStorageAccount) {
  name: 'kvDiagnosticsDeploy'
  params: {
    name: '${name}diag'
  }
}

resource key_vault 'Microsoft.KeyVault/vaults@2021-06-01-preview' = if (!useExisting) {
  name: name
  location: location
  properties: {
    sku: {
      family: 'A'
      name: sku
    }
    enabledForDeployment: enabledForDeployment
    enabledForDiskEncryption: enabledForDiskEncryption
    enabledForTemplateDeployment: enabledForTemplateDeployment
    tenantId: tenantId
    accessPolicies: accessPolicies

  }
  tags: resourceTags
}

resource keyvault_diagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (enableDiagnostics) {
  scope: key_vault
  name: 'service'
  properties: {
    storageAccountId: useExistingStorageAccount ? existing_storage_account.id : diagnostics_storage.outputs.id
    logs: [
      {
        category: 'AuditEvent'
        enabled: true
        retentionPolicy: {
          days: diagnosticsRetentionDays
          enabled: true
        }
      }
    ]
  }
}

output id string = useExisting ? existing_key_vault.id : key_vault.id
output name string = useExisting ? existing_key_vault.name : key_vault.name

output keyVaultResource object =  useExisting ? existing_key_vault : key_vault
