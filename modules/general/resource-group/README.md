# Resource Group

Deploys a resource group or gets a reference to an existing one - useful for deferred evaluation of target resource group details

## Parameters

| Name           | Type     | Required | Description                                                                                                              |
| :------------- | :------: | :------: | :----------------------------------------------------------------------------------------------------------------------- |
| `name`         | `string` | Yes      | The name of the resource group                                                                                           |
| `location`     | `string` | Yes      | The location of the resource group                                                                                       |
| `useExisting`  | `bool`   | No       | When true, the details of an existing resource group will be returned; When false, the resource group is created/updated |
| `resourceTags` | `object` | No       | The resource tags applied to resources                                                                                   |

## Outputs

| Name                  | Type   | Description                                        |
| :-------------------- | :----: | :------------------------------------------------- |
| id                    | string | The resource ID of the resource group              |
| name                  | string | The name of the resource group                     |
| resourceGroupResource | object | An object representing the resource group resource |

## Examples

### Example 1

```bicep
```

### Example 2

```bicep
```