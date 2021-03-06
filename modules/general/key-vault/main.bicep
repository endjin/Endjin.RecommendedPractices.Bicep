// <copyright file="key-vault.bicep" company="Endjin Limited">
// Copyright (c) Endjin Limited. All rights reserved.
// </copyright>

@description('The name of the key vault')
param name string

@description('SKU for the key vault')
param sku string = 'standard'

@description('The access policies for the key vault')
param accessPolicies array = []

@description('The Azure tenantId of the key vault')
param tenantId string

@description('The location of the key vault')
param location string

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

@description('When true, the details of an existing key vault will be returned; When false, the key vault is created/updated')
param useExisting bool = false

@description('The resource tags applied to resources')
param resourceTags object = {}


targetScope = 'resourceGroup'

var _diagnosticsStorageAccountName = empty(diagnosticsStorageAccountName) ? name : diagnosticsStorageAccountName

resource existing_key_vault 'Microsoft.KeyVault/vaults@2021-06-01-preview' existing = if (useExisting) {
  name: name
}

resource existing_storage_account 'Microsoft.Storage/storageAccounts@2021-06-01' existing = if (!useExisting && enableDiagnostics && useExistingStorageAccount) {
  name: diagnosticsStorageAccountName
}
module diagnostics_storage '../storage-account/main.bicep' = if (!useExisting && enableDiagnostics && !useExistingStorageAccount) {
  name: 'kvDiagnosticsDeploy'
  params: {
    name: _diagnosticsStorageAccountName
    location: location
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

// Template outputs
@description('The resource ID of the key vault')
output id string = useExisting ? existing_key_vault.id : key_vault.id
@description('The name of the key vault')
output name string = useExisting ? existing_key_vault.name : key_vault.name

// Returns the full Key Vault resource object (workaround whilst resource types cannot be returned directly)
@description('An object representing the key vault resource')
output keyVaultResource object =  useExisting ? existing_key_vault : key_vault
