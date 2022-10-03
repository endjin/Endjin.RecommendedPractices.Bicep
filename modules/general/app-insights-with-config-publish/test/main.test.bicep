param prefix string = uniqueString(resourceGroup().id)
param location string = resourceGroup().location

var logAnalyticsWorkspaceName = '${prefix}la'

resource key_vault 'Microsoft.KeyVault/vaults@2021-11-01-preview' = {
  name: '${prefix}kv'
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: tenant().tenantId
    accessPolicies: []
  }
}

resource log_analytics_workspace 'Microsoft.OperationalInsights/workspaces@2021-12-01-preview' = {
  name: logAnalyticsWorkspaceName
  location: location
}

module app_insights '../main.bicep' = {
  name: 'appInsightsDeploy'
  params: {
    location: location
    name: '${prefix}ai'
    keyVaultName: key_vault.name
    keyVaultResourceGroupName: resourceGroup().name
    logAnalyticsWorkspaceName: log_analytics_workspace.name
  }
}
