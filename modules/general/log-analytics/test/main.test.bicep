param prefix string = uniqueString(resourceGroup().id)
param location string = resourceGroup().location
param skuName string = 'Standard'
param dailyQuotaGb int = 2
param enableLogAccessUsingOnlyResourcePermissions bool = true
param publicNetworkAccessForIngestion string = 'Enabled'
param publicNetworkAccessForQuery string = 'Enabled'

module loganalytics '../main.bicep' = {
  name: 'logAnalytics'
  params: {
    name: '${prefix}la'
    location: location
    skuName: skuName
    dailyQuotaGb: dailyQuotaGb
    enableLogAccessUsingOnlyResourcePermissions: enableLogAccessUsingOnlyResourcePermissions
    publicNetworkAccessForIngestion: publicNetworkAccessForIngestion
    publicNetworkAccessForQuery: publicNetworkAccessForQuery
  }
}
