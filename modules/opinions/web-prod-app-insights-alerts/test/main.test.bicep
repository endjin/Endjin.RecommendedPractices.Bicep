var location = 'uksouth'


module appinsights '../../../general/app-insights/main.bicep' = {
  name: 'appInsights'
  params:{
    name: 'appInsights'
    location: location
  }
}

module appinsightsalert '../main.bicep' = {
  name: 'appInsightsAlert'
  params: {
    appInsightsResourceId: appinsights.outputs.id
    alertLocation: location
  }
}
