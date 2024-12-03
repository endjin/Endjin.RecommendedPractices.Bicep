# Single Metric Dynamic Alert

Deploys an dynamic Alert based on a single Azure Monitor or AppInsights metric

## Details

Provides an opinionated wrapper around the `Microsoft.Insights/metricAlerts` resource to simplify the configuration of Azure Monitor Dynamic alerts.

## Parameters

| Name                                  | Type     | Required | Description                                                                                                                                                                      |
| :------------------------------------ | :------: | :------: | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `name`                                | `string` | Yes      | The metric Alert resource name.                                                                                                                                                  |
| `alertDescription`                    | `string` | Yes      | The description of the alert                                                                                                                                                     |
| `severity`                            | `string` | Yes      | The severity of the alert.                                                                                                                                                       |
| `targetScopes`                        | `array`  | Yes      | The list of resource id's that this metric alert is scoped to.                                                                                                                   |
| `enabled`                             | `bool`   | No       | The flag which indicates whether this Alert query is enabled                                                                                                                     |
| `evaluationFrequencyMinutes`          | `int`    | Yes      | How often the Alert query is evaluated, in minutes.                                                                                                                              |
| `evaluationWindowSizeMinutes`         | `int`    | No       | The period of time on which the Alert query will be executed, in minutes.                                                                                                        |
| `dynamicAlertSensitivity`             | `string` | No       | The extent of deviation required to trigger an alert. This will affect how tight the threshold is to the metric series pattern.                                                  |
| `minimumFailingPeriodsAlertThreshold` | `int`    | Yes      | The number of violations to trigger an alert. Should be smaller or equal to numberOfEvaluationPeriods.                                                                           |
| `numberOfEvaluationPeriods`           | `int`    | No       | The number of aggregated lookback points. The lookback time window is calculated based on the aggregation granularity (windowSize) and the selected number of aggregated points. |
| `metricNamespace`                     | `string` | Yes      | Namespace of the metric.                                                                                                                                                         |
| `metricName`                          | `string` | Yes      | Name of the metric.                                                                                                                                                              |
| `metricRuleOperator`                  | `string` | Yes      | The operator used to compare the metric value against the threshold.                                                                                                             |
| `metricTimeAggregation`               | `string` | Yes      | The criteria time aggregation types.                                                                                                                                             |
| `actionGroupId`                       | `string` | Yes      | Action Group resource Id to invoke when the Alert fires.                                                                                                                         |

## Outputs

| Name | Type | Description |
| :--- | :--: | :---------- |

## Examples

### Example: Monitoring an Azure Monitor metric using a dynamic threshold

```bicep
resource app 'Microsoft.Web/sites@2021-03-01' existing = {
  name: 'mywebapp'
  scope: resourceGroup('some-other-rg')
}

resource action_group 'microsoft.insights/actionGroups@2022-06-01' existing = {
  name: 'MyActionGroup'
}

module response_time_alert 'br:<registry-fqdn>/bicep/alerting/single-metric-dynamic-alert:<version>' = {
  name: 'deployResponseTimeAlert'
  params: {
    name: 'slow-response-time-alert'
    actionGroupId: action_group.outputs.id
    alertDescription: 'Slow HTTP Response Alert'
    metricName: 'HttpResponseTime'
    metricNamespace: 'microsoft.web/sites'
    metricTimeAggregation: 'Average'
    metricRuleOperator: 'GreaterThan'
    evaluationFrequencyMinutes: 5
    evaluationWindowSizeMinutes: 5
    severity: 'Warning'
    targetScopes: [
      app.id
    ]
    minimumFailingPeriodsAlertThreshold: 4
    dynamicAlertSensitivity: 'Medium'
  }
}
```