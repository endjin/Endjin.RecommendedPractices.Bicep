# web-prod-app-insights-alerts

An opinionated set of application insights alerts for monitoring the health of a web app running in production.

## Description

This module defines the set of Application Insights alerts that we consider good practice for monitoring the health of a web app running in production.

The alerts deployed are:
- `any-500-errors`: Alerts if any requests respond with a 500 Internal Server Error

## Parameters

| Name                    | Type     | Required | Description                                                             |
| :---------------------- | :------: | :------: | :---------------------------------------------------------------------- |
| `alertLocation`         | `string` | Yes      | The Azure location for the App Insights Alert resources.                |
| `appInsightsResourceId` | `string` | Yes      | The resource ID of the App Insights instance to apply to the alerts to. |

## Outputs

| Name | Type | Description |
| :--- | :--: | :---------- |

## Examples

### Example 1

```bicep
var location = resourceGroup().location

module appInsights 'br:<registry>/app-insights:<version>' = {
  name: 'appInsights'
  params:{
    name: 'ai01'
    location: location
  }
}

module alerts 'br:<registry>/web-prod-app-insights-alerts:<version>' = {
  name: 'web-prod-app-insights-alerts'
  params: {
    appInsightsResourceId: appInsights.outputs.id
    alertLocation: location
  }
}
```

### Example 2

N/A