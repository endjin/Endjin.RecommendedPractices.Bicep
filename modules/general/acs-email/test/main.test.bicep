param prefix string = uniqueString(resourceGroup().id)

module acs_email '../main.bicep' = {
  name: 'acsEmailDeploy'
  params: {
    communicationServiceName: '${prefix}-acs'
    emailServiceName: '${prefix}-acs-email'
    dataLocation: 'Switzerland'
  }
}
