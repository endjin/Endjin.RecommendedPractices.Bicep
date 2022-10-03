@description('Name of existing private DNS zone that the CNAME record will be associated with.')
param zoneName string

@description('The resource name for the CNAME record.')
param recordName string

@description('The value for the CNAME record.')
param recordValue string

@description('Key-value pair metadata associated with the CNAME record.')
param recordMetadata object = {}

@description('The TTL (time-to-live) for the CNAME record, in seconds.')
param recordTtl int = 10

resource private_dns_zone 'Microsoft.Network/privateDnsZones@2020-06-01' existing = {
  name: zoneName
}

resource cname_record 'Microsoft.Network/privateDnsZones/CNAME@2020-06-01' = {
  parent: private_dns_zone
  name: recordName
  properties: {
    cnameRecord: {
      cname: recordValue
    }
    metadata: recordMetadata
    ttl: recordTtl
  }
}
