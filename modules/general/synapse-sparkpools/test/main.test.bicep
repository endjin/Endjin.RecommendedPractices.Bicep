param suffix string = uniqueString(resourceGroup().id)
param location string = resourceGroup().location

module adls '../../storage-account/main.bicep' = {
  name: 'storageDeploy'
  params: {
    name: 'adls${suffix}'
    location: location
    isHnsEnabled: true
  }
}

module log_analytics '../../log-analytics/main.bicep' = {
  name: 'logAnalyticsDeploy'
  params: {
    location: location
    dailyQuotaGb: 1
    enableLogAccessUsingOnlyResourcePermisions: false
    name: 'la${suffix}'
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
    skuName: 'PerGB2018'
  }
}

resource managed_identity 'Microsoft.ManagedIdentity/userAssignedIdentities@2021-09-30-preview' = {
  name: 'mi${suffix}'
  location: location
}

module synapse '../../synapse-workspace/main.bicep' = {
  name: 'synapseDeploy'
  params: {
    location: location
    sqlAdministratorPrincipalName: managed_identity.name
    sqlAdministratorPrincipalId: managed_identity.properties.principalId
    defaultDataLakeStorageFilesystemName: 'default'
    workspaceName: 'syn${suffix}'
    enabledSynapsePrivateEndpointServices: []
    enablePrivateEndpointsPrivateDns: false
    enableDiagnostics: true
    logAnalyticsWorkspaceId: log_analytics.outputs.id
    defaultDataLakeStorageAccountName: adls.outputs.name
    setWorkspaceIdentityRbacOnStorageAccount: false
  }
}

module spark_pools '../main.bicep' = {
  name: 'sparkPoolsDeploy'
  params: {
    location: location
    enableDiagnostics: true
    logAnalyticsWorkspaceId: log_analytics.outputs.id
    sparkPools: [
      {
        name: 'default'
        properties: {
          autoPause: {
            delayInMinutes: 30
            enabled: true
          }
          autoScale: {
            enabled: true
            maxNodeCount: 5
            minNodeCount: 3
          }
          nodeCount: 1
          nodeSize: 'Small'
          nodeSizeFamily: 'MemoryOptimized'
          sparkVersion: '3.2'
        }
      }
      {
        name: 'other'
        properties: {
          autoPause: {
            enabled: false
          }
          autoScale: {
            enabled: false
          }
          nodeCount: 3
          nodeSize: 'Medium'
          nodeSizeFamily: 'MemoryOptimized'
          sparkVersion: '3.1'
        }
      }
    ]
    workspaceName: synapse.outputs.name
  }
}
