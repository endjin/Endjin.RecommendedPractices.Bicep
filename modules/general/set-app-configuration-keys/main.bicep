// <copyright file="set_app_configuration_keys/main.bicep" company="Endjin Limited">
// Copyright (c) Endjin Limited. All rights reserved.
// </copyright>

metadata name = 'Adds or updates a list of App Configuration keys'
metadata description = 'Adds or updates a list of App Configuration keys'
metadata owner = 'endjin'

@description('The app configuration instance where the keys will be stored')
param appConfigStoreName string

@description('Array of key/values to be written to the app configuration store, each with the structure {name: "<key-name>", value: "<key-value>"}')
param entries array

@description('When defined, all app configuration keys will have this label applied')
param label string = ''


targetScope = 'resourceGroup'


resource app_config_store 'Microsoft.AppConfiguration/configurationStores@2020-06-01' existing = {
  name: appConfigStoreName
}

resource app_config_entry 'Microsoft.AppConfiguration/configurationStores/keyValues@2021-03-01-preview' = [for entry in entries : {
  // use the required syntax '<name>$<label>' if a label has been specified
  name: empty(label) ? entry.name : '${entry.name}$${label}'
  parent: app_config_store
  properties: {
    value: entry.value
  }
}]

