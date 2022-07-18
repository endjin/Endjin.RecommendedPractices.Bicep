param displayName string
param replyUrl string
param managedIdentityResourceId string
param location string = resourceGroup().location
param resourceTags object = {}

targetScope = 'resourceGroup'

var deployScriptResourceName = 'aad-app-deployscript-${displayName}'
var scriptFilePath = './aad-app-registration.ps1'
var scriptContent = loadTextContent(scriptFilePath)

resource aad_deploy_script 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: deployScriptResourceName
  location: location
  kind: 'AzurePowerShell'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentityResourceId}': {}
    }
  }
  properties: {
    arguments: '-DisplayName \\"${displayName}\\" -ReplyUrls @(\\"${replyUrl}\\") -Verbose'
    // azPowerShellVersion: '7'
    cleanupPreference: 'OnSuccess'
    retentionInterval: 'P1D'
    scriptContent: scriptContent
    timeout: 'PT30M'
  }
  tags: resourceTags
}

output application_id string = aad_deploy_script.properties.outputs.applicationId
output object_id string = aad_deploy_script.properties.outputs.objectId
