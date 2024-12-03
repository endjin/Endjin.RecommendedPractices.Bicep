# Synapse Spark Pools

Adds/Updates Synapse Spark Pools in an existing Synapse workspace.

## Details

Deploys [Apache Spark Pools](https://learn.microsoft.com/en-us/azure/synapse-analytics/spark/apache-spark-concepts) into an existing Synapse workspace. The properties for the pools are documented here: https://docs.microsoft.com/en-us/azure/templates/microsoft.synapse/2021-03-01/workspaces/bigdatapools?tabs=json

## Parameters

| Name                      | Type     | Required | Description                                                                                                                                                                                                                                                                                                                                                                                                     |
| :------------------------ | :------: | :------: | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `workspaceName`           | `string` | Yes      | The Synapse workspace that the spark pools are linked to                                                                                                                                                                                                                                                                                                                                                        |
| `location`                | `string` | Yes      | The location of the spark pool                                                                                                                                                                                                                                                                                                                                                                                  |
| `sparkPools`              | `array`  | Yes      | An array of objects defining the spark pools that should be provisioned, with the structure {name: "<poolName>", properties: {<object>} } - where the properties object matches the schema documented here: https://docs.microsoft.com/en-us/azure/templates/microsoft.synapse/2021-03-01/workspaces/bigdatapools?tabs=json.  Also note that the first pool defined will be discoverable via App Configuration. |
| `enableDiagnostics`       | `bool`   | No       | When true, the log diagnostic settings supported by the spark pool will be enabled                                                                                                                                                                                                                                                                                                                              |
| `logAnalyticsWorkspaceId` | `string` | No       | The log analytics workspace Id where diagnostics log data will be sent                                                                                                                                                                                                                                                                                                                                          |
| `tagValues`               | `object` | No       | The resource tags applied to resources                                                                                                                                                                                                                                                                                                                                                                          |

## Outputs

| Name                   | Type     | Description                                                                                                        |
| :--------------------- | :------: | :----------------------------------------------------------------------------------------------------------------- |
| `defaultSparkPoolName` | `string` | The name of the default Spark Pool. Note: the first configured Spark Pool will be considered the notional default. |

## Examples

### Deploy multiple Spark Pools

```bicep
module spark_pools '../main.bicep' = {
  name: 'sparkPoolsDeploy'
  params: {
    location: location
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
    workspaceName: 'mysynapseworkspace'
  }
}
```