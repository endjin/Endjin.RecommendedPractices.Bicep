# Application Insights

Azure Application Insights

## Description

Deploys or updates an [Application Insights](https://learn.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview) resource.

If the resource is expected to already exist, the `useExisting` flag should be used. This will return the details of the resource without modifying it, but fail if the resource does not exist.

## Parameters

| Name              | Type     | Required | Description                                                                                                                                |
| :---------------- | :------: | :------: | :----------------------------------------------------------------------------------------------------------------------------------------- |
| `name`            | `string` | Yes      | The name of the app insights workspace                                                                                                     |
| `location`        | `string` | Yes      | The location of the app insights workspace                                                                                                 |
| `kind`            | `string` | No       | The kind of application using the workspace                                                                                                |
| `applicationType` | `string` | No       | The type of application using the workspace                                                                                                |
| `useExisting`     | `bool`   | No       | When true, the details of an existing app configuration store will be returned; When false, the app configuration store is created/updated |
| `resourceTags`    | `object` | No       | The resource tags applied to resources                                                                                                     |

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