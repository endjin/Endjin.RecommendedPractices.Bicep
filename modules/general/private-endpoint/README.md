# Private Endpoint

Deploys a private endpoint for the specified resource

## Description

Deploys a [Private Endpoint](https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-overview) that allows connecting to PaaS resources that support Private Link.

The module also optionally registers the Private Endpoint with the appropriate [PrivateDns zone](https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-dns) - the required DNS zone for a number of common sub-resource types can be automatically resolved.

## Parameters

| Name                            | Type     | Required | Description                                                                                                                                                                                                  |
| :------------------------------ | :------: | :------: | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `name`                          | `string` | Yes      | The name of the private endpoint                                                                                                                                                                             |
| `location`                      | `string` | Yes      | The location of the private endpoint                                                                                                                                                                         |
| `virtualNetworkSubscriptionId`  | `string` | No       | The subscription of the virtual network the private endpoint will be connected to                                                                                                                            |
| `virtualNetworkResourceGroup`   | `string` | Yes      | The resource group of the virtual network the private endpoint will be connected to                                                                                                                          |
| `virtualNetworkName`            | `string` | Yes      | The name of the virtual network the private endpoint will be connected to                                                                                                                                    |
| `subnetName`                    | `string` | Yes      | The name of the subnet the private endpoint will be connected to                                                                                                                                             |
| `serviceResourceId`             | `string` | Yes      | The resource Id of the service that will be accessible via this private endpoint                                                                                                                             |
| `serviceGroupId`                | `string` | Yes      | The service's sub-resource (if any) to be associated with the private endpoint                                                                                                                               |
| `appendServiceToName`           | `bool`   | No       | When true, the serviceGroupId will be appended to the private endpoint name with the convention: &lt;name&gt;-&lt;serviceGroupId&gt;. Useful when a resource exposes multiple services as private endpoints. |
| `enablePrivateDns`              | `bool`   | Yes      | When true, the private endpoint sub-resource will be registered with the relevant PrivateDns zone                                                                                                            |
| `privateDnsZonesSubscriptionId` | `string` | No       | The subscription where the PrivateDns zones are managed, defaults to the virtual network resource group                                                                                                      |
| `privateDnsZonesResourceGroup`  | `string` | No       | The resource group where the PrivateDns zones are managed, defaults to the virtual network resource group                                                                                                    |
| `privateDnsZoneName`            | `string` | No       | The PrivateDns zone the private endpoint will be registered in. When blank, the module will attempt to identify the required zone from a list of common services                                             |
| `tagValues`                     | `object` | No       | The resource tags applied to resources                                                                                                                                                                       |

## Outputs

| Name                    | Type   | Description                                          |
| :---------------------- | :----: | :--------------------------------------------------- |
| privateEndpointId       | string | The resource ID of the private endpoint              |
| privateDnsZoneId        | string | The resource ID of the PrivateDns zone               |
| privateEndpointResource | object | An object representing the private endpoint resource |

## Examples

### Example 1

This example demonstrates a simplified setup for a single private endpoint connection to a single sub-resource, where all related resources are in the same resource group.

```bicep
resource keyvault 'Microsoft.KeyVault/vaults@2021-06-01-preview' existing = {
  name: 'my-keyvault'
}

module private_endpoint 'br:<registry-fqdn>/bicep/general/private-endpoint:<version>' = {
  name: 'privateEndpointDeploy'
  params: {
    enablePrivateDns: true
    location: location
    name: prefix
    privateDnsZonesResourceGroup: resourceGroup().name
    serviceGroupId: 'vault'
    serviceResourceId: keyvault.id
    subnetName: 'default'
    virtualNetworkName: 'my-vnet'
    virtualNetworkResourceGroup: resourceGroup().name
  }
}
```

### Example 2

This example demonstrates setting-up private endpoints for multiple services associated with a given resource, as well as how to reference networking resources deployed in a different resource group and subscription.

```bicep
resource storage 'Microsoft.Storage/storageAccounts@2021-09-01' existing = {
  name: 'my-storage'
}

var networkingSubscriptionId = 'cf3202e8-c835-4a42-b074-05b4278ea8b5'

module private_endpoint_blob 'br:<registry-fqdn>/bicep/general/private-endpoint:<version>' = {
  name: 'privateEndpointDeployBlob'
  params: {
    enablePrivateDns: true
    location: location
    name: prefix
    privateDnsZonesResourceGroup: 'my-dns-rg'
    privateDnsZonesSubscriptionId: networkingSubscriptionId
    serviceGroupId: 'blob'
    serviceResourceId: storage.id
    subnetName: 'default'
    virtualNetworkName: 'my-vnet'
    virtualNetworkResourceGroup: 'my-networking-rg'
    virtualNetworkSubscriptionId: networkingSubscriptionId
  }
}

module private_endpoint_dfs 'br:<registry-fqdn>/bicep/general/private-endpoint:<version>' = {
  name: 'privateEndpointDeployDfs'
  params: {
    enablePrivateDns: true
    location: location
    name: prefix
    privateDnsZonesResourceGroup: 'my-dns-rg'
    privateDnsZonesSubscriptionId: networkingSubscriptionId
    serviceGroupId: 'dfs'
    serviceResourceId: storage.id
    subnetName: 'default'
    virtualNetworkName: prefix
    virtualNetworkResourceGroup: 'my-networking-rg'
    virtualNetworkSubscriptionId: networkingSubscriptionId
  }
}
```