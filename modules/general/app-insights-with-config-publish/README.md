# Application Insights with published configuration

Application Insights with instrumentation key published to a Key Vault.

## Description

Deploys or updates an [Application Insights](https://learn.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview) resource. The instrumentation key for the resource is then stored in the specified Key Vault with the name `AppInsightsInstrumentationKey`.

If the resource is expected to already exist, the `useExisting` flag should be used. This will ensure the instrumentation key is stored in the Key Vault and return the details of the resource without modifying it, but will fail if the resource does not exist.

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