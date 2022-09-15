# Adds or updates log analytics workspace

Adds or updates log analytics workspace

## Description

{{ Add detailed description for the module. }}

## Parameters

| Name                                         | Type     | Required | Description                                                                                                                                |
| :------------------------------------------- | :------: | :------: | :----------------------------------------------------------------------------------------------------------------------------------------- |
| `name`                                       | `string` | Yes      | The name of the log analytics workspace                                                                                                    |
| `location`                                   | `string` | Yes      | The location of the log analytics workspace                                                                                                |
| `skuName`                                    | `string` | Yes      | The SKU of the log analytics workspace                                                                                                     |
| `dailyQuotaGb`                               | `int`    | Yes      | The daily ingestion quota (in GB) of the log analytics workspace - use "-1" for no limit                                                   |
| `enableLogAccessUsingOnlyResourcePermisions` | `bool`   | Yes      | When true, the log analytics workspace will only be accessible by using resource permissions                                               |
| `publicNetworkAccessForIngestion`            | `string` | Yes      | Indicates whether the public network access for ingestion is enabled or disabled                                                           |
| `publicNetworkAccessForQuery`                | `string` | Yes      | Indicates whether the public network access for query is enabled or disabled                                                               |
| `tagValues`                                  | `object` | No       | The tag values of the log analytics workspace                                                                                              |
| `useExisting`                                | `bool`   | No       | When true, the details of an existing log analytics workspace will be returned; When false, the log analytics workspace is created/updated |

## Outputs

| Name              | Type   | Description                                        |
| :---------------- | :----: | :------------------------------------------------- |
| workspaceResource | object | An object representing the log analytics workspace |
| name              | string | The workspace resource name                        |
| id                | string | The workspace resource ID                          |

## Examples

### Example 1

```bicep
```

### Example 2

```bicep
```