param prefix string = uniqueString(resourceGroup().id)
param location string = 'uksouth'

var logAnalyticsWorkspaceName = '${prefix}la'

resource log_analytics_workspace 'Microsoft.OperationalInsights/workspaces@2021-12-01-preview' = {
  name: logAnalyticsWorkspaceName
  location: location
}

module appinsights '../../../general/app-insights/main.bicep' = {
  name: 'appInsights'
  params:{
    name: '${prefix}ai'
    location: location
    logAnalyticsWorkspaceName: log_analytics_workspace.name
  }
}

module appinsightsalert '../main.bicep' = {
  name: 'appInsightsAlert'
  params: {
    appInsightsResourceId: appinsights.outputs.id
    alertLocation: location
  }
}
