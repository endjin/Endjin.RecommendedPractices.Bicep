param prefix string = uniqueString(resourceGroup().id)
param location string = resourceGroup().location
param corvusModulePackageVersion string = '0.3.8'
param allowPrereleaseCorvusModuleVersion bool = false

var defaultAppIdentifierUri = 'https://endjin.com/${guid(resourceGroup().id)}'

var replyUrls = [
  'https://${guid(resourceGroup().id)}'
]

// NOTE: there are deliberate placeholders in this test file as it requires
// an existing MI with AAD group membership privileges.
// To run the test deployment, replace the placeholders with appropriate values.

resource managed_identity 'Microsoft.ManagedIdentity/userAssignedIdentities@2021-09-30-preview' existing = {
  name: '<name>'
  scope: resourceGroup('<subscription-id>', '<resource-group-name>')
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
    appRoles: [
      {
        roleId: 'bcaf9595-6d17-42b3-98ab-def86b7c7d2d'
        displayName: 'Administrator'
        description: 'Able to administer the service'
        value: 'Admin'
        allowedMemberTypes: [
            'User'
            'Application'
        ]
      }
      {
        roleId: '685806dd-6a78-4092-928f-eff9c6f6cbb8'
        displayName: 'User'
        description: 'Able to use the service'
        value: 'User'
        allowedMemberTypes: [
            'User'
            'Application'
        ]
      }
    ]
    corvusModulePackageVersion: corvusModulePackageVersion
    allowPrereleaseCorvusModuleVersion: allowPrereleaseCorvusModuleVersion
  }
}
