@description('The location in which the deployment script will be ran')
param location string

@description('The display name of the AzureAD application')
param displayName string

@description('The reply application reply URLs')
param replyUrls array = []

@description('The URL to the application homepage')
param appUri string

@description('When true, allows the AzureAD application to issue access tokens (used for implicit flow)')
param enableAccessTokenIssuance bool

@description('When true, allows the AzureAD application to issue ID tokens (used for implicit & hybrid flows)')
param enableIdTokenIssuance bool

@description('The resource identifier of the managed identity used for the deployment script')
param managedIdentityResourceId string

@description('Microsoft Graph scope IDs to grant the AzureAD application')
param microsoftGraphScopeIdsToGrant array = []

@description('Microsoft Graph role IDs to grant the AzureAD application')
param microsoftGraphAppRoleIdsToGrant array = []

var name = 'AadAppScript'
var scriptPath = './create-aad-app.ps1'
var scriptContent = loadTextContent(scriptPath)
var scriptArguments = [
  '-DisplayName \\"${displayName}\\"'
  '-ReplyUrlsDelimited \\"${join(replyUrls, ',')}\\"'
  '-AadTenantId ${tenant().tenantId}'
  '-AppUri \\"${appUri}\\"'
  '-EnableAccessTokenIssuance $${enableAccessTokenIssuance}'
  '-EnableIdTokenIssuance $${enableIdTokenIssuance}'
  '-MicrosoftGraphScopeIdsToGrantDelimited \\"${join(microsoftGraphScopeIdsToGrant, ',')}\\"'
  '-MicrosoftGraphAppRoleIdsToGrantDelimited \\"${join(microsoftGraphAppRoleIdsToGrant, ',')}\\"'
]

resource aad_app 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
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

@description('The ID of the AzureAD application')
output applicationId string = aad_app.properties.outputs.applicationId

@description('The object ID of the AzureAD application')
output objectId string = aad_app.properties.outputs.objectId

@description('The display name of the AzureAD application')
output displayName string = displayName
