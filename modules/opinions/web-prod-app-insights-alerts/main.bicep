@description('The Azure location for the App Insights Alert resources.')
param alertLocation string

@description('The resource ID of the App Insights instance to apply to the alerts to.')
param appInsightsResourceId string

var alerts = [
  {
    alertName: 'any-500-errors'
    timeAggregation: 'Count'
    query: 'requests\n| where resultCode == 500\n| count'
    operator: 'GreaterThan'
    threshold: 0
    evaluationFrequency: 'PT5M'
    severity: 1
    windowSize: 'PT5M'
    numberOfEvaluationPeriods: 1
    minFailingPeriodsToAlert: 1
  }
]

resource alert 'microsoft.insights/scheduledqueryrules@2021-02-01-preview' = [for alert in alerts: {
  name: alert.alertName
  location: alertLocation
  properties: {
    displayName: alert.alertName
    severity: alert.severity
    enabled: true
    evaluationFrequency: alert.evaluationFrequency
    scopes: [
      appInsightsResourceId
    ]
    windowSize: alert.windowSize
    criteria: {
      allOf: [
        {
          query: alert.query
          timeAggregation: alert.timeAggregation
          operator: alert.operator
          threshold: alert.threshold
          failingPeriods: {
            numberOfEvaluationPeriods: alert.numberOfEvaluationPeriods
            minFailingPeriodsToAlert: alert.minFailingPeriodsToAlert
          }
        }
      ]
    }
  }
}]
