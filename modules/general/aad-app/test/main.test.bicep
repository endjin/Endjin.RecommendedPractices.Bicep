param prefix string = uniqueString(resourceGroup().id)
param location string = resourceGroup().location

var defaultAppIdentifierUri = 'https://endjin.com/${guid(resourceGroup().id)}'

var replyUrls = [
  'https://${guid(resourceGroup().id)}'
]

// NOTE: there are deliberate placeholders in this test file as it requires
// an existing MI with AAD group membership priveleges.
// To run the test deployment, replace the placeholders with appropriate values.

resource managed_identity 'Microsoft.ManagedIdentity/userAssignedIdentities@2021-09-30-preview' existing =  {
  name: 'ms-graph-deployment-mi'
  scope: resourceGroup('9a1d877d-6acd-40d3-92a1-ee057e8dcda4', 'deployment-managed-identities')
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
