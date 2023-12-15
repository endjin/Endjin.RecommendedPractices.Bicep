param suffix string = uniqueString(resourceGroup().id)
param location string = resourceGroup().location

module log_analytics '../../log-analytics/main.bicep' = {
  name: 'logAnalyticsDeploy'
  params: {
    location: location
    dailyQuotaGb: 1
    enableLogAccessUsingOnlyResourcePermissions: false
    name: 'la${suffix}'
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
    skuName: 'PerGB2018'
  }
}

module acs_email '../main.bicep' = {
  name: 'acsEmailDeploy'
  params: {
    communicationServiceName: 'acs-${suffix}'
    emailServiceName: 'acs-email-${suffix}'
    dataLocation: 'Switzerland'
    senderUsername: 'FooBar'
    enableDiagnostics: true
    logAnalyticsWorkspaceId: log_analytics.outputs.id
  }
}
