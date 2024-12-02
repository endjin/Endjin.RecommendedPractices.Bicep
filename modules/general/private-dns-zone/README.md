# Private DNS Zone

Adds/updates a private DNS zone and virtual network link for existing VNet

## Details

Creates a [private Azure DNS zone](https://learn.microsoft.com/en-us/azure/dns/private-dns-privatednszone) and links the zone to an existing virtual network.

## Parameters

| Name                              | Type     | Required | Description                                                                                                                                                                                                                               |
| :-------------------------------- | :------: | :------: | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `zoneName`                        | `string` | Yes      | The name for the Private DNS Zone. Must be a valid domain name. For Azure services, use the recommended zone names (ref: https://learn.microsoft.com/en-gb/azure/private-link/private-endpoint-dns#azure-services-dns-zone-configuration) |
| `autoRegistrationEnabled`         | `bool`   | Yes      | When true, a DNS record gets automatically created for each virtual machine deployed in the virtual network.                                                                                                                              |
| `virtualNetworkResourceGroupName` | `string` | Yes      | The resource group name of the existing VNet.                                                                                                                                                                                             |
| `virtualNetworkName`              | `string` | Yes      | The name of the existing VNet.                                                                                                                                                                                                            |

## Outputs

| Name | Type | Description |
| :--- | :--: | :---------- |

## Examples

### Private DNS Zone for Azure SQL private endpoint

```bicep
module privatedns_zone 'br:<registry-fqdn>/bicep/general/private-dns-zone:<version>' = {
  name: '${zone}-privateDnsDeploy'
  params: {
    zoneName: 'privatelink${environment().suffixes.sqlServerHostname}'
    virtualNetworkResourceGroupName: 'my-vnet-rg'
    virtualNetworkName: 'myvnet'
    autoRegistrationEnabled: false
  }
}
```