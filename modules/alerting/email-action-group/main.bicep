@description('The name of the action group')
param name string

@description('The short name of the action group')
param shortName string

@description('When true, the action group is enabled and will send notifications')
param enabled bool = true

@description('The email addresses to notify')
param notifyEmailAddresses array


var emailReceivers = [for email in notifyEmailAddresses: {
  name: email
  emailAddress: email
  useCommonAlertSchema: false
}]

resource action_group 'microsoft.insights/actionGroups@2022-06-01' = {
  name: name
  location: 'global'
  properties: {
    enabled: enabled
    groupShortName: shortName
    emailReceivers: emailReceivers
    smsReceivers: []
    webhookReceivers: []
    eventHubReceivers: []
    itsmReceivers: []
    azureAppPushReceivers: []
    automationRunbookReceivers: []
    voiceReceivers: []
    logicAppReceivers: []
    azureFunctionReceivers: []
    armRoleReceivers: []
  }
}

@description('The resource ID of the action group')
output id string = action_group.id

@description('The name of the action group')
output name string = action_group.name

// Returns the full Resource Group resource object (workaround whilst resource types cannot be returned directly)
@description('An object representing the action group resource')
output resource object = action_group
