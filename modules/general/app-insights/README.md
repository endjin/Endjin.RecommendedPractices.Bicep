# Application Insights

Azure Application Insights

## Details

Deploys or updates an [Application Insights](https://learn.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview) resource backed by an existing Log Analytics workspace for data ingestion.

If the resource is expected to already exist, the `useExisting` flag should be used. This will return the details of the resource without modifying it, but fail if the resource does not exist.

## Parameters

| Name                                     | Type     | Required | Description                                                                                                                            |
| :--------------------------------------- | :------: | :------: | :------------------------------------------------------------------------------------------------------------------------------------- |
| `name`                                   | `string` | Yes      | The name of the app insights workspace                                                                                                 |
| `location`                               | `string` | Yes      | The location of the app insights workspace                                                                                             |
| `kind`                                   | `string` | No       | The kind of application using the workspace                                                                                            |
| `applicationType`                        | `string` | No       | The type of application using the workspace                                                                                            |
| `logAnalyticsWorkspaceName`              | `string` | Yes      | The name of the existing Log Analytics workspace which the data will be ingested to.                                                   |
| `disablePublicNetworkAccessForIngestion` | `bool`   | No       | When true, public network access is disabled for ingestion of data.                                                                    |
| `disablePublicNetworkAccessForQuery`     | `bool`   | No       | When true, public network access is disabled for querying of data.                                                                     |
| `useExisting`                            | `bool`   | No       | When true, the details of an existing app insights instance will be returned; When false, the app insights instance is created/updated |
| `resourceTags`                           | `object` | No       | The resource tags applied to resources                                                                                                 |

## Outputs

| Name                           | Type     | Description                                                |
| :----------------------------- | :------: | :--------------------------------------------------------- |
| `id`                           | `string` | The resource ID of the app insights workspace              |
| `name`                         | `string` | The name of the app insights workspace                     |
| `appInsightsWorkspaceResource` | `object` | An object representing the app insights workspace resource |

## Examples

### Create a new Application Insights instance

```bicep
module app_insights 'br:<registry-fqdn>/bicep/general/app-insights:<version>' = {
  name: 'appInsightsDeploy'
  params: {
    location: location
    name: 'myappinsights'
    logAnalyticsWorkspaceName: 'myloganalyticsworkspace'
  }
}
```

### Create a new Application Insights instance with public network access disabled

```bicep
module app_insights 'br:<registry-fqdn>/bicep/general/app-insights:<version>' = {
  name: 'appInsightsDeploy'
  params: {
    location: location
    name: 'myappinsights'
    disablePublicNetworkAccessForIngestion: true
    disablePublicNetworkAccessForQuery: true
    logAnalyticsWorkspaceName: 'myloganalyticsworkspace'
  }
}
```