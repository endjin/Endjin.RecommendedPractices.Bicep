// <copyright file="log-alert/main.bicep" company="Endjin Limited">
// Copyright (c) Endjin Limited. All rights reserved.
// </copyright>

metadata name = 'Azure Log Alert'
metadata description = 'Deploys an alert based on a Log Analytics query'
metadata owner = 'endjin'

@description('The Alert resource name.')
param name string

@description('The display name of the Alert rule.')
param displayName string

@description('The description of the alert')
param alertDescription string

@description('Action Group resource Id to invoke when the Alert fires.')
param actionGroupId string

@description('The flag which indicates whether this Alert query is enabled')
param enabled bool = true

@description('How often the Alert query is evaluated, in minutes.')
param evaluationFrequencyMinutes int

@description('The period of time on which the Alert query will be executed, in minutes.')
param evaluationWindowSizeMinutes int = evaluationFrequencyMinutes

@description('The list of resource id\'s that this Alert query is scoped to.')
param targetScopes array

@description('List of resource type of the target resource(s) on which the alert is created/updated. For example if the scope is a resource group and targetResourceTypes is Microsoft.Compute/virtualMachines, then a different alert will be fired for each virtual machine in the resource group which meet the alert criteria.')
param targetResourceTypes array = ['microsoft.insights/components']

@description('The severity of the alert.')
@allowed([
  'Critical'
  'Error'
  'Warning'
  'Informational'
  'Verbose'
])
param severity string

@description('Log query alert')
param query string

@description('The criteria threshold value that activates the alert.')
param queryThreshold int

@allowed([
  'Average'
  'Count'
  'Maximum'
  'Minimum'
  'Total'
])
@description('Aggregation type.')
param queryTimeAggregation string

@allowed([
  'GreatorOrLessThan'
  'GreaterThan'
  'LessThan'
])
@description('The criteria operator.')
param queryThresholdOperator string

@description('The location of the deployed resources')
param location string

@description('The number of aggregated lookback points. The lookback time window is calculated based on the aggregation granularity (windowSize) and the selected number of aggregated points.')
param numberOfEvaluationPeriods int = 1

@description('The number of violations to trigger an alert. Should be smaller or equal to numberOfEvaluationPeriods.')
param minFailingPeriodsToAlert int = 1

@description('The flag that indicates whether the alert should be auto resolved or not. The default is true.')
param autoMitigate bool = false


module alert_utils '../../../modules-internal/alerting-helpers.bicep' = {
  name: 'alertUtils_${severity}'
  params: {
    severity: severity
    evaluationFrequencyMinutes: evaluationFrequencyMinutes
    evaluationWindowSizeMinutes: evaluationWindowSizeMinutes
  }
}

resource log_alert 'Microsoft.Insights/scheduledQueryRules@2021-08-01' = {
  name: name
  location: location
  properties: {
    displayName: displayName
    description: alertDescription
    severity: alert_utils.outputs.severity
    enabled: enabled
    evaluationFrequency: alert_utils.outputs.evaluationFrequency
    scopes: targetScopes
    targetResourceTypes: targetResourceTypes
    windowSize: alert_utils.outputs.evaluationWindowSize
    criteria: {
      allOf: [
        {
          query: query
          timeAggregation: queryTimeAggregation
          dimensions: []
          operator: queryThresholdOperator
          threshold: queryThreshold
          failingPeriods: {
            numberOfEvaluationPeriods: numberOfEvaluationPeriods
            minFailingPeriodsToAlert: minFailingPeriodsToAlert
          }
        }
      ]
    }
    actions: {
      actionGroups: [
        actionGroupId     
      ]
      customProperties: {}
    }
    autoMitigate: autoMitigate
  }
}

@description('The resource ID of the alert')
output id string = log_alert.id
