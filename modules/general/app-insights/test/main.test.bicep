param prefix string = uniqueString(resourceGroup().id)
param location string = resourceGroup().location

var logAnalyticsWorkspaceName = '${prefix}la'

resource log_analytics_workspace 'Microsoft.OperationalInsights/workspaces@2021-12-01-preview' = {
  name: logAnalyticsWorkspaceName
  location: location
}

module app_insights '../main.bicep' = {
  name: 'appInsightsDeploy'
  params: {
    location: location
    name: '${prefix}ai'
    logAnalyticsWorkspaceName: logAnalyticsWorkspaceName
  }
  dependsOn: [
    log_analytics_workspace
  ]
}

module app_insights_public_access_disabled '../main.bicep' = {
  name: 'appInsightsPublicAccessDisabledDeploy'
  params: {
    location: location
    name: '${prefix}aipad'
    disablePublicNetworkAccessForIngestion: true
    disablePublicNetworkAccessForQuery: true
    logAnalyticsWorkspaceName: log_analytics_workspace.name
  }
}
