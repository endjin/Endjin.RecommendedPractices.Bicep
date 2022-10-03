@description('The name of the private endpoint')
param name string

@description('The location of the private endpoint')
param location string

@description('The subscription of the virtual network the private endpoint will be connected to')
param virtualNetworkSubscriptionId string = subscription().subscriptionId

@description('The resource group of the virtual network the private endpoint will be connected to')
param virtualNetworkResourceGroup string

@description('The name of the virtual network the private endpoint will be connected to')
param virtualNetworkName string

@description('The name of the subnet the private endpoint will be connected to')
param subnetName string

@description('The resource Id of the service that will be accessible via this private endpoint')
param serviceResourceId string

@description('The service\'s sub-resource (if any) to be associated with the private endpoint')
@allowed([
  'vault'                 // key vault
  'dfs'                   // data lake storage
  'blob'                  // blob storage
  'file'                  // files storage
  'queue'                 // queue storage
  'table'                 // table storage
  'web'                   // static web sites
  'configurationStores'   // app configuration
  'sql'                   // azure sql / synapse sql pools
  'sqlOnDemand'           // synapse sql serverless
  'dev'                   // synapse workspace
])
param serviceGroupId string

@description('When true, the serviceGroupId will be appended to the private endpoint name with the convention: <name>-<serviceGroupId>. Useful when a resource exposes multiple services as private endpoints.')
param appendServiceToName bool = true

@description('When true, the private endpoint sub-resource will be registered with the relevant PrivateDns zone')
param enablePrivateDns bool

@description('The subscription where the PrivateDns zones are managed, defaults to the virtual network resource group')
param privateDnsZonesSubscriptionId string = virtualNetworkSubscriptionId

@description('The resource group where the PrivateDns zones are managed, defaults to the virtual network resource group')
param privateDnsZonesResourceGroup string = virtualNetworkResourceGroup

@description('The PrivateDns zone the private endpoint will be registered in. When blank, the module will attempt to identify the required zone from a list of common services')
param privateDnsZoneName string = ''

@description('The resource tags applied to resources')
param tagValues object = {}


// Lookup existing resources
resource vnet 'Microsoft.Network/virtualNetworks@2021-08-01' existing = {
  name: virtualNetworkName
  scope: resourceGroup(virtualNetworkSubscriptionId, virtualNetworkResourceGroup)
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2021-08-01' existing = {
  name: subnetName
  parent: vnet
}

// Helper to map some common private endpoint service groups to their associated PrivateDns zones
// Ref: https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-dns
var serviceGroupPrivateDnsZoneLookup = {
  vault: 'privatelink.vaultcore.azure.net'
  dfs: 'privatelink.dfs.${environment().suffixes.storage}'
  blob: 'privatelink.blob.${environment().suffixes.storage}'
  file: 'privatelink.file.${environment().suffixes.storage}'
  queue: 'privatelink.queue.${environment().suffixes.storage}'
  table: 'privatelink.table.${environment().suffixes.storage}'
  web: 'privatelink.web.${environment().suffixes.storage}'
  configurationStores: 'privatelink.azconfig.io'
  sql: 'privatelink.sql.azuresynapse.net'
  sqlOnDemand: 'privatelink.sql.azuresynapse.net'
  dev: 'privatelink.dev.azuresynapse.net'
}
resource dns_zone 'Microsoft.Network/privateDnsZones@2020-06-01' existing = if (enablePrivateDns) {
  // Use the above lookup table unless the name of the DNS zone has been specified
  name: !empty(privateDnsZoneName) ? privateDnsZoneName : serviceGroupPrivateDnsZoneLookup[serviceGroupId]
  scope: resourceGroup(privateDnsZonesSubscriptionId, privateDnsZonesResourceGroup)
}


// Deploy Private Endpoint
var endpointName = appendServiceToName ? toLower('${name}-${serviceGroupId}') : toLower(name)
resource private_endpoint 'Microsoft.Network/privateEndpoints@2021-08-01' = {
  name: endpointName
  location: location
  properties: {
    subnet: {
      id: subnet.id
    }
    privateLinkServiceConnections: [
      {
        name: endpointName
        properties: {
          privateLinkServiceId: serviceResourceId
          groupIds: array(serviceGroupId)
        }
      }
    ]
  }
  tags: tagValues
}

resource private_endpoint_privatedns_zone_group 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2021-08-01' = if (enablePrivateDns) {
  parent: private_endpoint
  name: private_endpoint.name
  properties: {
    privateDnsZoneConfigs : [
      {
        name: 'config-${serviceGroupId}'
        properties: {
          privateDnsZoneId: dns_zone.id
        }
      }
    ]
  }
}


// Template outputs
@description('The resource ID of the private endpoint')
output privateEndpointId string = private_endpoint.id
@description('The resource ID of the PrivateDns zone')
output privateDnsZoneId string = enablePrivateDns ? private_endpoint_privatedns_zone_group.id : ''

// Returns the full resource objects (workaround whilst resource types cannot be returned directly)
@description('An object representing the private endpoint resource')
output privateEndpointResource object = private_endpoint
