# container-registry

Azure Container Registry

## Details

Deploys or updates an [Azure Container Registry](https://azure.microsoft.com/en-us/products/container-registry/) resource.

If the resource is expected to already exist, the `useExisting` flag should be used. This will return the details of the resource without modifying it, but fail if the resource does not exist.

## Parameters

| Name               | Type     | Required | Description                                                                                        |
| :----------------- | :------: | :------: | :------------------------------------------------------------------------------------------------- |
| `name`             | `string` | Yes      | The name of the container registry                                                                 |
| `location`         | `string` | Yes      | The location of the container registry                                                             |
| `sku`              | `string` | Yes      | SKU for the container registry                                                                     |
| `adminUserEnabled` | `bool`   | No       | When true, admin access via the ACR key is enabled; When false, access is via RBAC                 |
| `useExisting`      | `bool`   | No       | When true, the details of an existing ACR will be returned; When false, the ACR is created/updated |
| `resourceTags`     | `object` | No       | The resource tags applied to resources                                                             |

## Outputs

| Name          | Type     | Description                                            |
| :------------ | :------: | :----------------------------------------------------- |
| `id`          | `string` | The resource ID of the container registry              |
| `name`        | `string` | The name of the container registry                     |
| `loginServer` | `string` | The admin username of the container registry           |
| `acrResource` | `object` | An object representing the container registry resource |

## Examples

### Example 1

```bicep
```

### Example 2

```bicep
```