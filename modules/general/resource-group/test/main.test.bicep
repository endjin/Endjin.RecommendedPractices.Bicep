param prefix string = uniqueString(subscription().id, 'bicep-rg-test')
param location string = 'northeurope'

targetScope = 'subscription'

module rg '../main.bicep' = {
  name: 'rgDeploy'
  params: {
    location: location
    name: '${prefix}-rg'
  }
}
