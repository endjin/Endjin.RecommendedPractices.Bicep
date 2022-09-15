@description('The name of the log analytics workspace')
param name string
@description('The location of the log analytics workspace')
param location string
@description('The SKU of the log analytics workspace')
param skuName string
@description('The daily ingestion quota (in GB) of the log analytics workspace - use "-1" for no limit')
param dailyQuotaGb int
param enableLogAccessUsingOnlyResourcePermisions bool
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccessForIngestion string
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccessForQuery string
param tagValues object = {}
@description('When true, the details of an existing log analytics workspace will be returned; When false, the log analytics workspace is created/updated')
param useExisting bool = false


targetScope = 'resourceGroup'


resource log_analytics_workspace 'Microsoft.OperationalInsights/workspaces@2020-10-01' = {
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
output workspaceResource object =  useExisting ? existing_key_vault : log_analytics_workspace

@description('The workspace resource name')
output name string =  useExisting ? existing_key_vault : log_analytics_workspace.name

@description('The workspace resource ID')
output id string = log_analytics_workspace.id
