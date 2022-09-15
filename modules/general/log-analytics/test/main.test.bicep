/*
Write deployment tests in this file. Any module that references the main
module file is a deployment test. Make sure at least one test is added.
*/
param name string = 'logAnalyticsResourceName'
param location string = resourceGroup().location
param skuName string = 'skuName'
param dailyQuotaGb int = 2
param enableLogAccessUsingOnlyResourcePermisions bool = true
param publicNetworkAccessForIngestion string = 'Enabled'
param publicNetworkAccessForQuery string = 'Enabled'

module loganalytics '../main.bicep' = {
  name: 'logAnalytics'
  params: {
    name: name
    location: location
    skuName: skuName
    dailyQuotaGb: dailyQuotaGb
    enableLogAccessUsingOnlyResourcePermisions: enableLogAccessUsingOnlyResourcePermisions
    publicNetworkAccessForIngestion: publicNetworkAccessForIngestion
    publicNetworkAccessForQuery: publicNetworkAccessForQuery
  }
}
