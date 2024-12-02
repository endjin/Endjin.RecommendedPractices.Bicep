// <copyright file="key-vault-with-secrets-access-via-groups/main.bicep" company="Endjin Limited">
// Copyright (c) Endjin Limited. All rights reserved.
// </copyright>

metadata name = 'Key Vault with group-based access policy'
metadata description = 'Deploys a Key Vault with a secrets access policy managed via group membership'
metadata owner = 'endjin'

@description('The name of the key vault')
param name string

@allowed([
  'standard'
  'premium'
])
@description('SKU for the key vault')
param sku string = 'standard'

@description('The AzureAD objectId for the group to be granted "get" access to secrets')
#disable-next-line secure-secrets-in-params
param secretsReadersGroupObjectId string

@description('The list of secret permissions granted to the "reader" group')
param secretsReadersPermissions array = [
  'get'
]
@description('The AzureAD objectId for the group to be granted "get" & "set" access to secrets')
#disable-next-line secure-secrets-in-params
param secretsContributorsGroupObjectId string

@description('The list of secret permissions granted to the "contributors" group')
param secretsContributorsPermissions array = [
  'get'
  'set'
]

@description('The Azure tenantId of the key vault')
param tenantId string

@description('The optional network rules securing access to the key vault (ref: https://learn.microsoft.com/en-us/azure/templates/microsoft.keyvault/vaults#networkruleset)')
param networkAcls object = {}

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

@description('The location of the key vault')
param location string = resourceGroup().location

@description('The resource tags applied to resources')
param resourceTags object = {}


targetScope = 'resourceGroup'


// Create an access policy entry to grant 'secrets reader' permissions
var readerAccessPolicy = (!empty(secretsReadersGroupObjectId)) ? {
  objectId: secretsReadersGroupObjectId
  tenantId: tenantId
  permissions: {
    secrets: secretsReadersPermissions
  }
} : {}
// Create an access policy entry to grant 'secrets contributor' permissions
var contributorAccessPolicy = (!empty(secretsContributorsGroupObjectId)) ? {
  objectId: secretsContributorsGroupObjectId
  tenantId: tenantId
  permissions: {
    secrets: secretsContributorsPermissions
  }
} : {}
// Create the final access policy definition that will be passed to the Key Vault resource definition
var accessPolicies = [
  readerAccessPolicy
  contributorAccessPolicy
]


module key_vault '../key-vault/main.bicep' = {
  name: 'keyVault-${name}'
  params: {
    name: name
    sku: sku
    enableDiagnostics: enableDiagnostics
    diagnosticsStorageAccountName: diagnosticsStorageAccountName
    useExistingStorageAccount: useExistingStorageAccount
    diagnosticsRetentionDays: diagnosticsRetentionDays
    accessPolicies: accessPolicies
    enableRbacAuthorization: false
    enableSoftDelete: enableSoftDelete
    softDeleteRetentionInDays: softDeleteRetentionInDays
    networkAcls: networkAcls
    enabledForDeployment: enabledForDeployment
    enabledForDiskEncryption: enabledForDiskEncryption
    enabledForTemplateDeployment: enabledForTemplateDeployment
    enablePublicAccess: enablePublicAccess
    enablePurgeProtection: enablePurgeProtection
    tenantId: tenantId
    useExisting: false
    location: location
    resourceTags: resourceTags
  }
}

// Template outputs
@description('The objectId of the key vault')
output id string = key_vault.outputs.id
@description('The name of the key vault')
output name string = key_vault.outputs.name

// Returns the full Key Vault resource object (workaround whilst resource types cannot be returned directly)
@description('An object representing the key vault resource')
output keyVaultResource object =  key_vault.outputs.keyVaultResource

