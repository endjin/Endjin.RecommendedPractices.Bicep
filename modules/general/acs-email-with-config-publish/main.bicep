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
param keyVaultResourceGroup string = resourceGroup().name

module acs_email '../acs-email/main.bicep' = {
  name: 'AcsEmailDeploy'
  params: {
    communicationServiceName: communicationServiceName
    dataLocation: dataLocation
    emailServiceName: emailServiceName
    senderUsername: senderUsername
  }
}

module set_secrets './set-secrets.bicep' = {
  name: 'acsEmailSetSecretsDeploy'
  scope: resourceGroup(keyVaultResourceGroup)
  params: {
    keyVaultName: keyVaultName
    communicationServiceName: communicationServiceName
    domain: acs_email.outputs.domain
    sendFromEmailAddress: acs_email.outputs.sendFromEmailAddress
  }
}

@description('The Azure managed domain.')
output domain string = acs_email.outputs.domain

@description('The send-from email address for the Azure managed domain.')
output sendFromEmailAddress string = acs_email.outputs.sendFromEmailAddress
