param prefix string = uniqueString(resourceGroup().id)
param location string = resourceGroup().location

module sftp_storage '../../storage-account/main.bicep' = {
  name: 'storageDeploy'
  params: {
    name: '${prefix}sa'
    location: location
    isHnsEnabled: true
    isSftpEnabled: true
  }
}

module user1 '../main.bicep' = {
  name: 'user1'
  params: {
    storageAccountName: sftp_storage.outputs.name
    userName: 'user1'
    containerName: 'user1container'
    sshPublicKey: 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQChpCPb5AHALUB/3B29oMvaH7CeJxcZT0UKll0xmViGUMdwbahPjnV+6WfLzjnPC33504IC+12yw+yosuusAkcUtp4ASNCz9D0ZXY4cxv5efBNUyyYAHcyGr1O8ssEweoyF0sGlrps/Pf9yHNXlzanC/WAAMXwLKw2XbIS1G1ZfyolTAkdNQo46cPgGfp4VehVirABmC1wNMWgj4jcwyC0F/M4tssFkoWTEWJEB+UFX+6shnbYV2NUWQFVN4orVLRoadgl1a+VpKZ7qdoFd1lprMhKSJRG5JD9IFCjVHEsU2WLBz4xiOZkcA/LIZpBHCbZQedHN5YjjxZIpurQfLPZt5/PSjKKc/alz0afWSVeOgYRSL79SV1qmYoR+uI61WcoyWzruczgkBzM8J5JAw/ADncRZsHI7MzOeo7gl6Y8lBCHs03OP2al0OT2gv4yzBBGGlNKR/e3twHAhBoQWMTxES9c6IEkM6GlsgoHSX30tSiN2NeJJluXSgFy5UEir44M= noname'
  }
}

module user2 '../main.bicep' = {
  name: 'user2'
  params: {
    storageAccountName: sftp_storage.outputs.name
    userName: 'user2'
    containerName: 'user2container'
  }
}
