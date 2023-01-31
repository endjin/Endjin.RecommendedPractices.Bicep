# App Service Plan

Deploys an App Service Plan

## Description

Deploys or updates an [App Service plan](https://learn.microsoft.com/en-us/azure/app-service/overview-hosting-plans) resource.

If the resource is expected to already exist, the `useExisting` flag should be used. This will return the details of the resource without modifying it, but fail if the resource does not exist.

## Parameters

| Name                                 | Type     | Required | Description                                                                                                                  |
| :----------------------------------- | :------: | :------: | :--------------------------------------------------------------------------------------------------------------------------- |
| `name`                               | `string` | Yes      | The name of the app service plan                                                                                             |
| `skuName`                            | `string` | Yes      | The SKU for the app service plan                                                                                             |
| `skuCapacity`                        | `int`    | Yes      | The SKU capacity for the app service plan                                                                                    |
| `location`                           | `string` | Yes      | The location of the app service plan                                                                                         |
| `kind`                               | `string` | Yes      | The kind of app service plan                                                                                                 |
| `targetWorkerCount`                  | `int`    | No       | The target number of workers                                                                                                 |
| `targetWorkerSizeId`                 | `int`    | No       | The target size of the workers                                                                                               |
| `elasticScaleEnabled`                | `bool`   | No       | When true, elastic scale is enabled                                                                                          |
| `maximumElasticWorkerCount`          | `int`    | No       | The maximum number of elastic workers                                                                                        |
| `zoneRedundant`                      | `bool`   | No       | When true, the app service will have zone redundancy                                                                         |
| `resourceTags`                       | `object` | No       | The resource tags applied to resources                                                                                       |
| `useExisting`                        | `bool`   | No       | When true, the details of an existing app service plan will be returned; When false, the app service plan is created/updated |
| `existingPlanResourceGroupName`      | `string` | No       | The resource group in which the existing app service plan resides                                                            |
| `existingPlanResourceSubscriptionId` | `string` | No       | The subscription in which the existing app service plan resides                                                              |

## Outputs

| Name                   | Type   | Description                                                 |
| :--------------------- | :----: | :---------------------------------------------------------- |
| id                     | string | The resource ID of the app service plan                     |
| name                   | string | The name of the app service plan                            |
| appServicePlanResource | object | An object representing the app configuration store resource |

## Examples

### Example 1

```bicep
```

### Example 2

```bicep
```