@description('The parent storage account of the container')
param storageAccountName string
@description('The name of the container')
param containerName string

@allowed([
  'None'
  'Blob'
  'Container'
])
param publicAccess string = 'None'

targetScope = 'resourceGroup'

resource blob_container 'Microsoft.Storage/storageAccounts/blobServices/containers@2019-06-01' = {
  name: '${storageAccountName}/default/${containerName}'
  properties: {
    publicAccess: publicAccess
  }
}

output name string = containerName
