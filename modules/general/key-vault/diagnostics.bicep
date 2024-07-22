param keyVaultName string
param location string

// TODO: Support shipping diagnostics to log analytics?

@description('The storage account name to be used for key vault diagnostic settings')
param diagnosticsStorageAccountName string = ''

@description('When true, an existing storage account be used for diagnotics settings; When false, the storage account is created/updated')
param useExistingStorageAccount bool = false

@description('Sets the retention policy for diagnostics settings data, in days')
param diagnosticsRetentionDays int = 30

@description('When false, the storage account will not accept traffic from public internet. (i.e. all traffic except private endpoint traffic and that that originates from trusted services will be blocked, regardless of any firewall rules)')
param enablePublicAccess bool

resource key_vault 'Microsoft.KeyVault/vaults@2021-06-01-preview' existing = {
  name: keyVaultName
}

var _diagnosticsStorageAccountName = empty(diagnosticsStorageAccountName) ? keyVaultName : diagnosticsStorageAccountName


resource existing_storage_account 'Microsoft.Storage/storageAccounts@2021-06-01' existing = if (useExistingStorageAccount) {
  name: diagnosticsStorageAccountName
}

module diagnostics_storage '../storage-account/main.bicep' = if (!useExistingStorageAccount) {
  name: 'kvDiagnosticsDeploy'
  params: {
    name: _diagnosticsStorageAccountName
    location: location
    enablePublicAccess: enablePublicAccess
  }
}

resource keyvault_diagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
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
