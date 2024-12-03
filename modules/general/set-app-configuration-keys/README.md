# Adds or updates a list of App Configuration keys

Adds or updates a list of App Configuration keys

## Details

Adds a list configuration keys to an existing App Configuration resource.

## Parameters

| Name                 | Type     | Required | Description                                                                                                                          |
| :------------------- | :------: | :------: | :----------------------------------------------------------------------------------------------------------------------------------- |
| `appConfigStoreName` | `string` | Yes      | The app configuration instance where the keys will be stored                                                                         |
| `entries`            | `array`  | Yes      | Array of key/values to be written to the app configuration store, each with the structure {name: "<key-name>", value: "<key-value>"} |
| `label`              | `string` | No       | When defined, all app configuration keys will have this label applied                                                                |

## Outputs

| Name | Type | Description |
| :--- | :--: | :---------- |

## Examples

### Example 1

```bicep
```

### Example 2

```bicep
```