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

var subnetName = 'default'
resource vnet 'Microsoft.Network/virtualNetworks@2021-08-01' = {
  name: 'vnet${suffix}'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: '10.0.0.0/24'
        }
      }
    ]
  }
}

var requiredDnsZones = [
  'privatelink.dfs.${environment().suffixes.storage}'
  'privatelink${environment().suffixes.sqlServerHostname}'    // used for actual private endpoint DNS resolution of the Synapse SQL services
  'privatelink.dev.azuresynapse.net'
  'privatelink.sql.azuresynapse.net'      // used during private endpoint DNS registration
]
module privatedns_zones '../../private-dns-zone/main.bicep' = [ for zone in requiredDnsZones : {
  name: '${zone}-privateDnsDeploy'
  params: {
    zoneName: zone
    virtualNetworkResourceGroupName: resourceGroup().name
    virtualNetworkName: vnet.name
    autoRegistrationEnabled: false
  }
}]


resource managed_identity 'Microsoft.ManagedIdentity/userAssignedIdentities@2021-09-30-preview' = {
  name: 'mi${suffix}'
  location: location
}


module synapse '../main.bicep' = {
  name: 'synapseDeploy'
  params: {
    location: location
    workspaceName: 'synapse${suffix}'
    defaultDataLakeStorageAccountName: adls.outputs.name
    defaultDataLakeStorageFilesystemName: 'default'
    enableDiagnostics: true
    logAnalyticsWorkspaceId: log_analytics.outputs.id
    managedVirtualNetwork: true
    setWorkspaceIdentityRbacOnStorageAccount: true
    sqlAdministratorPrincipalId: managed_identity.properties.principalId
    sqlAdministratorPrincipalName: managed_identity.name
    enablePrivateEndpointsPrivateDns: true
    virtualNetworkResourceGroupName: resourceGroup().name
    virtualNetworkName: vnet.name
    subnetName: subnetName
    workspaceFirewallRules: [
      {
        name: 'test'
        startAddress: '86.134.37.29'
        endAddress: '86.134.37.29'
      }
    ]
    grantWorkspaceIdentityControlForSql: true
  }
  dependsOn: [
    privatedns_zones
  ]
}
