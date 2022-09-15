# Adds or updates log analytics workspace

Adds or updates log analytics workspace

## Description

{{ Add detailed description for the module. }}

## Parameters

| Name                                         | Type     | Required | Description                                                                              |
| :------------------------------------------- | :------: | :------: | :--------------------------------------------------------------------------------------- |
| `name`                                       | `string` | Yes      | The name of the log analytics workspace                                                  |
| `location`                                   | `string` | Yes      | The location of the log analytics workspace                                              |
| `skuName`                                    | `string` | Yes      | The SKU of the log analytics workspace                                                   |
| `dailyQuotaGb`                               | `int`    | Yes      | The daily ingestion quota (in GB) of the log analytics workspace - use "-1" for no limit |
| `enableLogAccessUsingOnlyResourcePermisions` | `bool`   | Yes      |                                                                                          |
| `publicNetworkAccessForIngestion`            | `string` | Yes      |                                                                                          |
| `publicNetworkAccessForQuery`                | `string` | Yes      |                                                                                          |
| `tagValues`                                  | `object` | No       |                                                                                          |

## Outputs

| Name                | Type   | Description |
| :------------------ | :----: | :---------- |
| workspaceResourceId | string |             |

## Examples

### Example 1

```bicep
```

### Example 2

```bicep
```