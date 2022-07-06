# App Configuration

Azure App Configuration

## Description

{{ Add detailed description for the module. }}

## Parameters

| Name                        | Type     | Required | Description                                                                                                                                |
| :-------------------------- | :------: | :------: | :----------------------------------------------------------------------------------------------------------------------------------------- |
| `name`                      | `string` | Yes      | The name of the app configuration store                                                                                                    |
| `location`                  | `string` | Yes      | The location of the app configuration store                                                                                                |
| `enablePublicNetworkAccess` | `bool`   | No       | When false, the app configuration store will be inaccessible via its public IP address                                                     |
| `sku`                       | `string` | No       | SKU for the app configuration store                                                                                                        |
| `useExisting`               | `bool`   | No       | When true, the details of an existing app configuration store will be returned; When false, the app configuration store is created/updated |
| `resourceTags`              | `object` | No       | The resource tags applied to resources                                                                                                     |

## Outputs

| Name                   | Type   | Description                                                 |
| :--------------------- | :----: | :---------------------------------------------------------- |
| id                     | string | The resource ID of the app configuration store              |
| name                   | string | The name of the app configuration store                     |
| appConfigStoreResource | object | An object representing the app configuration store resource |

## Examples

Something here.

### Example 1

```bicep
```

### Example 2

```bicep
```