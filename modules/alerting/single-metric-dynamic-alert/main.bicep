// <copyright file="single-metric-dynamic-alert/main.bicep" company="Endjin Limited">
// Copyright (c) Endjin Limited. All rights reserved.
// </copyright>

metadata name = 'Single Metric Dynamic Alert'
metadata description = 'Deploys an dynamic Alert based on a single Azure Monitor or AppInsights metric'
metadata owner = 'endjin'

@description('The metric Alert resource name.')
param name string

@description('The description of the alert')
param alertDescription string

@description('The severity of the alert.')
@allowed([
  'Critical'
  'Error'
  'Warning'
  'Informational'
  'Verbose'
])
param severity string

@description('The list of resource id\'s that this metric alert is scoped to.')
param targetScopes array

@description('The flag which indicates whether this Alert query is enabled')
param enabled bool = true

@description('How often the Alert query is evaluated, in minutes.')
param evaluationFrequencyMinutes int

@description('The period of time on which the Alert query will be executed, in minutes.')
param evaluationWindowSizeMinutes int = evaluationFrequencyMinutes

@description('The extent of deviation required to trigger an alert. This will affect how tight the threshold is to the metric series pattern.')
@allowed([
  'High'
  'Low'
  'Medium'
])
param dynamicAlertSensitivity string = 'Medium'

@description('The number of violations to trigger an alert. Should be smaller or equal to numberOfEvaluationPeriods.')
param minimumFailingPeriodsAlertThreshold int

@description('The number of aggregated lookback points. The lookback time window is calculated based on the aggregation granularity (windowSize) and the selected number of aggregated points.')
param numberOfEvaluationPeriods int = minimumFailingPeriodsAlertThreshold

@description('Namespace of the metric.')
param metricNamespace string

@description('Name of the metric.')
param metricName string

@description('The operator used to compare the metric value against the threshold.')
@allowed([
  'GreatorOrLessThan'
  'GreaterThan'
  'LessThan'
])
param metricRuleOperator string

@description('The criteria time aggregation types.')
@allowed([
  'Average'
  'Count'
  'Maximum'
  'Minimum'
  'Total'
])
param metricTimeAggregation string

@description('Action Group resource Id to invoke when the Alert fires.')
param actionGroupId string


module alert '../metric-alert/main.bicep' = {
  name: 'deployMetricAlert-${name}'
  params: {
    name: name
    alertDescription: alertDescription
    actionGroupId: actionGroupId
    allOfCriteria: [
      {
        name: 'metric1'
        alertSensitivity: dynamicAlertSensitivity
        failingPeriods: {
          numberOfEvaluationPeriods: numberOfEvaluationPeriods
          minFailingPeriodsToAlert: minimumFailingPeriodsAlertThreshold
        }
        metricNamespace: metricNamespace
        metricName: metricName
        operator: metricRuleOperator
        timeAggregation:  metricTimeAggregation
        criterionType: 'DynamicThresholdCriterion'
      }
    ]
    criteriaType: 'Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria'
    enabled: enabled
    evaluationFrequencyMinutes: evaluationFrequencyMinutes
    evaluationWindowSizeMinutes: evaluationWindowSizeMinutes
    severity: severity
    targetScopes: targetScopes
  }
}
