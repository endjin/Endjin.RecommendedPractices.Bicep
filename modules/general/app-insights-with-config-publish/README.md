# Application Insights with published configuration

Deploys an AppInsights workspace and publishes the instrumentation key to a Key Vault

## Description

{{ Add detailed description for the module. }}

## Parameters

| Name                        | Type     | Required | Description                                                                                                                                |
| :-------------------------- | :------: | :------: | :----------------------------------------------------------------------------------------------------------------------------------------- |
| `name`                      | `string` | Yes      | The name of the app insights workspace                                                                                                     |
| `subscriptionId`            | `string` | No       | The subscription of the existing app insights workspace                                                                                    |
| `location`                  | `string` | Yes      | The location of the app insights workspace                                                                                                 |
| `keyVaultName`              | `string` | Yes      | The key vault name where the instrumentation key will be stored                                                                            |
| `keyVaultResourceGroupName` | `string` | Yes      | The resource group of the key vault where the instrumentation key will be stored                                                           |
| `keyVaultSubscriptionId`    | `string` | No       | The subscription of the key vault where the instrumentation key will be stored                                                             |
| `kind`                      | `string` | No       | The kind of application using the workspace                                                                                                |
| `applicationType`           | `string` | No       | The type of application using the workspace                                                                                                |
| `useExisting`               | `bool`   | No       | When true, the details of an existing app configuration store will be returned; When false, the app configuration store is created/updated |
| `resourceTags`              | `object` | No       | The resource tags applied to resources                                                                                                     |

## Outputs

| Name                         | Type   | Description                                                |
| :--------------------------- | :----: | :--------------------------------------------------------- |
| id                           | string | The resource ID of the app insights workspace              |
| name                         | string | The name of the app insights workspace                     |
| appInsightsWorkspaceResource | object | An object representing the app insights workspace resource |

## Examples

### Example 1

```bicep
```

### Example 2

```bicep
```