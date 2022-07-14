# app-insights-alert

An alert for Application Insights

## Description

{{ Add detailed description for the module. }}

## Parameters

| Name                    | Type     | Required | Description                                                                             |
| :---------------------- | :------: | :------: | :-------------------------------------------------------------------------------------- |
| `alertLocation`         | `string` | Yes      | The Azure location for the App Insights Alert resource.                                 |
| `alertName`             | `string` | Yes      | The name of the App Insights Alert resource.                                            |
| `appInsightsResourceId` | `string` | Yes      | The resource ID of the App Insights instance to apply to the alert to.                  |
| `query`                 | `string` | Yes      | KQL query for the alert.                                                                |
| `operator`              | `string` | Yes      | The criteria operator for the alert.                                                    |
| `timeAggregation`       | `string` | Yes      | The aggregation for the alert                                                           |
| `threshold`             | `int`    | Yes      | The criteria threshold value that activates the alert.                                  |
| `evaluationFrequency`   | `string` | Yes      | How often the scheduled query rule is evaluated represented in ISO 8601 duration format |

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