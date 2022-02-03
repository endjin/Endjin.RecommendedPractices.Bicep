param name string
param sku string = 'standard'
param access_policies array = []
param tenantId string
param location string = resourceGroup().location
param enabledForDeployment bool = false
param enabledForDiskEncryption bool = false
param enabledForTemplateDeployment bool = false

param enable_diagnostics bool
param diagnostics_storage_account_name string = ''
param use_existing_storage_account bool = false
param diagnostics_retention_days int = 30

param useExisting bool = false
param resource_tags object = {}

targetScope = 'resourceGroup'

resource existing_key_vault 'Microsoft.KeyVault/vaults@2021-06-01-preview' existing = if (useExisting) {
  name: name
}

resource existing_storage_account 'Microsoft.Storage/storageAccounts@2021-06-01' existing = if (!useExisting && enable_diagnostics && use_existing_storage_account) {
  name: diagnostics_storage_account_name
}
module diagnostics_storage 'storage_account.bicep' = if (!useExisting && enable_diagnostics && !use_existing_storage_account) {
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
    accessPolicies: access_policies

  }
  tags: resource_tags
}

resource keyvault_diagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (enable_diagnostics) {
  scope: key_vault
  name: 'service'
  properties: {
    storageAccountId: use_existing_storage_account ? existing_storage_account.id : diagnostics_storage.outputs.id
    logs: [
      {
        category: 'AuditEvent'
        enabled: true
        retentionPolicy: {
          days: diagnostics_retention_days
          enabled: true
        }
      }
    ]
  }
}

output id string = useExisting ? existing_key_vault.id : key_vault.id
output name string = useExisting ? existing_key_vault.name : key_vault.name

output keyVaultResource object =  useExisting ? existing_key_vault : key_vault
