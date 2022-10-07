param suffix string = uniqueString(resourceGroup().id)
param location string = resourceGroup().location

module storage '../../storage-account/main.bicep' = {
  name: 'storageDeploy'
  params: {
    location: location
    name: 'storage${suffix}'
  }
}

resource managed_identity 'Microsoft.ManagedIdentity/userAssignedIdentities@2021-09-30-preview' = {
  name: 'mi${suffix}'
  location: location
}

module rbac_owner '../main.bicep' = {
  name: 'rbacOwner'
  params: {
    assigneeObjectId: managed_identity.properties.principalId
    principalType: 'ServicePrincipal'
    role: 'Owner'
    storageAccountName: storage.outputs.name
  }
}

module rbac_contributor '../main.bicep' = {
  name: 'rbacContributor'
  params: {
    assigneeObjectId: managed_identity.properties.principalId
    principalType: 'ServicePrincipal'
    role: 'Contributor'
    storageAccountName: storage.outputs.name
  }
}

module rbac_reader '../main.bicep' = {
  name: 'rbacReader'
  params: {
    assigneeObjectId: managed_identity.properties.principalId
    principalType: 'ServicePrincipal'
    role: 'Reader'
    storageAccountName: storage.outputs.name
  }
}

module rbac_sbd_owner '../main.bicep' = {
  name: 'rbacSbdOwner'
  params: {
    assigneeObjectId: managed_identity.properties.principalId
    principalType: 'ServicePrincipal'
    role: 'Storage Blob Data Owner'
    storageAccountName: storage.outputs.name
  }
}

module rbac_sbd_contributor '../main.bicep' = {
  name: 'rbacSbdContributor'
  params: {
    assigneeObjectId: managed_identity.properties.principalId
    principalType: 'ServicePrincipal'
    role: 'Storage Blob Data Contributor'
    storageAccountName: storage.outputs.name
  }
}

module rbac_sbd_reader '../main.bicep' = {
  name: 'rbacSbdReader'
  params: {
    assigneeObjectId: managed_identity.properties.principalId
    principalType: 'ServicePrincipal'
    role: 'Storage Blob Data Reader'
    storageAccountName: storage.outputs.name
  }
}
