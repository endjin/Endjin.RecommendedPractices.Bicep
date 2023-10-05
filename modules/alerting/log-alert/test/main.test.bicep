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

module log_analytics '../../../general/log-analytics/main.bicep' = {
  name: prefix
  params: {
    location: location
    dailyQuotaGb: 1
    enableLogAccessUsingOnlyResourcePermissions: false
    name: prefix
    publicNetworkAccessForIngestion: 'Disabled'
    publicNetworkAccessForQuery: 'Disabled'
  }
}

module alert '../main.bicep' = {
  name: prefix
  params: {
    actionGroupId: action_group.outputs.id
    alertDescription: 'Test log alert description'
    displayName: 'Test Log Alert'
    evaluationFrequencyMinutes: 5
    location: location
    name: prefix
    query: loadTextContent('./query.txt')
    queryThreshold: 0
    queryThresholdOperator: 'GreaterThan'
    queryTimeAggregation: 'Count'
    severity: 'Critical'
    targetScopes: [
      log_analytics.outputs.id
    ]
  }
}
