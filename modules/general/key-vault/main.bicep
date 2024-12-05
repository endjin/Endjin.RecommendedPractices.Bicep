// <copyright file="key-vault.bicep" company="Endjin Limited">
// Copyright (c) Endjin Limited. All rights reserved.
// </copyright>

metadata name = 'Key Vault with optional diagnostics settings'
metadata description = 'Deploys a key vault with optional diagnostics written to blob storage.'
metadata owner = 'endjin'

@description('The name of the key vault')
param name string

@allowed([
  'standard'
  'premium'
])
@description('SKU for the key vault')
param sku string = 'standard'

@description('The access policies for the key vault')
param accessPolicies array = []

@description('The Azure tenantId of the key vault')
param tenantId string

@description('The location of the key vault')
param location string

@description('The optional network rules securing access to the key vault (ref: https://learn.microsoft.com/en-us/azure/templates/microsoft.keyvault/vaults#networkruleset)')
param networkAcls object = {}

@description('When true, the key vault uses Azure RBAC-based access controls and any specified access policy will be ignored')
param enableRbacAuthorization bool = false

@description('When true, the key vault will be accessible by deployments')
param enabledForDeployment bool = false

@description('When true, the key vault will be accessible for disk encryption')
param enabledForDiskEncryption bool = false

@description('When true, the key vault will be accessible by ARM deployments')
param enabledForTemplateDeployment bool = false

@description('When true, \'soft delete\' functionality is enabled for this key vault. Once set to true, it cannot be reverted to false.')
param enableSoftDelete bool

@description('Sets the retention policy if this key vault is soft deleted')
param softDeleteRetentionInDays int = 7

@description('When true, diagnostics settings will be enabled for the key vault')
param enableDiagnostics bool
// TODO: Support shipping diagnostics to log analytics?

@description('When false, the vault will not accept traffic from public internet. (i.e. all traffic except private endpoint traffic and that that originates from trusted services will be blocked, regardless of any firewall rules)')
param enablePublicAccess bool = true

@description('When true, the key vault will have purge protection enabled')
param enablePurgeProtection bool

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


resource existing_key_vault 'Microsoft.KeyVault/vaults@2021-06-01-preview' existing = if (useExisting) {
  name: name
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
    publicNetworkAccess: enablePublicAccess ? 'Enabled' : 'Disabled'
    tenantId: tenantId
    accessPolicies: enableRbacAuthorization ? [] : accessPolicies
    enableRbacAuthorization: enableRbacAuthorization
    enableSoftDelete: enableSoftDelete
    softDeleteRetentionInDays: softDeleteRetentionInDays
    // This property does not currently except 'false' as a value, so we need to use null to avoid setting it
    // ref: https://github.com/Azure/azure-rest-api-specs/issues/18106
    enablePurgeProtection: enablePurgeProtection ? true : null
    networkAcls: networkAcls
  }
  tags: resourceTags
}

module diagnostics 'diagnostics.bicep' = if (enableDiagnostics) {
  name: 'kvDiagnosticsDeploy-${name}'
  params: {
    location: location
    keyVaultName: name
    diagnosticsRetentionDays: diagnosticsRetentionDays
    diagnosticsStorageAccountName: diagnosticsStorageAccountName
    useExistingStorageAccount: useExistingStorageAccount
    enablePublicAccess: enablePublicAccess
    networkAcls: networkAcls
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
