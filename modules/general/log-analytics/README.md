# Adds or updates log analytics workspace

Adds or updates log analytics workspace

## Description

Deploys or updates a [Log Analytics workspace](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/log-analytics-workspace-overview).

If the resource is expected to already exist, the `useExisting` flag should be used. This will return the details of the resource without modifying it, but fail if the resource does not exist.

## Parameters

| Name                                          | Type     | Required | Description                                                                                                                                |
| :-------------------------------------------- | :------: | :------: | :----------------------------------------------------------------------------------------------------------------------------------------- |
| `name`                                        | `string` | Yes      | The name of the log analytics workspace                                                                                                    |
| `location`                                    | `string` | No       | The location of the log analytics workspace                                                                                                |
| `skuName`                                     | `string` | No       | The SKU of the log analytics workspace                                                                                                     |
| `dailyQuotaGb`                                | `int`    | Yes      | The daily ingestion quota (in GB) of the log analytics workspace - use "-1" for no limit                                                   |
| `enableLogAccessUsingOnlyResourcePermissions` | `bool`   | Yes      | When true, the log analytics workspace will only be accessible by using resource permissions                                               |
| `publicNetworkAccessForIngestion`             | `string` | Yes      | Indicates whether the public network access for ingestion is enabled or disabled                                                           |
| `publicNetworkAccessForQuery`                 | `string` | Yes      | Indicates whether the public network access for query is enabled or disabled                                                               |
| `tagValues`                                   | `object` | No       | The tag values of the log analytics workspace                                                                                              |
| `useExisting`                                 | `bool`   | No       | When true, the details of an existing log analytics workspace will be returned; When false, the log analytics workspace is created/updated |

## Outputs

| Name              | Type   | Description                                        |
| :---------------- | :----: | :------------------------------------------------- |
| workspaceResource | object | An object representing the log analytics workspace |
| name              | string | The workspace resource name                        |
| id                | string | The workspace resource ID                          |

## Examples

### Log analytics workspace

```bicep
module storage 'br:<registry-fqdn>/bicep/general/log-analytics:<version>' = {
  name: 'logAnalytics'
  params: {
    name: 'myloganalytics'
    dailyQuotaGb: 1
    enableLogAccessUsingOnlyResourcePermisions: false
    publicNetworkAccessForIngestion: true
    publicNetworkAccessForQuery: true
  }
}
```