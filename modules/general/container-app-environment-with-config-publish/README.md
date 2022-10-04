# Container App Environment with published configuration

Deploys a ContainerApp hosting environment and publishes related configuration to App Configuration and Key Vault

## Description

Deploys or updates a [Container Apps Environment](https://learn.microsoft.com/en-us/azure/container-apps/environment) resource which can then be used to deploy Container Apps. Also deploys a Log Analytics workspace and App Insights resource. Once deployment is complete, it publishes the following:

| Value                                                 | Destination                           | Key/Secret name                     |
|:------------------------------------------------------|:--------------------------------------|:------------------------------------|
| The resource Id of the Container Apps environment     | The specified App Configuration store | `ContainerAppEnvironmentResourceId` |
| The instrumentation key for the App Insights resource | The specified Key Vault               | `AppInsightsInstrumentationKey`     |

If the resource is expected to already exist, the `useExisting` flag should be used. This will publish the values shown above and return the details of the resource without modifying it, but will fail if the resource does not exist.

## Parameters

| Name                                     | Type     | Required | Description                                                                                                                                                         |
| :--------------------------------------- | :------: | :------: | :------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `name`                                   | `string` | Yes      | The name of the container app hosting environment                                                                                                                   |
| `location`                               | `string` | Yes      | The location of the container app hosting environment                                                                                                               |
| `createContainerRegistry`                | `bool`   | Yes      | When true, an Azure Container Registry will be provisioned                                                                                                          |
| `containerRegistryName`                  | `string` | Yes      | The name of the container registry                                                                                                                                  |
| `containerRegistrySku`                   | `string` | Yes      | The SKU for the container registry                                                                                                                                  |
| `useExisting`                            | `bool`   | Yes      | When true, the details of an existing container app hosting environment will be returned; When false, the container app hosting environment will be created/updated |
| `appConfigurationStoreName`              | `string` | Yes      | The name of the app configuration store where the config will be published                                                                                          |
| `appConfigurationStoreResourceGroupName` | `string` | Yes      | The resource group for the app configuration store where the config will be published                                                                               |
| `appConfigurationStoreSubscription`      | `string` | Yes      | The subscription for the app configuration store where the config will be published                                                                                 |
| `appConfigurationLabel`                  | `string` | Yes      | The app configuration label to apply to the published config                                                                                                        |
| `keyVaultName`                           | `string` | Yes      | The name of the key vault where the app insights instrumentation key will be published                                                                              |
| `resourceTags`                           | `object` | No       | The resource tags applied to resources                                                                                                                              |

## Outputs

| Name                   | Type   | Description                                                   |
| :--------------------- | :----: | :------------------------------------------------------------ |
| id                     | string | The resource ID of the container app environment              |
| name                   | string | The name of the container app environment                     |
| appEnvironmentResource | object | An object representing the container app environment resource |
| acrId                  | string | The resource ID of the container registry                     |
| acrUsername            | string | The admin username for the container registry                 |
| acrLoginServer         | string | The login server for the container registry                   |

## Examples

### Example 1

```bicep
```

### Example 2

```bicep
```