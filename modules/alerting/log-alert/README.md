# Azure Log Alert

Deploys an alert based on a Log Analytics query

## Details

{{Add detailed information about the module}}

## Parameters

| Name                          | Type     | Required | Description                                                                                                                                                                                                                                                                                                          |
| :---------------------------- | :------: | :------: | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `name`                        | `string` | Yes      | The Alert resource name.                                                                                                                                                                                                                                                                                             |
| `displayName`                 | `string` | Yes      | The display name of the Alert rule.                                                                                                                                                                                                                                                                                  |
| `alertDescription`            | `string` | Yes      | The description of the alert                                                                                                                                                                                                                                                                                         |
| `actionGroupId`               | `string` | Yes      | Action Group resource Id to invoke when the Alert fires.                                                                                                                                                                                                                                                             |
| `enabled`                     | `bool`   | No       | The flag which indicates whether this Alert query is enabled                                                                                                                                                                                                                                                         |
| `evaluationFrequencyMinutes`  | `int`    | Yes      | How often the Alert query is evaluated, in minutes.                                                                                                                                                                                                                                                                  |
| `evaluationWindowSizeMinutes` | `int`    | No       | The period of time on which the Alert query will be executed, in minutes.                                                                                                                                                                                                                                            |
| `targetScopes`                | `array`  | Yes      | The list of resource id's that this Alert query is scoped to.                                                                                                                                                                                                                                                        |
| `targetResourceTypes`         | `array`  | No       | List of resource type of the target resource(s) on which the alert is created/updated. For example if the scope is a resource group and targetResourceTypes is Microsoft.Compute/virtualMachines, then a different alert will be fired for each virtual machine in the resource group which meet the alert criteria. |
| `severity`                    | `string` | Yes      | The severity of the alert.                                                                                                                                                                                                                                                                                           |
| `query`                       | `string` | Yes      | Log query alert                                                                                                                                                                                                                                                                                                      |
| `queryThreshold`              | `int`    | Yes      | The criteria threshold value that activates the alert.                                                                                                                                                                                                                                                               |
| `queryTimeAggregation`        | `string` | Yes      | Aggregation type.                                                                                                                                                                                                                                                                                                    |
| `queryThresholdOperator`      | `string` | Yes      | The criteria operator.                                                                                                                                                                                                                                                                                               |
| `location`                    | `string` | Yes      | The location of the deployed resources                                                                                                                                                                                                                                                                               |
| `numberOfEvaluationPeriods`   | `int`    | No       | The number of aggregated lookback points. The lookback time window is calculated based on the aggregation granularity (windowSize) and the selected number of aggregated points.                                                                                                                                     |
| `minFailingPeriodsToAlert`    | `int`    | No       | The number of violations to trigger an alert. Should be smaller or equal to numberOfEvaluationPeriods.                                                                                                                                                                                                               |
| `autoMitigate`                | `bool`   | No       | The flag that indicates whether the alert should be auto resolved or not. The default is true.                                                                                                                                                                                                                       |

## Outputs

| Name | Type     | Description                  |
| :--- | :------: | :--------------------------- |
| `id` | `string` | The resource ID of the alert |

## Examples

### Example Usage

```bicep

resource log_analytics 'Microsoft.OperationalInsights/workspaces@2020-10-01' existing = {
  name: 'myloganalytics01'
  scope: resourceGroup('some-other-rg')
}

resource action_group 'microsoft.insights/actionGroups@2022-06-01' existing = {
  name: 'MyActionGroup'
}

var query = '''
requests
| where success == false
| summarize failedCount=sum(itemCount), impactedUsers=dcount(user_Id) by operation_Name
| order by failedCount desc
'''
module alert 'br:<registry-fqdn>/bicep/alerting/log-alert:<version>' = {
  name: 'testLogAlertDeploy'
  params: {
    actionGroupId: action_group.outputs.id
    alertDescription: 'Test log alert description'
    displayName: 'Test Log Alert'
    evaluationFrequencyMinutes: 5
    location: 'northeurope'
    name: 'test-log-alert'
    query: query
    queryThreshold: 0
    queryThresholdOperator: 'GreaterThan'
    queryTimeAggregation: 'Count'
    severity: 'Error'
    targetScopes: [
      log_analytics.id
    ]
  }
}
```