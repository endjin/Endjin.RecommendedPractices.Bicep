# App Config Key Values

Sets a list of key-values on an existing App Configuration Store

## Description

Sets a list of [key-values](https://learn.microsoft.com/en-us/azure/azure-app-configuration/concept-key-value) on an existing App Configuration Store. Optionally, allows for a label to be applied for all given key-values.

## Parameters

| Name                 | Type     | Required | Description                                                                                                                          |
| :------------------- | :------: | :------: | :----------------------------------------------------------------------------------------------------------------------------------- |
| `appConfigStoreName` | `string` | Yes      | The app configuration instance where the keys will be stored                                                                         |
| `entries`            | `array`  | Yes      | Array of key/values to be written to the app configuration store, each with the structure {name: "<key-name>", value: "<key-value>"} |
| `label`              | `string` | No       | When defined, all app configuration keys will have this labelled applied                                                             |

## Outputs

| Name | Type | Description |
| :--- | :--: | :---------- |

## Examples

### Unlabelled key-values

```bicep
module acs_key_values 'br:<registry-fqdn>/bicep/general/app-config-key-values:<version>' = {
  name: 'acsKeyValuesDeploy'
  params: {
    appConfigStoreName: 'myappconfigstore'
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
```

### Labelled key-values

```bicep
module acs_key_values 'br:<registry-fqdn>/bicep/general/app-config-key-values:<version>' = {
  name: 'acsKeyValuesDeploy'
  params: {
    appConfigStoreName: 'myappconfigstore'
    label: 'mylabel'
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
```