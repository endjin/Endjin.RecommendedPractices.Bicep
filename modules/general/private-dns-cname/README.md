# Private DNS CNAME

Adds/updates a CNAME record in an existing private DNS zone

## Details

Creates a new [CNAME record](https://learn.microsoft.com/en-us/azure/dns/dns-zones-records#cname-records) in the provided existing private DNS zone.

## Parameters

| Name             | Type     | Required | Description                                                                      |
| :--------------- | :------: | :------: | :------------------------------------------------------------------------------- |
| `zoneName`       | `string` | Yes      | Name of existing private DNS zone that the CNAME record will be associated with. |
| `recordName`     | `string` | Yes      | The resource name for the CNAME record.                                          |
| `recordValue`    | `string` | Yes      | The value for the CNAME record.                                                  |
| `recordMetadata` | `object` | No       | Key-value pair metadata associated with the CNAME record.                        |
| `recordTtl`      | `int`    | No       | The TTL (time-to-live) for the CNAME record, in seconds.                         |

## Outputs

| Name | Type | Description |
| :--- | :--: | :---------- |

## Examples

### Add CNAME records for Synapse SQL-related private endpoints

```bicep
var sqlPrivateLinkFqdn = 'privatelink${environment().suffixes.sqlServerHostname}'

module privatedns_zone 'br:<registry-fqdn>/bicep/general/private-dns-zone:<version>' = {
  name: '${zone}-privateDnsDeploy'
  params: {
    zoneName: sqlPrivateLinkFqdn
    virtualNetworkResourceGroupName: 'my-vnet-rg'
    virtualNetworkName: 'myvnet'
    autoRegistrationEnabled: false
  }
}

var synapseWorkspaceName = 'mysynapseworkspace'

module sql_cname_records 'br:<registry-fqdn>/bicep/general/private-dns-cname:<version>' = {
  name: 'sqlCNameDeploy'
  params: {
    recordName: synapseWorkspaceName
    recordValue: '${synapseWorkspaceName}.privatelink.sql.azuresynapse.net'
    zoneName: sqlPrivateLinkFqdn
    recordMetadata: {
      creator: 'Created to support private endpoint access to Azure Synapse SQL Pools'
    }
  }
}

module sqlondemand_cname_records 'br:<registry-fqdn>/bicep/general/private-dns-cname:<version>' = {
  name: 'sqlOnDemandCNameDeploy'
  params: {
    recordName: '${synapseWorkspaceName}-ondemand'
    recordValue: '${synapseWorkspaceName}-ondemand.privatelink.sql.azuresynapse.net'
    zoneName: sqlPrivateLinkFqdn
    recordMetadata: {
      creator: 'Created to support private endpoint access to Azure Synapse SQL Pools'
    }
  }
}
```