// NOTE: there are deliberate placeholders in this test file as it requires
// an existing MI with AAD group membership priveleges.
// To run the test deployment, replace the placeholders with appropriate values.

param location string = resourceGroup().location

resource managed_identity 'Microsoft.ManagedIdentity/userAssignedIdentities@2021-09-30-preview' existing =  {
  name: '<name>'
  scope: resourceGroup('<subscription-id>', '<resource-group-name>')
}

module aad_group_membership '../main.bicep' = {
  name: 'aadGroupMembership'
  params: {
    location: location
    managedIdentityResourceId: managed_identity.id
    groupName: 'EndjinRecommendedPracticesBicepTestGroup'
    requiredMembers: [
      '<user1>'
      '<user2>'
    ]
  }
}
