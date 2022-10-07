@description('The Synapse workspace that the spark pools are linked to')
param workspaceName string

@description('The location of the spark pool')
param location string

@description('An array of objects defining the spark pools that should be provisioned, with the structure {name: "<poolName>", properties: {<object>} } - where the properties object matches the schema documented here: https://docs.microsoft.com/en-us/azure/templates/microsoft.synapse/2021-03-01/workspaces/bigdatapools?tabs=json.  Also note that the first pool defined will be discoverable via App Configuration.')
param sparkPools array

@description('When true, the log diagnostic settings supported by the spark pool will be enabled')
param enableDiagnostics bool = false

@description('The log analytics workspace Id where diagnostics log data will be sent')
param logAnalyticsWorkspaceId string = ''

@description('The resource tags applied to resources')
param tagValues object = {}


targetScope = 'resourceGroup'


resource workspace 'Microsoft.Synapse/workspaces@2021-06-01' existing = {
  name: workspaceName
}

resource spark_pool 'Microsoft.Synapse/workspaces/bigDataPools@2021-06-01' = [for sparkPool in sparkPools : {
  name: sparkPool.name
  parent: workspace
  location: location
  properties: sparkPool.properties
  tags: tagValues
}]

resource spark_pool_diagnostic_settings 'microsoft.insights/diagnosticSettings@2016-09-01' = [for (sparkPool, i) in sparkPools : if (enableDiagnostics) {
  name: 'service'
  scope: spark_pool[i]
  location: location
  properties: {
    workspaceId: logAnalyticsWorkspaceId
    logs: [
      {
        category: 'BigDataPoolAppsEnded'
        enabled: true
      }
    ]
  }
}]


@description('The name of the default Spark Pool. Note: the first configured Spark Pool will be considered the notional default.')
output defaultSparkPoolName string = spark_pool[0].name
