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


resource communication_service 'Microsoft.Communication/communicationServices@2023-04-01-preview' = {
  name: communicationServiceName
  location: 'global'
  properties: {
    dataLocation: dataLocation
    linkedDomains: [
      email_service::azure_managed_domain.id
    ]
  }
}

resource email_service 'Microsoft.Communication/emailServices@2023-04-01-preview' = {
  name: emailServiceName
  location: 'global'
  properties: {
    dataLocation: dataLocation
  }

  resource azure_managed_domain 'domains@2023-04-01-preview' = {
    name: 'AzureManagedDomain'
    location: 'global'
    properties: {
      domainManagement: 'AzureManaged'
      userEngagementTracking: 'Disabled'
    }

    resource sender_username_azure_managed_domain 'senderUsernames@2023-04-01-preview' = {
      name: 'DoNotReply'
      properties: {
        username: 'DoNotReply'
        displayName: 'DoNotReply'
      }
    }
  }
}

@description('The Azure managed domain.')
output domain string = email_service::azure_managed_domain.properties.mailFromSenderDomain

@description('The "DoNotReply" email address for the Azure managed domain.')
output doNotReplyEmailAddress string = '${email_service::azure_managed_domain::sender_username_azure_managed_domain.properties.username}@${email_service::azure_managed_domain.properties.mailFromSenderDomain}'
