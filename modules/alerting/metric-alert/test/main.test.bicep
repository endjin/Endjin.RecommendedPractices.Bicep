param prefix string = uniqueString(resourceGroup().id)
param location string = resourceGroup().location

module action_group '../../email-action-group/main.bicep' = {
  name: '${prefix}AgDeploy'
  params: {
    name: prefix
    notifyEmailAddresses: [
      'noone@nowhere.org'
    ]
    shortName: prefix
  }
}

module app_insights '../../../general/app-insights/main.bicep' = {
  name: '${prefix}AiDeploy'
  params: {
    location: location
    logAnalyticsWorkspaceName: '${prefix}logs'
    name: '${prefix}ai'
  }
}

module alert '../main.bicep' = {
  name: '${prefix}AlertDeploy'
  params: {
    name: prefix
    alertDescription: 'Test metric alert'
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
