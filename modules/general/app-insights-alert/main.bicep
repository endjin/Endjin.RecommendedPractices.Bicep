@description('The Azure location for the App Insights Alert resource.')
param alertLocation string

@description('The name of the App Insights Alert resource.')
param alertName string

@description('The resource ID of the App Insights instance to apply to the alert to.')
param appInsightsResourceId string

@description('KQL query for the alert.')
param query string

@description('The criteria operator for the alert.')
@allowed([
  'Equals'
  'GreaterThan'
  'GreaterThanOrEqual'
  'LessThan'
  'LessThanOrEqual'
])
param operator string

@description('The aggregation for the alert')
@allowed([
  'Average'
  'Count'
  'Maximum'
  'Minimum'
  'Total'
])
param timeAggregation string

@description('The criteria threshold value that activates the alert.')
param threshold int

@description('How often the scheduled query rule is evaluated represented in ISO 8601 duration format')
param evaluationFrequency string

resource alert 'microsoft.insights/scheduledqueryrules@2021-02-01-preview' = {
  name: alertName
  location: alertLocation
  properties: {
    displayName: alertName
    severity: 1
    enabled: true
    evaluationFrequency: evaluationFrequency
    scopes: [
      appInsightsResourceId
    ]
    windowSize: 'PT5M'
    criteria: {
      allOf: [
        {
          query: query
          timeAggregation: timeAggregation
          operator: operator
          threshold: threshold
          failingPeriods: {
            numberOfEvaluationPeriods: 1
            minFailingPeriodsToAlert: 1
          }
        }
      ]
    }
  }
}
