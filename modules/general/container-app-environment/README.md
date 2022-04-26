# Container App Environment

Container App Environment

## Parameters

| Name                                      | Type     | Required | Description                                                                                                                                                         |
| :---------------------------------------- | :------: | :------: | :------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `name`                                    | `string` | Yes      | The name of the container app hosting environment                                                                                                                   |
| `location`                                | `string` | Yes      | The location of the container app hosting environment                                                                                                               |
| `logAnalyticsName`                        | `string` | Yes      | The name of the log analytics workspace used by the container app hosting environment                                                                               |
| `appInsightsName`                         | `string` | Yes      | The name of the app insights workspace used by Dapr-enabled container apps running in the hosting environment                                                       |
| `useExisting`                             | `bool`   | No       | When true, the details of an existing container app hosting environment will be returned; When false, the container app hosting environment will be created/updated |
| `existingAppEnvironmentResourceGroupName` | `string` | No       | The resource group in which the existing container app hosting environment resides                                                                                  |
| `existingAppEnvironmentSubscriptionId`    | `string` | No       | The subscription in which the existing container app hosting environment resides                                                                                    |
| `existingAppInsightsResourceGroupName`    | `string` | No       | The resource group in which the existing app insights workspace resides                                                                                             |
| `existingAppInsightsSubscriptionId`       | `string` | No       | The subscription in which the existing app insights workspace resides                                                                                               |
| `createContainerRegistry`                 | `bool`   | No       | When true, an Azure Container Registry will be provisioned                                                                                                          |
| `containerRegistryName`                   | `string` | No       | The name of the container registry                                                                                                                                  |
| `containerRegistrySku`                    | `string` | No       | The SKU for the container registry                                                                                                                                  |
| `enableContainerRegistryAdminUser`        | `bool`   | No       | When true, admin access via the ACR key is enabled; When false, access is via RBAC                                                                                  |
| `resourceTags`                            | `object` | No       | The resource tags applied to resources                                                                                                                              |

## Outputs

| Name                            | Type   | Description                                                   |
| :------------------------------ | :----: | :------------------------------------------------------------ |
| id                              | string | The resource ID of the container app environment              |
| name                            | string | The name of the container app environment                     |
| appEnvironmentResource          | object | An object representing the container app environment resource |
| appinsights_instrumentation_key | string | The app insights workspace instrumentation key                |
| acrId                           | string | The resource ID of the container registry                     |
| acrUsername                     | string | The admin username for the container registry                 |
| acrLoginServer                  | string | The login server for the container registry                   |

## Examples

### Example 1

```bicep
```

### Example 2

```bicep
```