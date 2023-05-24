@description('The display name of the AzureAD service principal')
param displayName string

@description('The key vault where the service principal credential details will be stored')
param keyVaultName string

@description('Name of the key vault secret that will hold where the service principal credential details')
param keyVaultSecretName string

@description('The resource identifier of the managed identity used for the deployment script.')
param managedIdentityResourceId string

@description('The location in which the deployment script will be ran')
param location string = resourceGroup().location

@description('Sets the expiration of any newly-created credentials')
param passwordLifetimeDays int

@description('When true, the credentials will be added to the AzureAD application instead of the service principal')
param useApplicationCredential bool = false

@description('When true, the existing credentials will be rotated')
param rotateSecret bool = false

@description('The display name metadata for the credential')
param credentialDisplayName string = 'Created by the \'aad-serviceprincipal\' ARM deployment script'

@description('The resource tags applied to resources')
param resourceTags object = {}

var name = 'AadServicePrincipalScript-${displayName}'
var scriptPath = 'deploy-aad-service-principal.ps1'
var scriptContent = loadTextContent(scriptPath)
var scriptArguments = [
  '-DisplayName \\"${displayName}\\"'
  '-KeyVaultName \\"${keyVaultName}\\"'
  '-KeyVaultSecretName \\"${keyVaultSecretName}\\"'
  '-CredentialDisplayName \\"${credentialDisplayName}\\"'
  '-UseApplicationCredential $${useApplicationCredential}'
  '-PasswordLifetimeDays ${passwordLifetimeDays}'
  '-RotateSecret $${rotateSecret}'
]

resource aad_service_principal 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
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
  tags: resourceTags
}

@description('The application/client ID of the AzureAD service principal')
output app_id string = aad_service_principal.properties.outputs.appId

@description('The object/principal ID of the AzureAD service principal')
output object_id string = aad_service_principal.properties.outputs.objectId
