param keyVaultName string
param communicationServiceName string
param domain string
param sendFromEmailAddress string
param communicationServiceResourceGroupName string
param communicationServiceSubscriptionId string

resource communication_service 'Microsoft.Communication/communicationServices@2023-04-01-preview' existing = {
  scope: resourceGroup(communicationServiceSubscriptionId, communicationServiceResourceGroupName)
  name: communicationServiceName
}

module communication_service_key_secret '../key-vault-secret/main.bicep' = {
  name: 'communicationServiceKeySecretDeploy'
  params: {
    keyVaultName: keyVaultName
    secretName: 'CommunicationServiceKey'
    contentValue: communication_service.listKeys().primaryKey
    contentType: 'text/plain'
  }
}

module communication_service_connectionString_secret '../key-vault-secret/main.bicep' = {
  name: 'communicationServiceConnectionStringSecretDeploy'
  params: {
    keyVaultName: keyVaultName
    secretName: 'CommunicationServiceConnectionString'
    contentValue: communication_service.listKeys().primaryConnectionString
    contentType: 'text/plain'
  }
}

module email_service_domain_secret '../key-vault-secret/main.bicep' = {
  name: 'emailServiceDomainSecretDeploy'
  params: {
    keyVaultName: keyVaultName
    secretName: 'EmailServiceDomain'
    contentValue: domain
    contentType: 'text/plain'
  }
}

module email_service_send_from_email_address_secret '../key-vault-secret/main.bicep' = {
  name: 'emailServiceSendFromEmailAddressSecretDeploy'
  params: {
    keyVaultName: keyVaultName
    secretName: 'EmailServiceSendFromEmailAddress'
    contentValue: sendFromEmailAddress
    contentType: 'text/plain'
  }
}
