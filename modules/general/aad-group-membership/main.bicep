// <copyright file="aad-group-membership.bicep" company="Endjin Limited">
// Copyright (c) Endjin Limited. All rights reserved.
// </copyright>

@description('The location for the deployment script resource.')
param location string

@description('The resource ID for the Managed Identity (MI) that the deployment script will run as. The MI must have permission to manage users in the target Azure AD group.')
param managedIdentityResourceId string

@description('The display name of the Azure AD group to assert membership on.')
param groupName string

@description('The list of Azure AD objects that should be members of the group. These can be specified using \'DisplayName\', \'ObjectId\', \'ApplicationId\' or \'UserPrincipalName\'.')
param requiredMembers array = []

@description('When true, existing group members not specified in the `requiredMembers` parameters will be removed from the group.')
param strictMode bool = false

var membersDelimited = join(requiredMembers, ',')
var name = 'AadGroupMembershipScript-${groupName}-${guid(membersDelimited)}'
var scriptPath = './aad-group-membership.ps1'
var scriptContent = loadTextContent(scriptPath)
var scriptArguments = [
  '-AadTenantId ${tenant().tenantId}'
  '-GroupName ${groupName}'
  '-RequiredMembersDelimited \\"${membersDelimited}\\"'
  '-StrictMode $${strictMode}'
]

resource aad_group_membership 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: name
  location: location
  kind: 'AzurePowerShell'
  properties: {
    azPowerShellVersion: '8.3'
    retentionInterval: 'P1D'
    cleanupPreference: 'Always'
    scriptContent: scriptContent
    arguments: join(scriptArguments, ' ')
  }
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentityResourceId}': {}
    }
  }
}
