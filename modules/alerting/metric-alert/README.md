# Azure Metric Alert

Deploys an alert based on an Azure Monitor or AppInsights metric

## Description

Provides a simplified wrapper around the `Microsoft.Insights/metricAlerts` resource used to configure alerts based on Azure Monitor metrics exposed by a given resource, or using metrics available via an Application Insights workspace.

## Parameters

| Name                          | Type     | Required | Description                                                                                    |
| :---------------------------- | :------: | :------: | :--------------------------------------------------------------------------------------------- |
| `name`                        | `string` | Yes      | The metric Alert resource name.                                                                |
| `allOfCriteria`               | `array`  | Yes      | Defines the criteria that must be true to fire the Alert.                                      |
| `actionGroupId`               | `string` | Yes      | Action Group resource Id to invoke when the Alert fires.                                       |
| `criteriaType`                | `string` | No       | The type of metric Alert criteria                                                              |
| `alertDescription`            | `string` | No       | The description of the alert                                                                   |
| `enabled`                     | `bool`   | Yes      | The flag which indicates whether this Alert query is enabled                                   |
| `evaluationFrequencyMinutes`  | `int`    | Yes      | How often the Alert query is evaluated, in minutes.                                            |
| `evaluationWindowSizeMinutes` | `int`    | No       | The period of time on which the Alert query will be executed, in minutes.                      |
| `targetScopes`                | `array`  | Yes      | The list of resource id's that this Alert is scoped to.                                        |
| `autoMitigate`                | `bool`   | No       | The flag that indicates whether the alert should be auto resolved or not. The default is true. |
| `severity`                    | `string` | Yes      | The severity of the alert.                                                                     |

## Outputs

| Name | Type   | Description                  |
| :--- | :----: | :--------------------------- |
| id   | string | The resource ID of the alert |

## Examples

### Example 1: Monitoring a single AppInsights metric across multiple applications using the same workspace

```bicep
resource app_insights 'Microsoft.Insights/components@2020-02-02-preview' existing = {
  name: 'myappinsights01'
  scope: resourceGroup('some-other-rg')
}

resource action_group 'microsoft.insights/actionGroups@2022-06-01' existing = {
  name: 'MyActionGroup'
}

module alert 'br:<registry-fqdn>/bicep/alerting/metric-alert:<version>' = {
  name: '${prefix}AlertDeploy'
  params: {
    name: prefix
    alertDescription: '${app_insights.name} - Failed Requests Alert'
    actionGroupId: action_group.outputs.id
    allOfCriteria: [
      {
        threshold: 0
        name: 'FailedRequestsMetric'
        metricNamespace: 'microsoft.insights/components'
        metricName: 'requests/failed'
        dimensions: []
        operator: 'GreaterThan'
        timeAggregation: 'Count'
        skipMetricValidation: false
        criterionType: 'StaticThresholdCriterion'
      }
    ]
    criteriaType: 'Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria'
    enabled: true
    evaluationFrequencyMinutes: 5
    evaluationWindowSizeMinutes: 5
    severity: 'Critical'
    targetScopes: [
      app_insights.outputs.id
    ]
  }
}
```

### Example 2: Monitoring an AppInsights metric for one application

```bicep
resource app_insights 'Microsoft.Insights/components@2020-02-02-preview' existing = {
  name: 'myappinsights01'
  scope: resourceGroup('some-other-rg')
}

resource app 'Microsoft.Web/sites@2021-03-01' existing = {
  name: 'mywebapp'
  scope: resourceGroup('some-other-rg')
}

resource action_group 'microsoft.insights/actionGroups@2022-06-01' existing = {
  name: 'MyActionGroup'
}

module alert 'br:<registry-fqdn>/bicep/alerting/metric-alert:<version>' = {
  name: '${prefix}AlertDeploy'
  params: {
    name: prefix
    alertDescription: '${app.name} - Failed Request Alert'
    actionGroupId: action_group.outputs.id
    allOfCriteria: [
      {
        threshold: 0
        name: 'FailedRequestsMetric'
        metricNamespace: 'microsoft.insights/components'
        metricName: 'requests/failed'
        dimensions: [
          {
            name: 'cloud/roleName'
            operator: 'Include'
            values: [
              app.name
            ]
          }
        ]
        operator: 'GreaterThan'
        timeAggregation: 'Count'
        skipMetricValidation: false
        criterionType: 'StaticThresholdCriterion'
      }
    ]
    criteriaType: 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
    enabled: true
    evaluationFrequencyMinutes: 5
    evaluationWindowSizeMinutes: 5
    severity: 'Critical'
    targetScopes: [
      app_insights.outputs.id
    ]
  }
}
```