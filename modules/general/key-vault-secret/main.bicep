// <copyright file="key-vault-secret/main.bicep" company="Endjin Limited">
// Copyright (c) Endjin Limited. All rights reserved.
// </copyright>

metadata name = 'Adds or updates a Key Vault secret'
metadata description = 'Adds or updates a Key Vault secret'
metadata owner = 'endjin'

@description('Enter the secret name.')
param secretName string

@description('Type of the secret')
param contentType string = 'text/plain'

@description('Value of the secret')
@secure()
param contentValue string = ''

@description('Name of the vault')
param keyVaultName string

@description('When true, a pre-existing secret will be returned')
param useExisting bool = false


targetScope = 'resourceGroup'


resource key_vault 'Microsoft.KeyVault/vaults@2021-06-01-preview' existing = {
  name: keyVaultName
}

resource existing_secret 'Microsoft.KeyVault/vaults/secrets@2021-06-01-preview' existing = if (useExisting) {
  name: secretName
  parent: key_vault
}

resource secret 'Microsoft.KeyVault/vaults/secrets@2021-06-01-preview' = if (!useExisting) {
  name: secretName
  parent: key_vault
  properties: {
    contentType: contentType
    value: contentValue
  }
}

// Template outputs
@description('The key vault URI linking to the new/updated secret')
output secretUriWithVersion string = useExisting ? existing_secret.properties.secretUriWithVersion : secret.properties.secretUriWithVersion

