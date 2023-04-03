param prefix string = uniqueString(resourceGroup().id)
param location string = resourceGroup().location

var defaultAppIdentifierUri = 'https://endjin.com/${guid(resourceGroup().id)}'

var replyUrls = [
  'https://${guid(resourceGroup().id)}'
]

resource managed_identity 'Microsoft.ManagedIdentity/userAssignedIdentities@2021-09-30-preview' = {
  name: '${prefix}mi'
  location: location
}

module aad_app '../main.bicep' = {
  name: 'aadAppDeploy'
  params: {
    displayName: '${prefix}aadapp'
    location: location
    replyUrls: replyUrls
    appUri: defaultAppIdentifierUri
    managedIdentityResourceId: managed_identity.id
    enableAccessTokenIssuance: false
    enableIdTokenIssuance: true
    microsoftGraphScopeIdsToGrant: [
      '37f7f235-527c-4136-accd-4a02d197296e' // openid
    ]
    microsoftGraphAppRoleIdsToGrant: []
  }
}
