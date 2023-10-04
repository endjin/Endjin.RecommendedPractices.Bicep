param prefix string = uniqueString(resourceGroup().id)

module action_group '../main.bicep' = {
  name: '${prefix}ActionGroupDeploy'
  params: {
    name: 'test action group'
    notifyEmailAddresses: [
      'noone@nowhere.org'
    ]
    shortName: 'test-group'
  }
}
