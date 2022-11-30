@description('The name of existing storage account in which to create the local user.')
param storageAccountName string

@description('The user name for the local user.')
param userName string

@description('The blob container the user will have permissions to access. If the container does not exist, it will be created.')
param containerName string

@description('The permissions the user will have over the container. Possible values include: Read (r), Write (w), Delete (d), List (l), and Create (c).')
param permissions string = 'rcwdl'

@description('The SSH public key to match the private key that will be used by the user for authentication. If left blank, a password will need to be generated through the Azure Portal.')
param sshPublicKey string = ''

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-05-01' existing = {
  name: storageAccountName
}

resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2022-05-01' existing = {
  name: 'default'
  parent: storageAccount
}

resource container 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-05-01' = {
  name: containerName
  parent: blobService
}

resource user 'Microsoft.Storage/storageAccounts/localUsers@2022-05-01' = {
  name: userName
  parent: storageAccount
  properties: {
    permissionScopes: [
      {
        permissions: permissions
        service: 'blob'
        resourceName: containerName
      }
    ]
    homeDirectory: containerName
    sshAuthorizedKeys: empty(sshPublicKey) ? null : [
      {
        description: '${userName} public key'
        key: sshPublicKey
      }
    ]
    hasSharedKey: false
  }
}
