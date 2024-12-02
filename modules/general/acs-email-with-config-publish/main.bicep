metadata name = 'acs-email-managed-domain-with-published-config'
metadata description = 'Azure Communication Email Service with managed Azure domain, with published configuration'
metadata owner = 'endjin'

@description('The name of the Azure Communication Service resource.')
param communicationServiceName string

@description('The name of the Email Communication Service resource.')
param emailServiceName string

@description('The location where the communication and email service stores its data at rest.')
@allowed([
  'Africa'
  'Asia Pacific'
  'Australia'
  'Brazil'
  'Canada'
  'Europe'
  'France'
  'Germany'
  'India'
  'Japan'
  'Korea'
  'Norway'
  'Switzerland'
  'United Arab Emirates'
  'UK'
  'United States'
])
param dataLocation string

@description('The username for the sender email address. Defaults to "DoNotReply".')
param senderUsername string = 'DoNotReply'

@description('The name of the key vault where the configuration will be published')
param keyVaultName string

@description('The resource group of the key vault where the configuration will be published')
param keyVaultResourceGroupName string = resourceGroup().name

@description('The subscription of the key vault where the configuration will be published')
param keyVaultSubscriptionId string = subscription().subscriptionId

@description('If true, enable diagnostics on the workspace (`logAnalyticsWorkspaceId` must also be set).')
param enableDiagnostics bool = false

@description('When `enableDiagnostics` is true, the workspace ID (resource ID of a Log Analytics workspace) for a Log Analytics workspace to which you would like to send Diagnostic Logs.')
param logAnalyticsWorkspaceId string = ''

module acs_email '../acs-email/main.bicep' = {
  name: 'AcsEmailDeploy'
  params: {
    communicationServiceName: communicationServiceName
    dataLocation: dataLocation
    emailServiceName: emailServiceName
    senderUsername: senderUsername
    enableDiagnostics: enableDiagnostics
    logAnalyticsWorkspaceId: logAnalyticsWorkspaceId
  }
}

module set_secrets './set-secrets.bicep' = {
  name: 'acsEmailSetSecretsDeploy'
  scope: resourceGroup(keyVaultSubscriptionId, keyVaultResourceGroupName)
  params: {
    keyVaultName: keyVaultName
    communicationServiceName: communicationServiceName
    domain: acs_email.outputs.domain
    sendFromEmailAddress: acs_email.outputs.sendFromEmailAddress
    communicationServiceResourceGroupName: resourceGroup().name
    communicationServiceSubscriptionId: subscription().subscriptionId
  }
}

@description('The Azure managed domain.')
output domain string = acs_email.outputs.domain

@description('The send-from email address for the Azure managed domain.')
output sendFromEmailAddress string = acs_email.outputs.sendFromEmailAddress

