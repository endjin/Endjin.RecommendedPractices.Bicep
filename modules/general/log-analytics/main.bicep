@description('The name of the log analytics workspace')
param name string
@description('The location of the log analytics workspace')
param location string = resourceGroup().location
@description('The SKU of the log analytics workspace')
param skuName string = 'Standard'
@description('The daily ingestion quota (in GB) of the log analytics workspace - use "-1" for no limit')
param dailyQuotaGb int
@description('When true, the log analytics workspace will only be accessible by using resource permissions')
param enableLogAccessUsingOnlyResourcePermisions bool
@description('Indicates whether the public network access for ingestion is enabled or disabled')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccessForIngestion string
@description('Indicates whether the public network access for query is enabled or disabled')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccessForQuery string
@description('The tag values of the log analytics workspace')
param tagValues object = {}
@description('When true, the details of an existing log analytics workspace will be returned; When false, the log analytics workspace is created/updated')
param useExisting bool = false


targetScope = 'resourceGroup'

resource existing_log_analytics_workspace 'Microsoft.OperationalInsights/workspaces@2020-10-01' existing = if (useExisting) {
  name: name
}

resource log_analytics_workspace 'Microsoft.OperationalInsights/workspaces@2020-10-01' = if (!useExisting) {
  name: name
  location: location
  properties: {
    sku: {
      name: skuName
    }
    features: {
      enableLogAccessUsingOnlyResourcePermissions: enableLogAccessUsingOnlyResourcePermisions
    }
    workspaceCapping: {
      dailyQuotaGb: dailyQuotaGb
    }
    publicNetworkAccessForIngestion: publicNetworkAccessForIngestion
    publicNetworkAccessForQuery: publicNetworkAccessForQuery
  }
  tags: tagValues

}

@description('An object representing the log analytics workspace')
output workspaceResource object =  useExisting ? existing_log_analytics_workspace : log_analytics_workspace

@description('The workspace resource name')
output name string =  useExisting ? existing_log_analytics_workspace.name : log_analytics_workspace.name

@description('The workspace resource ID')
output id string = useExisting ? existing_log_analytics_workspace.id : log_analytics_workspace.id
