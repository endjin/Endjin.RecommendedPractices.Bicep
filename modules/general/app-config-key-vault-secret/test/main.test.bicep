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

module ackvs '../main.bicep' = {
  name: 'ackvs'
  params: {
    appConfigStoreName: acs.name
    keyVaultName: kv.name
    secretName: 'mysecret1'
    secretValue: 's3cr3t!'
  }
}

resource secret 'Microsoft.KeyVault/vaults/secrets@2021-11-01-preview' = {
  parent: kv
  name: 'mysecret2'
  properties: {
    value: 'p@55w0rd!'
  }
}

module ackvs_existing_secret '../main.bicep' = {
  name: 'ackvs_existing_secret'
  params: {
    appConfigStoreName: acs.name
    keyVaultName: kv.name
    secretName: 'mysecret2'
  }
}
