# Storage Account Local User

Creates a local user for use with SFTP on a storage account.

## Details

Creates a local user with permissions over the specified blob container. If the blob container does not exist, it will be created as part of deployment.

Authentication for the local user can be done either using an SSH key pair and providing the public key as the `sshPublicKey` parameter, or if this is left blank then you can go to the Azure Portal after deployment to generate a SSH password.

## Parameters

| Name                 | Type     | Required | Description                                                                                                                                                                 |
| :------------------- | :------: | :------: | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `storageAccountName` | `string` | Yes      | The name of existing storage account in which to create the local user.                                                                                                     |
| `userName`           | `string` | Yes      | The user name for the local user.                                                                                                                                           |
| `containerName`      | `string` | Yes      | The blob container the user will have permissions to access. If the container does not exist, it will be created.                                                           |
| `permissions`        | `string` | No       | The permissions the user will have over the container. Possible values include: Read (r), Write (w), Delete (d), List (l), and Create (c).                                  |
| `sshPublicKey`       | `string` | No       | The SSH public key to match the private key that will be used by the user for authentication. If left blank, a password will need to be generated through the Azure Portal. |

## Outputs

| Name | Type | Description |
| :--- | :--: | :---------- |

## Examples

### Local user with SSH key-pair authentication

Generate an SSH key pair prior to deployment and set the public key value as `sshPublicKey`.

```bicep
module local_user 'br:<registry-fqdn>/bicep/general/storage-account-local-user:<version>' = {
  name: 'user1'
  params: {
    storageAccountName: 'mystorageaccount'
    userName: 'user1'
    containerName: 'user1container'
    sshPublicKey: 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQChpCPb5AHALUB/3B29oMvaH7CeJxcZT0UKll0xmViGUMdwbahPjnV+6WfLzjnPC33504IC+12yw+yosuusAkcUtp4ASNCz9D0ZXY4cxv5efBNUyyYAHcyGr1O8ssEweoyF0sGlrps/Pf9yHNXlzanC/WAAMXwLKw2XbIS1G1ZfyolTAkdNQo46cPgGfp4VehVirABmC1wNMWgj4jcwyC0F/M4tssFkoWTEWJEB+UFX+6shnbYV2NUWQFVN4orVLRoadgl1a+VpKZ7qdoFd1lprMhKSJRG5JD9IFCjVHEsU2WLBz4xiOZkcA/LIZpBHCbZQedHN5YjjxZIpurQfLPZt5/PSjKKc/alz0afWSVeOgYRSL79SV1qmYoR+uI61WcoyWzruczgkBzM8J5JAw/ADncRZsHI7MzOeo7gl6Y8lBCHs03OP2al0OT2gv4yzBBGGlNKR/e3twHAhBoQWMTxES9c6IEkM6GlsgoHSX30tSiN2NeJJluXSgFy5UEir44M= noname'
  }
}
```

### Local user with SSH password authentication

```bicep
module local_user 'br:<registry-fqdn>/bicep/general/storage-account-local-user:<version>' = {
  name: 'user2'
  params: {
    storageAccountName: 'mystorageaccount'
    userName: 'user2'
    containerName: 'user2container'
  }
}
```

After deployment, the SSH password can be generate via the Azure Portal:

1. Navigate to the storage account resource
2. Select Settings | SFTP
3. Select 'Configure' for the user
4. Tick 'SSH Password' and save

The generated password will be displayed. Copy this value as it cannot be retrieved again.