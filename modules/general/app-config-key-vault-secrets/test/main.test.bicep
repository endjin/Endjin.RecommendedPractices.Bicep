param suffix string = uniqueString(resourceGroup().id)
param location string = resourceGroup().location

resource kv 'Microsoft.KeyVault/vaults@2021-11-01-preview' = {
  name: 'kv${suffix}'
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: tenant().tenantId
    accessPolicies: []
  }
}

resource acs 'Microsoft.AppConfiguration/configurationStores@2022-05-01' = {
  name: 'acs${suffix}'
  location: location
  sku: {
    name: 'Standard'
  }
}

resource secret3 'Microsoft.KeyVault/vaults/secrets@2021-11-01-preview' = {
  parent: kv
  name: 'secret3'
  properties: {
    value: 'p@55w0rd3!'
  }
}

resource secret4 'Microsoft.KeyVault/vaults/secrets@2021-11-01-preview' = {
  parent: kv
  name: 'secret4'
  properties: {
    value: 'p@55w0rd4!'
  }
}

module ackvs '../main.bicep' = {
  name: 'ackvs'
  params: {
    appConfigStoreName: acs.name
    keyVaultName: kv.name
    keyValueSecrets: [
      // New secret, default App Configuration key
      {
        appConfigKey: ''
        secretName: 'secret1'
        secretValue: 'p@55w0rd1!'
      }
      // New secret, custom App Configuration key
      {
        appConfigKey: 'MyPassword'
        secretName: 'secret2'
        secretValue: 'p@55w0rd2!'
      }
      // Existing secret, default App Configuration key
      {
        appConfigKey: ''
        secretName: 'secret3'
        secretValue: ''
      }
      // Existing secret, custom App Configuration key
      {
        appConfigKey: 'MyOtherPassword'
        secretName: 'secret4'
        secretValue: ''
      }
    ]
  }
  dependsOn: [
    secret3
    secret4
  ]
}
