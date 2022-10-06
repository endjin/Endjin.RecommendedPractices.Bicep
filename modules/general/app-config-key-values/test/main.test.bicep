param suffix string = uniqueString(resourceGroup().id)
param location string = resourceGroup().location

module acs '../../app-configuration/main.bicep' = {
  name: 'acsDeploy'
  params: {
    location: location
    name: 'acs${suffix}'
    sku: 'Standard'
  }
}

module acs_key_values '../main.bicep' = {
  name: 'acsKeyValuesDeploy'
  params: {
    appConfigStoreName: acs.outputs.name
    entries: [
      {
        name: 'key1'
        value: 'a'
      }
      {
        name: 'key2'
        value: 'b'
      }
      {
        name: 'key3'
        value: 'c'
      }
    ]
  }
}

module acs_key_values_labelled '../main.bicep' = {
  name: 'acsKeyValuesLabelledDeploy'
  params: {
    appConfigStoreName: acs.outputs.name
    label: 'mylabel'
    entries: [
      {
        name: 'key4'
        value: 'd'
      }
      {
        name: 'key5'
        value: 'e'
      }
      {
        name: 'key6'
        value: 'f'
      }
    ]
  }
}
